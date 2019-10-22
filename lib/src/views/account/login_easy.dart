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
import 'package:miincode/src/utils/utils_conectividad.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
bool usuarioRegistradoEstado = false;
String usuarioCodigo;
String usuarioCodigoDesencriptado;

class LoginEasy extends StatefulWidget {
  @override
  _LoginEasyState createState() => _LoginEasyState();
}

MyGlobals myGlobals = new MyGlobals();
class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
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
      key: myGlobals.scaffoldKey,
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
                      validator: (value) {
                        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regExp = new RegExp(pattern);
                        if (value.length == 0) {
                          return "Se requiere ingresar un email.";
                        } else if(!regExp.hasMatch(value)){
                          return "Email inválido";
                        }else {
                          return null;
                        }
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
                          if ( _formKey.currentState.validate() == true ) {
                            print('-----> ' + _formKey.currentState.validate().toString());
                            // Busca el usuario en la BD y devuelve BOOLEANO si es encontrado o no.
                            Future<dynamic> aaa = searchUserByEmail(emailController.text);
                            //if ( !usuarioRegistradoEstado ) {
                            aaa.then((value) {
                              if ( !value ) {
                                // Si el usuario NO esta registrado, se le envía al correo su CODIGO de acceso.
                                enviarCodigoAcceso();
                                print('----------> NO registrado');
                              } else {
                                setState(() {
                                  isDisabledButtonSiguiente = true;
                                  isDisabledTextEmail = true;
                                  isDisabledButtonIngresar = false; 
                                  isDisabledTextCodigo = false;
                                  showAlertDialog(myGlobals.scaffoldKey.currentContext, 'Mensaje', 'Debe digitar su contraseña.');
                                });
                                print('----------> Registrado');
                              }
                            });                            
                          } else {
                            throw e;
                          }
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
                                  tituloBoton = 'Siguiente';
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
                                  final plainText = codigoController.text; 
                                  final key = encr.Key.fromLength(32);
                                  final iv = encr.IV.fromLength(16);
                                  final encrypter = encr.Encrypter(encr.AES(key));
                                  final encrypted = encrypter.encrypt(plainText, iv: iv);
                                  //usLogueadoModel.password = encrypted.base64;

                                  print('----------> usuarioCodigo    ' + usuarioCodigo);
                                  print('----------> encrypted.base64 ' + encrypted.base64);
                                if ( encrypted.base64 == usuarioCodigo ) {
                                  if ( !usuarioRegistradoEstado ) {
                                    registrarUsuario(myGlobals.scaffoldKey.currentContext, emailController.text, codigoController.text);
                                  }
                                  Navigator.pushReplacementNamed(context, 'home');
                                  //showAlertDialog(context, 'Bienvenido', mensaje)
                                } else {
                                  showAlertDialog(myGlobals.scaffoldKey.currentContext, 'Error', 'Codigo Incorrecto');
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
                  ),
                  Container(
                    child: btnShowLogin(context),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  searchUserByEmail(String email) async {
    /* Servicio REST que devuelva TRUE or FALSE si el correo esta registrado o no. Ese valor se almacenará en la variable 'usuarioRegistradoEstado' */
    String url = urlSearchUserByEmail + email;
    final resp = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    
    Usuarios us = new Usuarios();

    if (resp.statusCode < 200 || resp.statusCode > 400 || json == null) {
        logger.w("ERROR! El servicio presento un error en la conexión: "+resp.statusCode.toString());
        return false;
    } else {
      var extracData = json.decode(resp.body);
      us.id               = extracData["data"]["id"];
      us.uid              = extracData["data"]["uid"];
      us.email            = extracData["data"]["email"];
      us.password         = extracData["data"]["password"];
      us.nombres          = extracData["data"]["nombres"];
      us.apepat           = extracData["data"]["apepat"];
      us.apemat           = extracData["data"]["apemat"];
      us.fec_nacimiento   = extracData["data"]["fec_nacimiento"];
      us.genero           = extracData["data"]["genero"];
      us.dni              = extracData["data"]["dni"];
      us.url_foto         = extracData["data"]["url_foto"];
      us.nro_movil        = extracData["data"]["nro_movil"];
      us.fec_creacion     = extracData["data"]["fec_creacion"];
      us.fec_actualizacion= extracData["data"]["fec_actualizacion"];
      us.estado           = extracData["data"]["estado"];
      us.perfiles_id      = extracData["data"]["perfiles_id"];

      setState(() {
        usuarioCodigo = us.password;      
      });
      // Hace PERSISTENTE los datos del usuario Logueado.
      spGuardarDatosPersistentesDeUsuario(context, us.id, us.uid, us.email, us.nombres, us.apepat, us.apemat, 
      us.nro_movil, us.fec_nacimiento, us.genero, us.dni, us.url_foto, us.fec_creacion, us.fec_actualizacion, us.estado, us.perfiles_id, 'LoginEasy.dart');
      return true;
    }

  }

  registrarUsuario(BuildContext context, String _email, String _password) async {
    UsuarioRegistrarModel usRegistrarModel = new UsuarioRegistrarModel();

    final plainText = _password; 
    final key = encr.Key.fromLength(32);
    final iv = encr.IV.fromLength(16);
    final encrypter = encr.Encrypter(encr.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    usRegistrarModel.uid = '?';
    usRegistrarModel.email = _email;
    usRegistrarModel.password = encrypted.base64;
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

    try {
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
    } catch (e) {
      logger.w('ERROR: ' + e.toString());
    }
  }

  enviarCodigoAcceso() async {
      String pass = aleatorio().toString(); 
      final plainText = pass; 
      final key = encr.Key.fromLength(32);
      final iv = encr.IV.fromLength(16);
      final encrypter = encr.Encrypter(encr.AES(key));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
    setState(() {
      isDisabledButtonSiguiente = true; 
      tituloBoton = 'Procesando ...';
      usuarioCodigoDesencriptado = pass;
      usuarioCodigo = encrypted.base64;
    });

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Invitación a MiinCode')
      ..recipients.add(emailController.text)
      ..subject = 'Envio código de acceso :: 😀 :: ${DateTime.now()} - MIINCODE'
      ..html = "<h2>Bienvenid(o)</h2>\n<p>Estimad(o): " + emailController.text + "</p><p>Su código de acceso es: <strong>"+usuarioCodigoDesencriptado+"</strong></p>";

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
      showAlertDialog(myGlobals.scaffoldKey.currentContext, 'Mensaje', 'Revise su correo electronico, se le ha enviado un codigo de acceso.');
      return true;
    } on MailerException catch (e) {
      showAlertDialog(myGlobals.scaffoldKey.currentContext, 'Error', 'No se pudo enviar el correo electronico.\n' + e.toString());
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }

  aleatorio() {
    var rng = new Random();
    for (var i = 1000; i < 9999; i++) {
      return rng.nextInt(9999);
    }
  }

  Widget btnShowLogin(BuildContext context) {
    return RaisedButton.icon(
      icon: Icon(Icons.keyboard_backspace),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.green,
      textColor: Colors.black,
      onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
      label: Text('Ir a Login', style: TextStyle(fontSize: 15),),
    );
  }

}
