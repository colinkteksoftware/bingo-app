import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bingo/core/data/models/bingo.dart';
import 'package:bingo/core/data/models/udp_data.dart';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/ui/bingo/widgets/bingo_list_view.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/colores.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:bingo/utils/defaults.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:bingo/utils/routes.dart';
import 'package:bingo/ui/user/update_person_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:udp/udp.dart';

// ignore: must_be_immutable
class BingoPage extends StatefulWidget {
  const BingoPage({super.key});

  @override
  State<BingoPage> createState() => _BingoPageState();
}

class _BingoPageState extends State<BingoPage> {
  String searchString = '';
  String searchStringproduct = '';
  String detectionInfo = '';
  Timer? timer;

  final List<String> _receivedMessages = [];
  UDP? _receiver;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BingoProvider>(context, listen: false);
      provider.fetchShowBingos(provider.status);
      _startListening();
      //registerClient();
      /*provider.addListener(() {
        if (provider.status == 1) {
          provider.fetchShowBingos(1);
        }
      });*/
      //provider.fetchShowBingos(1);
    });
    
    //_startPolling();
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  Future<void> registerClient() async {
    final sender = await UDP.bind(Endpoint.any());
    final port = int.parse(udpPort);
    final pf = Preferencias();
    String ip = pf.getIp.toString().trim().split("//")[1].split(":")[0];

    final message = jsonEncode({"type": "register", "app": "flutter_client"});

    sender.send(
      message.codeUnits,
      Endpoint.unicast(
        InternetAddress(ip),
        port: Port(port),
      ),
    );
  }

  /*void _startPolling() {
    final provider = Provider.of<BingoProvider>(context, listen: false);
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        await provider.fetchShowBingos(1);        
      } catch (e) {
        print("Error al obtener el bingo: $e");
      }
    });
  }*/

  // ======================================================== //
  //                        INICIO SOCKET
  // ======================================================== //

  Future<void> _startListening() async {
    print("INICIANDO UDP");
    try {
      final port = int.parse(udpPort);
      _receiver = await UDP.bind(Endpoint.any(port: Port(port)));
      print('Escuchando en puerto $port');
      /*if (!mounted) return;
      setState(() {
        isListening = true;
      });*/

      _receiver?.asStream().listen((datagram) {
        print('datagram => ${datagram.toString()}');
        if (datagram != null) {
          final message = String.fromCharCodes(datagram.data);
          final address = datagram.address.address;
          final port = datagram.port;
          final timestamp = DateTime.now().toString().substring(11, 19);

          setState(() {
            _receivedMessages.add('[$timestamp] De $address:$port - $message');
          });

          /*print('// ============= JSON CRUDO =============== //');
          Map<String, dynamic> jsonData = jsonDecode(message);
          print('body => ${jsonData.toString()}');
          String action = jsonData['action'];
          int bingoid = jsonData['bingoid'];
          int estado = jsonData['estado'];

          print(action);
          print(bingoid);
          print(estado);

          print('// ============= JSON MODEL =============== //');

          final dataObj = UdpData.fromJson(jsonDecode(message));
          print('udp model => ${dataObj.toString()}');
          print(dataObj.action);
          print(dataObj.bingoid);
          print(dataObj.estado);*/

          final dataObj = UdpData.fromJson(jsonDecode(message));
          print(dataObj.action);
          print(dataObj.bingoid);
          print(dataObj.estado);
          print(dataObj.bolilla);
          print(dataObj.bolillas);

          switch (dataObj.action) {
            case 'creacion':
              if (dataObj.bingoid != 0) {
                /*final bingo = Bingo()
                  ..bingoId = dataObj.bingoid
                  ..precioPorCartilla = dataObj.precio
                  //..tiempo = dataObj.inicio
                  ..estado = dataObj.estado;*/

                final provider =
                    Provider.of<BingoProvider>(context, listen: false);
                provider.fetchShowBingos(provider.status);
              }
              break;
            case 'cierre':
              /*pf.setBingoId = 0;
              context.read<ModuleBloc>().add(UpdateBingo(Bingo()));
              context.read<ModuleBloc>().add(UpdatePrecio(0));*/
              if (dataObj.bingoid != 0) {
                print('bingo ${dataObj.bingoid} finalizado');
              }
              print('Notificación de cierre via UDP');
              break;
          }

          if (_receivedMessages.isNotEmpty) {
            print(
              'mensaje recibido => ${_receivedMessages[_receivedMessages.length - 1]}',
            );
          }
        }
      });
    } catch (e) {
      print('Connection UPD failed!');
      //buscar reconectar
      _stopListening();
      //ESCUCHANDO FALSE
      //ONLINE = FALSE;
      //RECONECTAR

     /* setState(() {
        //_status = 'Error: $e';
        //ESCUCHANDO FALSE
        isListening = false;
      });*/
    }
  } 

  Future<void> _stopListening() async {
    if (_receiver != null) {
      _receiver?.close();
      _receiver = null;
      //_isListening = false;
      /*setState(() {
        _status = 'No escuchando';
      });*/
    }
  }

  // ======================================================== //
  //                        FIN SOCKET
  // ======================================================== //

  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [fondoGradientTop, fondoGradientBottom],
          stops: [0.3, 0.9]));

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BingoProvider>(context);
    DateTime maxDate = provider.currentDate.add(const Duration(days: 365));
    var size = MediaQuery.of(context).size;
    //_startListening();
    return Scaffold(
        backgroundColor: const Color(0xFFcaf0f8),
        body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Stack(children: [
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
                      constraints: const BoxConstraints(
                        maxWidth: 570,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.logout,
                                            color: primaryBlue,
                                            size: size.width * 0.07),
                                        onPressed: () => Navigator.pushNamed(
                                            context, AppRoutes.login),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            30, 10, 30, 0),
                                    child: Container(
                                      height: 100,
                                      width: 300,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/logo.png"),
                                            fit: BoxFit.fill),
                                      ),
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30, bottom: 10),
                                      child: Container(
                                        width: size.width * 0.62,
                                        padding: const EdgeInsets.only(
                                            top: 0, bottom: 0),
                                        height: size.height * 0.06,
                                        child: TextField(
                                          style: TextStyle(
                                            color: const Color(0xFF424242),
                                            fontSize: size.width * 0.04,
                                          ),
                                          onChanged: (value) async {
                                            setState(() {
                                              detectionInfo = "";
                                            });

                                            setState(() {
                                              searchString =
                                                  value.toUpperCase();
                                            });
                                          },
                                          onSubmitted: (value) async {
                                            setState(() {
                                              detectionInfo = "";
                                            });

                                            setState(() {
                                              searchString =
                                                  value.toUpperCase();
                                            });
                                          },
                                          decoration: InputDecoration(
                                            floatingLabelStyle: TextStyle(
                                              color: const Color(0xFF424242),
                                              fontSize: size.width * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: primaryBlue,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2.0,
                                              ),
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF7CBF4F),
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFF7CBF4F),
                                                width: 2.0,
                                              ),
                                            ),
                                            labelText: detectionInfo.isEmpty
                                                ? "Buscar"
                                                : detectionInfo,
                                            labelStyle: TextStyle(
                                              color: const Color(0xFF424242),
                                              fontSize: size.width * 0.04,
                                            ),
                                            isDense: true,
                                            filled: true,
                                            fillColor: const Color(0xFFcaf0f8),
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: size.height * 0.09,
                                    child: ScrollDatePicker(
                                      options: const DatePickerOptions(
                                          backgroundColor: Color(0xFFcaf0f8)),
                                      maximumDate: maxDate,
                                      selectedDate: provider.currentDate,
                                      locale: const Locale('es'),
                                      onDateTimeChanged:
                                          (DateTime value) async {
                                        provider.updateCurrentDate(value);
                                        await provider
                                            .fetchShowBingos(provider.status);
                                      },
                                    ),
                                  ),
                                  Consumer<BingoProvider>(
                                    builder: (context, provider, child) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, top: 5, right: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child:
                                                    CupertinoSegmentedControl<
                                                        int>(
                                                  children: segments
                                                      .map((key, value) {
                                                    return MapEntry(
                                                      key,
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16,
                                                                vertical: 10),
                                                        child: value,
                                                      ),
                                                    );
                                                  }),
                                                  onValueChanged:
                                                      (int newValue) async {
                                                    provider
                                                        .updatestatus(newValue);
                                                    await provider
                                                        .fetchShowBingos(
                                                            newValue);
                                                  },
                                                  groupValue: provider.status,
                                                  selectedColor: primaryBlue,
                                                  unselectedColor:
                                                      const Color(0xFFcaf0f8),
                                                  borderColor: primaryBlue,
                                                  pressedColor: primaryBlue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  const BingosListView()
                                ],
                              ))))),
            ])),
        floatingActionButton: GestureDetector(
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UpdatePersonPage(),
                  ));
            },
            child: Container(
              width: size.width * 0.4,
              color: primaryBlue,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Modificar Usuario",
                          style: TextStyle(
                            color: const Color(0xFFcaf0f8),
                            fontSize: size.width * 0.042,
                            fontFamily: 'gotic',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.supervised_user_circle,
                          size: size.width * 0.059,
                          color: const Color(0xFFcaf0f8),
                        ),
                      ],
                    )
                  ]),
            )));
  }
}
