import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:miincode/src/models/usuario_registrar_model.dart';
import 'package:miincode/src/models/usuario_search_model.dart';
import 'package:miincode/src/models/usuarios.dart';
import 'package:miincode/src/providers/ws.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encr;

/* ----- LOGGER ---------------- */
var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));
/* ----- LOGGER ---------------- */

// Datos de la cuenta desde donde se enviará los correos
final String username = 'vacpcanta@gmail.com';
final String password = 'wgvyidxalemkifde'; // Contraseña habilitada del CORREO, solo para el envio de emails desde la aplicacion.
// -----------------------------------------

String usuarioRegistradoEmail;
String usuarioRegistradoPassword;
final bool usuarioRegistradoEstado = false;
String usuarioCodigo;

class LoginEasy extends StatefulWidget {
  @override
  _LoginEasyState createState() => _LoginEasyState();
}

class _LoginEasyState extends State<LoginEasy> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isDisabledButtonSiguiente;
  bool isDisabledButtonIngresar;
  bool isDisabledTextEmail;
  bool isDisabledTextCodigo;

  String tituloBoton;
  TextEditingController emailController = new TextEditingController();
  TextEditingController codigoController = new TextEditingController();
  String urll;

  @override
  initState() {
    super.initState();
    isDisabledButtonSiguiente = true;
    tituloBoton = 'Siguiente';
    isDisabledButtonIngresar = true;
    isDisabledTextEmail = false;
    isDisabledTextCodigo = true;
  }

  @override
  Widget build(BuildContext context) {
    validaciones() {
      if (emailController.text.isEmpty ||
          emailController.text == '' ||
          emailController.text == null) {
        setState(() {
          isDisabledButtonSiguiente = true;
        });
      } else {
        setState(() {
          isDisabledButtonSiguiente = false;
        });
      }
    }

    return Scaffold(
      //appBar: myAppBar(context, 'LOGIN EASY'),
      body: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/icon/logo-miincode-2.png',
                      height: 120,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // TITULO
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      alignment: Alignment.center,
                      child: Text('Inicia Sesión',
                          style: TextStyle(
                              fontSize: 35.0,
                              color: Color.fromRGBO(0, 0, 0, 0.8),
                              fontWeight: FontWeight.bold))),

                  // EMAIL
                  Container(
                    child: isDisabledTextEmail ? Container() : TextFormField(
                      enabled: !isDisabledTextEmail,
                      onChanged: (text) {
                        validaciones();
                      },
                      maxLength: 50,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      controller: emailController,
                      decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(),
                          labelText: 'Digita tu Correo Electrónico'),
                    ),
                  ),
                  // CODIGO
                  Container(
                    child: isDisabledTextCodigo ? Container() : TextFormField(
                      onChanged: (text) {
                        //validaciones();
                      },
                      maxLength: 50,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      controller: codigoController,
                      decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(),
                          labelText: 'Digita el Código de Acceso'),
                    ),
                  ),
                  // BUTTON Siguiente
                  isDisabledButtonSiguiente ? Container() :
                  Container(
                    child: RaisedButton(
                      textColor: Colors.white,
                      child: Text(tituloBoton, style: TextStyle(fontSize: 20),),
                      onPressed: isDisabledButtonSiguiente ? null :
                        () {
                          print('presionaste el boton... Siguiente.');
                          
                          // Valida si el usuario esta registrado o no
                          searchUserByEmail(emailController.text);

                          // Si el usuario NO esta registrado, se le envía al correo su CODIGO de acceso.
                          if ( !usuarioRegistradoEstado ) {
                            enviarCodigoAcceso();
                            showAlertDialog(context, 'Mensaje', 'Revise su correo electronico, se le ha enviado un codigo de acceso.');
                            print('NO registrado');
                          } else {
                            print('Registrado');
                          }
                          //enviarCodigoAcceso();
                        },
                      color: Colors.blueAccent,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.white,
                    ),
                  ),
                  // BUTTON Ingresar
                  isDisabledButtonIngresar ? Container() : Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, size: 35,),
                              onPressed: () {
                                print('presionaste el boton REENVIAR CODIGO...');    
                                setState(() {
                                  isDisabledButtonIngresar = true;
                                  isDisabledTextCodigo = true;
                                  isDisabledButtonSiguiente = false;
                                  isDisabledTextEmail = false;
                                });
                              },
                              color: Colors.redAccent,
                              disabledColor: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Container(
                            child: RaisedButton(
                              textColor: Colors.white,
                              child: Text('INGRESAR', style: TextStyle(fontSize: 20),),
                              onPressed: () {
                                /*
                                  Si digita el CODIGO correcto Ingresa.
                                */
                                if ( codigoController.text == usuarioCodigo ) {
                                  if ( !usuarioRegistradoEstado ) {
                                    registrarUsuario(context, emailController.text, codigoController.text);
                                  }
                                  Navigator.pushReplacementNamed(context, 'home');
                                  //showAlertDialog(context, 'Bienvenido', mensaje)
                                } else {
                                  showAlertDialog(context, 'Error', 'Codigo Incorrecto');
                                }
                                print('presionaste el boton INGRESAR...');
                              },
                              color: Colors.blueAccent,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.white,
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Usuarios> searchUserByEmail(String email) async {
    /* Servicio REST que devuelva TRUE or FALSE si el correo esta registrado o no. Ese valor se almacenará en la variable 'usuarioRegistradoEstado' */
    String url = urlSearchUserByEmail + email;
    final resp = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    
    Usuarios us = new Usuarios();

    if (resp.statusCode < 200 || resp.statusCode > 400 || json == null) {
        logger.w(throw new Exception("ERROR! El servicio presento un error en la conexión: "+resp.statusCode.toString()));
    }

    var extracData = json.decode(resp.body);
     print(' *********************  extracData["data"]'+extracData["data"].toString());
    us = extracData["data"];
    print('.--------------' + us.email);
    print('.--------------' + us.toString());

    return us;
  }

  registrarUsuario(BuildContext context, String _email, String _password) async {
    UsuarioRegistrarModel usRegistrarModel = new UsuarioRegistrarModel();
    usRegistrarModel.uid = '?';
    usRegistrarModel.email = _email;
    usRegistrarModel.password = _password;
    usRegistrarModel.nombres = '?';
    usRegistrarModel.apepat = '?';
    usRegistrarModel.apemat = '?';
    usRegistrarModel.dni = '88888888';
    usRegistrarModel.fec_nacimiento = '?';
    usRegistrarModel.genero = '?';
    usRegistrarModel.nro_movil = '999999999';
    usRegistrarModel.url_foto = '?';
    usRegistrarModel.fec_creacion = DateTime.now().toString();
    usRegistrarModel.fec_actualizacion = DateTime.now().toString();
    usRegistrarModel.estado = true;
    usRegistrarModel.perfiles_id = 1;

    var response;
    String datosJson = usuarioRmToJson(usRegistrarModel);
    var url = urlRegisterUser;
    response = await http.post(url, headers: {"Content-Type": "application/json"}, body: datosJson);
    var extractData = json.decode(response.body);
    String _data = extractData['message'];

    if (response.statusCode == 200) {
      //limpiarCampos();
      showAlertDialog(context, 'Éxito', _data + '\n' + emailController.text);
    } else {
      showAlertDialog(context, 'Error', '[' + response.statusCode.toString() + ']¨' + _data);
    }
  }

  enviarCodigoAcceso() async {
    setState(() {
      isDisabledButtonSiguiente = true; 
      tituloBoton = 'Procesando ...';
      usuarioCodigo = aleatorio().toString();
    });

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Invitación a MiinCode')
      ..recipients.add(emailController.text)
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Envio código de acceso :: 😀 :: ${DateTime.now()} - MIINCODE'
      //..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h2>Bienvenid(o)</h2>\n<p>Estimad(o): " + emailController.text + "</p><p>Su código de acceso es: <strong>"+usuarioCodigo+"</strong></p>";

    try {
      final sendReport = await send(message, smtpServer);
      logger.i('Message sent: ' + sendReport.toString());
      setState(() {
        isDisabledButtonSiguiente = true;
        isDisabledTextEmail = true;
        isDisabledButtonIngresar = false; 
        isDisabledTextCodigo = false;
      });
      codigoController.clear();
      return true;
    } on MailerException catch (e) {
      showAlertDialog(context, 'Error', 'No se pudo enviar el correo electronico.\n' + e.toString());
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
    //var connection = PersistentConnection(smtpServer);
    /*await connection.send(message);
    print('---------------------- '+connection.toString());*/
    //await connection.close(); 
  }

  aleatorio() {
    var rng = new Random();
    for (var i = 1000; i < 9999; i++) {
      return rng.nextInt(9999);
    }
  }

}
