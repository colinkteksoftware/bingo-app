import 'package:bingo/utils/colores.dart';
import 'package:flutter/material.dart';

class BingoActionsWidget extends StatelessWidget {
  final Size size;
  final Function() onPaymentPressed;
  final Function() onSalesPressed;
  final Function() onUvtPressed;
  final Function() onCustomerPressed;

  const BingoActionsWidget({
    Key? key,
    required this.size,
    required this.onPaymentPressed,
    required this.onSalesPressed,
    required this.onUvtPressed,
    required this.onCustomerPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionCard(
          size,
          icon: Icons.payments_rounded,
          label: "Pago",
          onPressed: onPaymentPressed,
        ),
        _buildActionCard(
          size,
          icon: Icons.confirmation_number_rounded,
          label: "Ventas",
          onPressed: onSalesPressed,
        ),
        _buildActionCard(
          size,
          icon: Icons.calculate_rounded,
          label: "UVT",
          onPressed: onUvtPressed,
        ),
        _buildActionCard(
          size,
          icon: Icons.people_alt_rounded,
          label: "Clientes",
          onPressed: onCustomerPressed,
        ),
      ],
    );
  }

  Widget _buildActionCard(
    Size size, {
    required IconData icon,
    required String label,
    required Function() onPressed,
  }) {
    final double cardSize = size.width * 0.19;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          width: cardSize,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: superficieCard,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: sombraCard,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primaryBlue, size: cardSize * 0.28),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: size.width * 0.028,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
