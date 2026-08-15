import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:animated_button/animated_button.dart';
import 'package:bingo/core/data/models/personaconvert.dart';
import 'package:bingo/ui/login_page.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

//import 'package:bingo/mainjuegos';
import 'package:bingo/core/data/models/chatconvert.dart';
import 'package:bingo/core/data/models/clasesmovil.dart';
import 'package:bingo/core/data/models/modelPromotor.dart';

//import 'package:bingo/ui/tablaHorizontalMenu.dart';

import 'package:bingo/utils/preferencias.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

Future<List<Persona>?>? chats;
Persona? listchat;

class UpdatePersonPage extends StatefulWidget {
  //ModelPromotor? datosuser;
  const UpdatePersonPage({super.key, /*required this.datosuser*/});
  @override
  State<UpdatePersonPage> createState() => _UpdatePersonPageState();
}

class _UpdatePersonPageState extends State<UpdatePersonPage> {  

  @override
  void initState() {

    //se necesita cargar la info de sharedferences para los datos del vendedor o promotor

    /*nomClieController.text = widget.datosuser!.nombres!;
    apeclieController.text = widget.datosuser!.apellidos!;

    dniController.text = widget.datosuser!.doi!;
    telefonoController.text = widget.datosuser!.telefono!;
    correoController.text = widget.datosuser!.usuario!;
    claveController.text;
    estatus = widget.datosuser!.estado!;*/
    iniciarPreferencias();
    super.initState();
  }

  void iniciarPreferencias() async {
    ipController.text = pf.getIp;
    setState(() {});
  }

  final ipController = TextEditingController(text: "0.0.0.0");
  bool estatus = true;
  final idClienteController = TextEditingController();
  final nomClieController = TextEditingController();
  final apeclieController = TextEditingController();
  final fechaNacimientoController = TextEditingController();
  final sexoController = TextEditingController();
  final correoController = TextEditingController();
  final claveController = TextEditingController();
  final telefonoController = TextEditingController();
  final dniController = TextEditingController();
  final nacionalidadController = TextEditingController();
  final puntosRedimiblesController = TextEditingController(text: "0");
  final puntosCuponesController = TextEditingController(text: "0");
  final puntosJugablesController = TextEditingController(text: "0");
  final fechaRegistroController = TextEditingController();
  final fecha_UltimaVisitaController = TextEditingController();
  final estadoController = TextEditingController();

