import 'dart:io';
import 'package:bingo/providers/auth_provider.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/colores.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:bingo/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:bingo/core/data/models/salasconvert.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  List<Sala>? sala;
  var txtControlerUsuario = TextEditingController();
  var txtControlerClave = TextEditingController();

  final pf = Preferencias();
  bool _isChecked = false;
  bool ocultaClave = true;

  @override
  void initState() {
    iniciarPreferencias();
    super.initState();
  }

  final ipController = TextEditingController(text: "0.0.0.0");

  void iniciarPreferencias() async {
    ipController.text = pf.getIp;
    pf.setCodigoSala = 0;
    _isChecked = pf.getRecuerda;

    if (_isChecked) {
      txtControlerUsuario.text = pf.getUsuario;
      txtControlerClave.text = pf.getpassword;
    } else {
      txtControlerUsuario.text = '';
      txtControlerClave.text = '';
    }
    setState(() {});
  }

  @override
  void dispose() {
    txtControlerUsuario.dispose();
    txtControlerClave.dispose();
    super.dispose();
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Widget bottonSheet(BuildContext context, int opcion) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: const Column(
        children: [
          Text(
            'Seleccionar Fotografia',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [fondoGradientTop, fondoGradientBottom],
          stops: [0.3, 0.9]));

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _isChecked = pf.getRecuerda;
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    width: 100,
                    decoration: const BoxDecoration(),
                    alignment: const AlignmentDirectional(0, -1),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
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
                                alignment: const AlignmentDirectional(0, 0),
                                child: Container(
                                  height: size.height,
                                  width: double.infinity,
                                  constraints:
                                      const BoxConstraints(maxWidth: 570),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onDoubleTap: () async {
                                              try {
                                                await Navigator.pushNamed(
                                                    context, AppRoutes.setting);
                                                iniciarPreferencias();
                                              } catch (e, s) {
                                                const snackBar = SnackBar(
                                                  content: Center(
                                                      child: Text(
                                                          'Falla de enrutamiento')),
                                                  backgroundColor: Colors.red,
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                print(
                                                    'Error al navegar a settings: $e');
                                                print(s);
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 20, 0, 0),
                                              child: Container(
                                                height: 100,
                                                width: 250,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/logo.png"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                alignment:
                                                    const AlignmentDirectional(
                                                        0, 0),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Bienvenido',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: size.width * 0.08,
                                              fontWeight: FontWeight.bold,
                                              color: primaryBlue,
                                              fontFamily: 'Poppins',
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 12, 0, 24),
                                            child: Text(
                                              'Ingresa los datos de tu cuenta para continuar',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: size.width * 0.04,
                                                fontWeight: FontWeight.bold,
                                                color: primaryBlue,
                                                fontFamily: 'Poppins',
                                                letterSpacing: 0.0,
                                              ),
                                            ),
                                          ),
                                          Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: const EdgeInsets.all(2),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    style: TextStyle(
                                                      color: primaryBlue,
                                                      fontSize:
                                                          size.width * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    controller:
                                                        txtControlerUsuario,
                                                    decoration: InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: primaryBlue,
                                                        fontSize:
                                                            size.width * 0.04,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      hintText:
                                                          'Ingrese el Usuario',
                                                      prefixIcon: const Icon(
                                                        Icons.person,
                                                        color: primaryBlue,
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        vertical: 16.0,
                                                        horizontal: 12.0,
                                                      ),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.text,
                                                    onSaved: (value) {
                                                      txtControlerUsuario.text =
                                                          value!;
                                                    },
                                                  ),
                                                  const SizedBox(height: 10),
                                                  TextFormField(
                                                    controller:
                                                        txtControlerClave,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    style: TextStyle(
                                                      color: primaryBlue,
                                                      fontSize:
                                                          size.width * 0.04,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelStyle: TextStyle(
                                                        color: primaryBlue,
                                                        fontSize:
                                                            size.width * 0.04,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      hintText:
                                                          'Ingrese Contraseña',
                                                      prefixIcon: const Icon(
                                                        Icons.lock,
                                                        color: primaryBlue,
                                                      ),
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .never,
                                                      isDense: true,
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        vertical: 16.0,
                                                        horizontal: 12.0,
                                                      ),
                                                      suffixIcon: IconButton(
                                                        icon: Icon(
                                                          color: const Color(
                                                              0xFF03045e),
                                                          ocultaClave
                                                              ? Icons
                                                                  .visibility_off
                                                              : Icons
                                                                  .visibility,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            ocultaClave =
                                                                !ocultaClave;
                                                          });
                                                        },
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary
                                                            .withOpacity(0.4),
                                                      ),
                                                    ),
                                                    obscureText: ocultaClave,
                                                    onSaved: (value) {
                                                      txtControlerClave.text =
                                                          value!;
                                                    },
                                                  ),
                                                  const SizedBox(height: 15),
                                                  _checkboxRecuerda(),
                                                  Consumer<AuthProvider>(
                                                    builder: (context, provider,
                                                        child) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                0, 0, 0, 16),
                                                        child: GestureDetector(
                                                          onTap:
                                                              provider.isLoading
                                                                  ? null
                                                                  : () async {
                                                                      if (txtControlerUsuario
                                                                              .text
                                                                              .toString()
                                                                              .trim()
                                                                              .isNotEmpty &&
                                                                          txtControlerClave
                                                                              .text
                                                                              .toString()
                                                                              .trim()
                                                                              .isNotEmpty) {
                                                                        final success =
                                                                            await provider.login(
                                                                          context,
                                                                          txtControlerUsuario
                                                                              .text,
                                                                          txtControlerClave
                                                                              .text,
                                                                          _isChecked,
                                                                        );

                                                                        if (success) {
                                                                          Navigator.pushReplacementNamed(
                                                                              context,
                                                                              AppRoutes.bingo); //AppRoutes.started);
                                                                        }
                                                                      } else {
                                                                        showAlerta(
                                                                            context,
                                                                            'Mensaje Informativo',
                                                                            '¡Credenciales Incorrecta. Ingrese un usuario válido, por favor!');
                                                                      }
                                                                    },
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient: provider
                                                                      .isLoading
                                                                  ? null
                                                                  : const LinearGradient(
                                                                      colors: [
                                                                        primaryBlue,
                                                                        Color(
                                                                            0xFF0077b6),
                                                                      ],
                                                                      stops: [
                                                                        0,
                                                                        1
                                                                      ],
                                                                      begin:
                                                                          AlignmentDirectional(
                                                                              -1,
                                                                              0),
                                                                      end: AlignmentDirectional(
                                                                          1, 0),
                                                                    ),
                                                              color: provider
                                                                      .isLoading
                                                                  ? Colors
                                                                      .grey[300]
                                                                  : null,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                            ),
                                                            child: Center(
                                                              child: provider
                                                                      .isLoading
                                                                  ? const SizedBox(
                                                                      width: 24,
                                                                      height:
                                                                          24,
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation<Color>(Color(0xFF03045e)),
                                                                        strokeWidth:
                                                                            3,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      'Inicio de sesión',
                                                                      style:
                                                                          TextStyle(
                                                                        color: const Color(
                                                                            0xFFcaf0f8),
                                                                        fontSize:
                                                                            size.width *
                                                                                0.04,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Center(
                                            child: GestureDetector(
                                              onTap: () async {
                                                await Navigator.pushNamed(
                                                    context, AppRoutes.person);
                                              },
                                              child: const Text(
                                                'Registrar Promotor',
                                                style: TextStyle(
                                                  color: primaryBlue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 18,
                                                  fontFamily: 'gotic',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                          /*Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AnimatedButton(
                                                  color: primaryBlue,
                                                  height: size.height * 0.03,
                                                  width: size.width * 0.3,
                                                  duration: 2,
                                                  onPressed: () async {
                                                    await Navigator.pushNamed(
                                                        context,
                                                        AppRoutes.person);
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0,
                                                              left: 0,
                                                              right: 0,
                                                              bottom: 0),
                                                      child: Center(
                                                          child: Text(
                                                        "Registrar Promotor",
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xFFcaf0f8),
                                                          fontSize: size.width *
                                                              0.032,
                                                          fontFamily: 'gotic',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )))),
                                              AnimatedButton(
                                                  color: primaryBlue,
                                                  height: size.height * 0.03,
                                                  width: size.width * 0.3,
                                                  duration: 2,
                                                  onPressed: () async {
                                                    await Navigator.pushNamed(
                                                        context,
                                                        AppRoutes.setting);
                                                    iniciarPreferencias();
                                                  },
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0,
                                                              left: 0,
                                                              right: 0,
                                                              bottom: 0),
                                                      child: Center(
                                                          child: Text(
                                                        "Configurar ip",
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xFFcaf0f8),
                                                          fontSize: size.width *
                                                              0.032,
                                                          fontFamily: 'gotic',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ))))
                                            ],
                                          ),*/
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FutureBuilder<String>(
                future: getAppVersion(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Error al cargar versión");
                  } else {
                    return Text(
                      "Versión: ${snapshot.data}",
                      style: const TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _checkboxRecuerda() {
    var size = MediaQuery.of(context).size;
    _isChecked = pf.getRecuerda;
    return Row(
      children: [
        Checkbox(
          activeColor: primaryBlue,
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = !_isChecked;
              pf.setRecuerda = _isChecked;
            });
          },
        ),
        Text(
          style: TextStyle(
            color: primaryBlue,
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
          'Recordar Clave',
        ),
      ],
    );
  }

  ImageProvider foto() {
    final pf = Preferencias();
    try {
      if (pf.getfoto.toString().trim().isNotEmpty) {
        if (pf.getfoto.contains('assets')) {
          return AssetImage(pf.getfoto);
        } else {
          return FileImage(File(pf.getfoto));
        }
      } else {
        return const AssetImage('assets/F1.png');
      }
    } catch (e) {
      return const AssetImage('assets/F1.png');
    }
  }
}
