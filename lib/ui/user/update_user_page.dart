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

class UpdateUserPage extends StatefulWidget {
  String doi;
  UpdateUserPage({super.key, required this.doi});
  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  //ModelCliente _modelGanadoresDisplay = new ModelCliente(
  //idCliente:0,
//contrato:"",
//id_sala_nube:0,
//NomClie:"",
//Apeclie:"",
//FechaNacimiento:null,
//Sexo:1,
//Correo:"",
//clave:"",
//Telefono:"",
//Dni:"",
//Nacionalidad:"",
//PuntosRedimibles:0,
//PuntosCupones:0,
//PuntosJugables:0,
//FechaRegistro:null,
//Fecha_UltimaVisita:null,
//Estado:1
  //);

  @override
  void initState() {
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
  final nomClieController = TextEditingController(text: "");
  final apeclieController = TextEditingController(text: "");
  final direccionController = TextEditingController(text: "");
  final departamentoController = TextEditingController(text: "");
  final fechaNacimientoController = TextEditingController();
  final sexoController = TextEditingController();
  final correoController = TextEditingController(text: "");
  final claveController = TextEditingController();
  final telefonoController = TextEditingController(text: "");
  final dniController = TextEditingController();
  final nacionalidadController = TextEditingController();
  final puntosRedimiblesController = TextEditingController(text: "0");
  final puntosCuponesController = TextEditingController(text: "0");
  final puntosJugablesController = TextEditingController(text: "0");
  final fechaRegistroController = TextEditingController();
  final fecha_UltimaVisitaController = TextEditingController();
  final estadoController = TextEditingController();

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
      print('Error decoding base64 image: $e');
      return Image.network(
        'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
        fit: BoxFit.cover,
        height: 80.0,
      );
    }
  }

  final Map<int, String> documentTypes = {
    11: "Registro Civil",
    12: "Tarjeta Identidad",
    13: "Cédula Ciudadanía",
    22: "Cédula Extranjería",
    31: "NIT",
    41: "Pasaporte",
    42: "Documento Identificación Extranjero",
    43: "Sin Identificación Exterior",
    44: "Identificación Extranjero Persona Jurídica",
    46: "Carné Diplomático",
    14: "Certificado Registraduría",
    15: "Documento Sucesión Ilíquida",
    33: "ID Extranjeros No NIT",
    21: "Tarjeta Extranjería",
    47: "Sociedad Extranjera"
  };

  int? _selectedStd;

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
                                                            'Diligencia los datos para crear la cuenta cliente.',
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
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                        ),
                                                        width: size.width * 0.8,
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: ButtonTheme(
                                                            alignedDropdown:
                                                                true,
                                                            child:
                                                                DropdownButton<
                                                                    int>(
                                                              dropdownColor:
                                                                  Color(
                                                                      0xFF424242),
                                                              isExpanded: true,
                                                              value:
                                                                  _selectedStd, // Aquí almacenamos el int
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF424242),
                                                                fontSize:
                                                                    size.width *
                                                                        0.04,
                                                              ),
                                                              hint: Text(
                                                                "Seleccione tipo Documento",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      size.width *
                                                                          0.04,
                                                                ),
                                                              ),
                                                              onChanged: (int?
                                                                  newValue) {
                                                                setState(() {
                                                                  _selectedStd =
                                                                      newValue; // Guarda el valor entero
                                                                });
                                                              },
                                                              itemHeight:
                                                                  size.height *
                                                                      0.08,
                                                              items: documentTypes
                                                                  .entries
                                                                  .map<DropdownMenuItem<int>>(
                                                                      (entry) {
                                                                return DropdownMenuItem<
                                                                    int>(
                                                                  value:
                                                                      entry.key,
                                                                  child: Text(
                                                                    entry
                                                                        .value, // Muestra la descripción en la lista
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          size.width *
                                                                              0.04,
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
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
                                                            correoController,
                                                        enabled: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Email',
                                                          hintText: 'Email',
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
                                                            telefonoController,
                                                        enabled: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: 'Telefono',
                                                          hintText: 'Telefono',
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
                                                            departamentoController,
                                                        enabled: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Departamento',
                                                          hintText:
                                                              'Departamento',
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
                                                            direccionController,
                                                        enabled: true,
                                                        obscureText: false,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Direccion',
                                                          hintText: 'Direccion',
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
                                                      const SizedBox(
                                                        height: 15
                                                      ),
                                                      Theme(
                                                          data: Theme.of(
                                                                  context)
                                                              .copyWith(
                                                                  colorScheme:
                                                                      ColorScheme
                                                                              .fromSwatch()
                                                                          .copyWith(
                                                            secondary: const Color(
                                                                0xFF03045e),
                                                          )),
                                                          child: AnimatedButton(
                                                            color: const Color(
                                                                0xFF03045e),
                                                            height:
                                                                size.height *
                                                                    0.05,
                                                            width: size.width *
                                                                0.6,
                                                            duration: 2,
                                                            onPressed:
                                                                () async {
                                                              if (_selectedStd ==
                                                                  null) {
                                                                const snackBar =
                                                                    SnackBar(
                                                                        content:
                                                                            Center(child: Text("¡Error!, seleccione un tipo de documento..")), backgroundColor: Colors.red,);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        snackBar);
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
                                                                  'Crear Cliente',
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
                                                    ])))))
                              ])
                            ]))))
              ])
            ])));
  }

  final pf = Preferencias();
  void _login(BuildContext context) async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);

    try {
      String ruta;

      ruta = "${ipController.text}/api/ClienteInterno/PostCliente";

      final uri = Uri.parse(ruta);
      final headers = {'Content-Type': 'application/json'};

      final encoding = Encoding.getByName('utf-8');

      Response response = await http.post(uri,
          headers: headers,
          encoding: encoding,
          body: jsonEncode({
            "clienteid": 0,
            "nombres": nomClieController.text,
            "apellidos": apeclieController.text,
            "tipoDocumento": _selectedStd,
            "doi": widget.doi,
            "direccion": direccionController.text,
            "departamento": departamentoController.text,
            "telefono": telefonoController.text,
            "email": correoController.text,
            "fechaRegistro": "2025-01-23T18:23:01.761Z",
            "extranetid": 0,
            "synchronizer": 0
          }));

      if (response.statusCode == 200) {
        const snackBar = SnackBar(content: Center(child: Text("Se creo el cliente..")), backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        await Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
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

      ruta = "${ipController.text}/api/PromotorInterno";

      final uri = Uri.parse(ruta);
      final headers = {'Content-Type': 'application/json'};

      final encoding = Encoding.getByName('utf-8');

      Response response = await put(uri,
          headers: headers,
          encoding: encoding,
          body: jsonEncode({
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
        const snackBar = SnackBar(content: Center(child: Text("Se creo el cliente..")), backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        await Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
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
      throw new Exception("Error al Conectarse con la Api");
    }
  }
}