  Future<Persona> fetchPost(int status, String dni) async {
    final pf = Preferencias();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    final url = Uri.parse("${ipController.text}/Apicentral/api/Clientes/ConsultaCliente/${pf.getCodigoSala}/$dni");

    var respuesta = await http.get(url);
    try {
      //print(url);
      if (respuesta.statusCode == 200) {
        setState(() {
          Map<String, dynamic> map =
              jsonDecode(utf8.decode(respuesta.bodyBytes));
          listchat = Persona.fromJson(map);

          idClienteController.text = listchat!.idCliente!.toString();
          nomClieController.text = listchat!.nomClie!.toString();
          apeclieController.text = listchat!.apeclie!.toString();
          fechaNacimientoController.text = DateFormat('yyyy-MM-dd')
              .format(listchat!.fechaNacimiento!)
              .toString();
          sexoController.text = listchat!.sexo!.toString();
          correoController.text = listchat!.correo!.toString();
          claveController.text = listchat!.clave!.toString();
          telefonoController.text = listchat!.telefono!.toString();
          dniController.text = listchat!.dni!.toString();
          nacionalidadController.text = listchat!.nacionalidad!.toString();
          puntosRedimiblesController.text =
              listchat!.puntosRedimibles!.toString();
          puntosCuponesController.text = listchat!.puntosCupones!.toString();
          puntosJugablesController.text = listchat!.puntosJugables!.toString();
          fechaRegistroController.text = listchat!.fechaRegistro!.toString();
          fecha_UltimaVisitaController.text =
              listchat!.fechaUltimaVisita!.toString();
          estadoController.text = listchat!.estado!.toString();
        });
        setState(() {});

        return listchat!;
      } else {
        const snackBar = SnackBar(
            content: Center(
              child: Text(
                  "Error al Conectarse con la Api\n posiblemente Servidor Principal esta fuera de Linea!!"),
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        throw new Exception("Error al Conectarse con la Api");
      }
    } catch (e) {
      const snackBar = SnackBar(
          content: Center(
            child: Text(
                "Error al Conectarse con la Api\n posiblemente Servidor Principal esta fuera de Linea!!"),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw new Exception("Error al Conectarse con la Api");
    }
  }

  Widget _buildImageFromBase64(String base64Image) {
    try {
      final Uint8List imageData = base64Decode(base64Image);
      return Image.memory(
        imageData,
        fit: BoxFit.fill,
        height: 80.0,
      );
    } catch (e) {
      // En caso de error en la decodificación, muestra una imagen de respaldo
      //print('Error decoding base64 image: $e');
      return Image.network(
        'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
        fit: BoxFit.cover,
        height: 80.0,
      );
    }
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? foldernameController = TextEditingController(text: "");
  final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [fondoGradientTop, fondoGradientBottom],
          stops: [0.3, 0.9]));
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            key: scaffoldKey,
            body: Stack(children: [
              Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(
                    flex: 6,
                    child: Container(
                        width: 100,
                        height: double.infinity,
                        decoration: BoxDecoration(),
                        alignment: AlignmentDirectional(0, -1),
                        child: SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Stack(children: [
                                Container(
                                  decoration: boxDecoration,
                                ),
                                const Positioned(
                                  top: -130,
                                  left: -15,
                                  child: Column(
                                    children: [
                                      CustomBox3(),
                                    ],
                                  ),
                                ),
                                const Positioned(
                                  top: 340,
                                  left: 105,
                                  child: Column(
                                    children: [
                                      CustomBox4(),
                                    ],
                                  ),
                                ),
                                Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Container(
                                        height: size.height,
                                        width: double.infinity,
                                        constraints: BoxConstraints(
                                          maxWidth: 570,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Align(
                                            alignment:
                                                AlignmentDirectional(0, 0),
                                            child: Padding(
                                                padding: EdgeInsets.all(32),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                                Icons
                                                                    .arrow_back,
                                                                color: Color(
                                                                    0xFF03045e),
                                                                size:
                                                                    size.width *
                                                                        0.08),
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 20,
                                                                    0, 0),
                                                        child: Container(
                                                          height:
                                                              size.height * 0.2,
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/images/logo.png"),
                                                                fit: BoxFit
                                                                    .fill),
                                                          ),
                                                          alignment:
                                                              AlignmentDirectional(
                                                                  0, 0),
                                                        ),
                                                      ),
                                                      Text('Bienvenido',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.08,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xFF03045e),
                                                            fontFamily:
                                                                'Poppins',
                                                            letterSpacing: 0.0,
                                                          )),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(0, 12,
                                                                    0, 24),
                                                        child: Text(
                                                            'Actualiza los datos para modificar tu cuenta.',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.width *
                                                                      0.044,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  0xFF03045e),
                                                              fontFamily:
                                                                  'Poppins',
                                                              letterSpacing:
                                                                  0.0,
                                                            )),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        style: TextStyle(
                                                          color:
                                                              primaryBlue,
                                                          fontSize:
                                                              size.width * 0.04,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        controller:
                                                            nomClieController,
                                                        enabled: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Nombre',
                                                          hintText: 'Nombre',
                                                          labelStyle: TextStyle(
                                                            color: Color(
                                                                0xFF03045e),
                                                            fontSize:
                                                                size.width *
                                                                    0.04,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        style: TextStyle(
                                                          color:
                                                              primaryBlue,
                                                          fontSize:
                                                              size.width * 0.04,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        controller:
                                                            apeclieController,
                                                        enabled: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: 'Apellidos',
                                                          labelText:
                                                              'Apellidos',
                                                          labelStyle: TextStyle(
                                                            color: Color(
                                                                0xFF03045e),
                                                            fontSize:
                                                                size.width *
                                                                    0.04,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextFormField(
                                                        style: TextStyle(
                                                          color:
                                                              primaryBlue,
                                                          fontSize:
                                                              size.width * 0.04,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        controller:
                                                            claveController,
                                                        enabled: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Clave',
                                                          hintText: 'Clave',
                                                          labelStyle: TextStyle(
                                                            color: Color(
                                                                0xFF03045e),
                                                            fontSize:
                                                                size.width *
                                                                    0.04,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xff525f7f),
                                                              width: 0.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Theme(
                                                          data: Theme.of(
                                                                  context)
                                                              .copyWith(
                                                                  colorScheme:
                                                                      ColorScheme
                                                                              .fromSwatch()
                                                                          .copyWith(
                                                            secondary: Color(
                                                                0xFF03045e),
                                                          )),
                                                          child: AnimatedButton(
                                                            color: Color(
                                                                0xFF03045e),
                                                            height:
                                                                size.height *
                                                                    0.05,
                                                            width: size.width *
                                                                0.6,
                                                            duration: 2,
                                                            onPressed:
                                                                () async {
                                                              if (claveController
                                                                          .text ==
                                                                      "" ||
                                                                  claveController
                                                                      .text
                                                                      .isEmpty) {
                                                                var size =
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size;

                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      backgroundColor: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              1),
                                                                      title:
                                                                          Text(
                                                                        'Por favor ingrese su clave o cambiela',
                                                                        style: TextStyle(
                                                                            color:
                                                                                primaryBlue),
                                                                      ),
                                                                      content: Text(
                                                                          'Ingresa clave'),
                                                                      actions: <Widget>[
                                                                        Column(
                                                                          children: [
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: [
                                                                                TextButton(
                                                                                  style: TextButton.styleFrom(
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(0.0),
                                                                                      side: const BorderSide(color: Colors.grey),
                                                                                    ),
                                                                                    backgroundColor: primaryBlue,
                                                                                  ),
                                                                                  child: Text(
                                                                                    'Confirmar',
                                                                                    style: TextStyle(fontSize: size.width * 0.03, color: Colors.white),
                                                                                  ),
                                                                                  onPressed: () async {
                                                                                    //   await fetchShowsdelete(order.ventaId.toString());
                                                                                    //   listaset = fetchShows();
                                                                                    Navigator.of(context).pop();
                                                                                    setState(() {});
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              } else {
                                                                _login(context);
                                                              }
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Actualizar Promotor',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFFcaf0f8),
                                                                    fontSize:
                                                                        size.width *
                                                                            0.032,
                                                                    fontFamily:
                                                                        'gotic',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                      SwitchListTile(
                                                        subtitle: Text(
                                                          estatus
                                                              ? " Oprime para Desactivar Usuario:"
                                                              : "Oprime para Activar Usuario",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFcaf0f8),
                                                            fontSize:
                                                                size.width *
                                                                    0.032,
                                                            fontFamily: 'gotic',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        controlAffinity:
                                                            ListTileControlAffinity
                                                                .leading,
                                                        activeColor:
                                                            primaryBlue,
                                                        title: Text(
                                                          estatus
                                                              ? "Activado:"
                                                              : "Cartilla: ",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFcaf0f8),
                                                            fontSize:
                                                                size.width *
                                                                    0.032,
                                                            fontFamily: 'gotic',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        value: estatus,
                                                        onChanged:
                                                            (value) async {
                                                          if (value == false) {
                                                            var size =
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size;

                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              1),
                                                                  title: Text(
                                                                    'Seguro que deseas eliminar la cuenta?',
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF03045e)),
                                                                  ),
                                                                  content: Text(
                                                                      'Eliminar Cuenta'),
                                                                  actions: <Widget>[
                                                                    Column(
                                                                      children: [
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            TextButton(
                                                                              style: TextButton.styleFrom(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(0.0),
                                                                                  side: const BorderSide(color: Colors.grey),
                                                                                ),
                                                                                backgroundColor: Colors.red[900],
                                                                              ),
                                                                              child: Text(
                                                                                'Cancelar',
                                                                                style: TextStyle(fontSize: size.width * 0.03, color: Colors.white),
                                                                              ),
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                            ),
                                                                            TextButton(
                                                                              style: TextButton.styleFrom(
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(0.0),
                                                                                  side: const BorderSide(color: Colors.grey),
                                                                                ),
                                                                                backgroundColor: primaryBlue,
                                                                              ),
                                                                              child: Text(
                                                                                'Confirmar',
                                                                                style: TextStyle(fontSize: size.width * 0.03, color: Colors.white),
                                                                              ),
                                                                              onPressed: () async {
                                                                                //   await fetchShowsdelete(order.ventaId.toString());
                                                                                //   listaset = fetchShows();
                                                                                setState(() {
                                                                                  estatus = value;
                                                                                });

                                                                                desactivar(context);

                                                                                setState(() {});
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }

                                                          // _modeld.status.text = value == true ? "1" : "0";
                                                        },
                                                      )
                                                    ])))))
                              ])
                            ]))))
              ])
            ])));
  }

  final pf = new Preferencias();
  void _login(BuildContext context) async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    try {
      String ruta;

      ruta = ipController.text + "/api/PromotorInterno";

      final uri = Uri.parse(ruta);
      final headers = {'Content-Type': 'application/json'};

      final encoding = Encoding.getByName('utf-8');

      Response response = await http.put(uri,
          headers: headers,
          encoding: encoding,
          body: jsonEncode({
            //"promotorId": widget.datosuser!.promotorId,
            "nombres": nomClieController.text,
            "apellidos": apeclieController.text,
            "tipoDocumento": 11,
            "doi": dniController.text,
            "telefono": telefonoController.text,
            "usuario": correoController.text,
            "password": claveController.text,
            "estado": true,
            "tipousuario": 2,
            "comision": 0
          }));

      if (response.statusCode == 200) {
        pf.setUsuario = correoController.text;
        pf.setpassword = claveController.text;
        const snackBar =
            SnackBar(content: Center(child: Text("Se ha actualizado el promotor..")), backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        await Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) =>
                false, // Elimina todas las rutas anteriores
          );
        });
      } else {
        const snackBar =
            SnackBar(content: Center(child: Text("Error registro con problemas..")));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      const snackBar =
          SnackBar(content: Center(child: Text("Error registro con problemas..")));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception("Error al Conectarse con la Api");
    }
  }

  final ioc = HttpClient();
  void desactivar(BuildContext context) async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    try {
      String ruta;

      ruta = ipController.text + "/api/PromotorInterno";

      final uri = Uri.parse(ruta);
      final headers = {'Content-Type': 'application/json'};

      final encoding = Encoding.getByName('utf-8');

      Response response = await put(uri,
          headers: headers,
          encoding: encoding,
          body: jsonEncode({
            //"promotorId": widget.datosuser!.promotorId,
            "nombres": nomClieController.text,
            "apellidos": apeclieController.text,
            "tipoDocumento": 11,
            "doi": dniController.text,
            "telefono": telefonoController.text,
            "usuario": correoController.text,
            "password": correoController.text,
            "estado": false,
            "tipousuario": 2,
            "comision": 0
          }));

      if (response.statusCode == 200) {
        const snackBar = SnackBar(content: Center(child: Text("Se actualizo el promotor..")), backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        await Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) =>
                false, // Elimina todas las rutas anteriores
          );
        });
      } else {
        const snackBar =
            SnackBar(content: Center(child: Text("Error registro con problemas..")));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      const snackBar =
          SnackBar(content: Center(child: Text("Error registro con problemas..")));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception("Error al Conectarse con la Api");
    }
  }
}
