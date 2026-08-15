import 'dart:ui';
import 'package:bingo/utils/colores.dart';
import 'package:flutter/material.dart';

/// Soft, professional backdrop: neutral gradient with blurred brand-color
/// blobs, replacing the previous flat cyan/solid-rectangle look.
class Background extends StatelessWidget {
  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [fondoGradientTop, fondoGradientBottom],
          stops: [0.2, 1.0]));

  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: boxDecoration,
        ),
        const Positioned(top: -130, left: -15, child: CustomBox()),
        const Positioned(top: 340, left: 105, child: CustomBox2()),
      ],
    );
  }
}

/// Blurred circular accent blob; softer and more modern than a solid box.
class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _Blob({required this.size, required this.color, this.opacity = 0.28});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withOpacity(opacity), color.withOpacity(0.0)],
          ),
        ),
      ),
    );
  }
}

class CustomBox extends StatelessWidget {
  const CustomBox({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Blob(size: 420, color: acentoNavy, opacity: 0.16);
  }
}

class CustomBox2 extends StatelessWidget {
  const CustomBox2({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Blob(size: 340, color: acentoTeal, opacity: 0.20);
  }
}

class CustomBox3 extends StatelessWidget {
  const CustomBox3({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Blob(size: 420, color: acentoNavy, opacity: 0.22);
  }
}

class CustomBox4 extends StatelessWidget {
  const CustomBox4({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Blob(size: 340, color: acentoDorado, opacity: 0.18);
  }
}