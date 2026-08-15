import 'dart:async';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/ui/bingo/widgets/bingo_action.dart';
import 'package:bingo/ui/bingo/widgets/booklet_detail.dart';
import 'package:bingo/ui/bingo/widgets/bingo_detail.dart';
import 'package:bingo/ui/home/widgets/customer_widget.dart';
import 'package:bingo/ui/payment/payment_widget.dart';
import 'package:bingo/ui/home/widgets/uvt_widget.dart';
import 'package:bingo/ui/sale/sale_widget.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/camera_permission.dart';
import 'package:bingo/utils/colores.dart';
import 'package:bingo/utils/custom_back_button.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:bingo/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final pf = Preferencias();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.text = '0';
    _initializeApp();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    await PermissionUtils.requestCameraPermission(context);
    await initializeCameras();
    _startPolling();
  }

  Future<void> initializeCameras() async {
    if (await Permission.camera.isDenied) {
      PermissionUtils.requestCameraPermission(context);
    }
    if (await Permission.camera.isDenied) {
      PermissionUtils.requestCameraPermission(context);
    }
    try {} catch (e) {
      openAppSettings();
      print('Error initializing camera: $e');
    }
  }

  void _startPolling() {
    final provider = Provider.of<BingoProvider>(context, listen: false);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {    
      try {
        await provider.getBingoById();
      } catch (e) {
        print("Error al obtener el bingo: $e");
      }      
    });
  }

  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [fondoGradientTop, fondoGradientBottom],
          stops: [0.3, 0.9]));

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final provider = Provider.of<BingoProvider>(context);
    return Scaffold(
      body: SafeArea(
          top: true,
          child: Container(
            height: double.infinity,
            width: size.width,
            decoration: const BoxDecoration(
              color: Color(0xFFcaf0f8),
            ),
            alignment: const AlignmentDirectional(0.0, -1.0),
            child: SingleChildScrollView(
                child: Stack(
              children: <Widget>[
                Container(
                  decoration: boxDecoration,
                ),
                const Positioned(
                  top: -130,
                  left: -15,
                  child: Column(
                    children: [
                      CustomBox(),
                    ],
                  ),
                ),
                const Positioned(
                  top: 340,
                  left: 105,
                  child: Column(
                    children: [
                      CustomBox2(),
                    ],
                  ),
                ),
                Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Container(
                        height: size.height,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 250,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/logo.png"),
                                              fit: BoxFit.fill),
                                        ),
                                        alignment:
                                            const AlignmentDirectional(0, 0),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Bienvenido/a: ${pf.getSellerName} ${pf.getSellerLast}",
                                                  style: TextStyle(
                                                    color: primaryBlue,
                                                    fontSize: size.width * 0.04,
                                                    fontFamily: 'gotic',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Column(
                                        children: [
                                          BingoActionsWidget(
                                            size: size,
                                            onPaymentPressed: () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const PaymentWidget()),
                                              );
                                            },
                                            /*onPaymentPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const PaymentWidget();
                                                },
                                              );
                                            },*/
                                            onSalesPressed: () async {
                                              Center(
                                                child: provider.isLoading
                                                    ? const CircularProgressIndicator(
                                                        color: primaryBlue)
                                                    : provider.errorMessage !=
                                                            null
                                                        ? Text(provider
                                                            .errorMessage
                                                            .toString())
                                                        : provider.listBingos
                                                                .isEmpty
                                                            ? const Text(
                                                                'No hay bingo disponibles')
                                                            : ListView.builder(
                                                                itemCount: provider
                                                                    .listBingos
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  final bingo =
                                                                      provider.listBingos[
                                                                          index];
                                                                  return ListTile(
                                                                    title: Text(
                                                                        'ID: ${bingo.bingoId}'),
                                                                    subtitle: Text(
                                                                        '${bingo.fecha}'),
                                                                  );
                                                                },
                                                              ),
                                              );

                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const SaleWidget();
                                                },
                                              );
                                            },
                                            onUvtPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const UvtWidget();
                                                },
                                              );
                                            },
                                            onCustomerPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const CustomerWidget();
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const BingoDetailPage(),
                                      const SizedBox(height: 5),
                                      Consumer<BingoProvider>(
                                        builder: (context, p, _) =>
                                            SingleChildScrollView(
                                          child: Container(
                                            height: p.qrcode != "-1"
                                                ? size.height * 0.55
                                                : size.height * 0.2,
                                            alignment:
                                                const AlignmentDirectional(
                                                    0.0, -1.0),
                                            child: p.qrcode != "-1"
                                                ? const Scaffold(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    body: BookletDetailPage(),
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                      ),
                                    ]))))),
                const BackButtonWidget(),
              ],
            )),
          )),
    );
  }
}
