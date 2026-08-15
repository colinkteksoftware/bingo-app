import 'dart:ui';

import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/colores.dart';
import 'package:bingo/utils/custom_back_button.dart';
import 'package:bingo/utils/routes.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:bingo/utils/preferencias.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

final pf = Preferencias();

class _SettingPageState extends State<SettingPage> {
  final ipController = TextEditingController(text: pf.getIp ?? '');
  final _formKey = GlobalKey<FormState>();

  var maskFormatter = MaskedTextController(mask: '#.#.#.#', translator: {
    '#': RegExp(r'^([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$')
  });

  @override
  void dispose() {
    ipController.dispose();
    super.dispose();
  }

  final boxDecoration = const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [fondoGradientTop, fondoGradientBottom],
      stops: [0.2, 1.0],
    ),
  );

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: boxDecoration,
                          height: size.height,
                          width: size.width,
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
                            constraints: const BoxConstraints(maxWidth: 570),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Form(
                                  key: _formKey, // ✅ Se usa correctamente
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
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
                                              const AlignmentDirectional(0, 0),
                                        ),
                                      ),
                                      Text(
                                        'Bienvenido',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: size.width * 0.08,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF03045e),
                                          fontFamily: 'Poppins',
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 12, 0, 24),
                                        child: Text(
                                          'Registra los datos de la ip y el puerto ejemplo https://192.168.0.0:1234',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: size.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF03045e),
                                            fontFamily: 'Poppins',
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: ipController,
                                        style: TextStyle(
                                          color: const Color(0xFF03045e),
                                          fontSize: size.width * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color: const Color(0xFF03045e),
                                            fontSize: size.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          labelText: "Ip Servidor y puerto",
                                          hintText:
                                              'http://000.000.000.000:0000',
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Por favor ingresa una IP válida';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 30),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.fromSwatch()
                                              .copyWith(
                                                  secondary: Colors.white),
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor:
                                                const Color(0xFFcaf0f8),
                                            backgroundColor:
                                                const Color(0xFF03045e),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            elevation: 15.0,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text(
                                              'Grabar cambios',
                                              style: TextStyle(
                                                color: const Color(0xFFcaf0f8),
                                                fontSize: size.width * 0.032,
                                                fontFamily: 'gotic',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                pf.setIP = ipController.text;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                    'Configuración ip registrada',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                Navigator.pushReplacementNamed(
                                                    context, AppRoutes.login);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
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
            const Positioned(
              top: 25.0,
              left: 10.0,
              child: BackButtonWidget(),
            ),
            /*const Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: BackButtonWidget(),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

/*class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

final pf = Preferencias();

class _SettingPageState extends State<SettingPage> {  
  final ipController = TextEditingController(text: pf.getIp ?? '');
  final _formKey = GlobalKey<FormState>();

  var maskFormatter = MaskedTextController(mask: '#.#.#.#', translator: {
    '#': RegExp(r'^([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$')
  });

  @override
  void dispose() {
    ipController.dispose();
    super.dispose();
  }

  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [fondoGradientTop, fondoGradientBottom],
          stops: [0.2, 1.0]));
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            key: scaffoldKey,
            body: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: boxDecoration,
                              height: size.height,
                              width: size.width,
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
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 20, 0, 0),
                                          child: Container(
                                            height: 100,
                                            width: 250,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "assets/images/logo.png"),
                                                  fit: BoxFit.fill),
                                            ),
                                            alignment:
                                                const AlignmentDirectional(
                                                    0, 0),
                                          ),
                                        ),
                                        Text('Bienvenido',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: size.width * 0.08,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF03045e),
                                              fontFamily: 'Poppins',
                                              letterSpacing: 0.0,
                                            )),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 12, 0, 24),
                                          child: Text(
                                            'Registra los datos de la ip y el puerto ejemplo https://192.168.0.0:1234',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: size.width * 0.04,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF03045e),
                                              fontFamily: 'Poppins',
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: ipController,
                                          style: TextStyle(
                                            color: const Color(0xFF03045e),
                                            fontSize: size.width * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                              color: const Color(0xFF03045e),
                                              fontSize: size.width * 0.04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            labelText: "Ip Servidor y puerto",
                                            hintText:
                                                'http://000.000.000.000:0000',
                                          ),
                                          onSaved: (value) {
                                            ipController.text = value!;
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'ip';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 30),
                                        Theme(
                                          data: Theme.of(context).copyWith(
                                              colorScheme:
                                                  ColorScheme.fromSwatch()
                                                      .copyWith(
                                                          secondary:
                                                              Colors.white)),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor:
                                                  const Color(0xFFcaf0f8),
                                              backgroundColor:
                                                  const Color(0xFF03045e),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              elevation: 15.0,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Text(
                                                'Grabar cambios',
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xFFcaf0f8),
                                                  fontSize: size.width * 0.032,
                                                  fontFamily: 'gotic',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                pf.setIP = ipController.text;
                                              });
                                              Navigator.pushNamed(
                                                  context, AppRoutes.login);
                                            },
                                          ),
                                        ),
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
                const Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: BackButtonWidget(),
                  ),
                ),
              ],
            )));
  }
}*/
