import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/usuarios.dart';
import 'package:miincode/src/providers/ws.dart';
import 'package:miincode/src/utils/utils_conectividad.dart';

import 'package:connectivity/connectivity.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:http/http.dart' as http; 
import 'package:encrypt/encrypt.dart' as encr;

/* ----- LOGGER ---------------- */
var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));
/* ----- LOGGER ---------------- */

final Color colorNegro = Colors.black;
Login login = new Login();

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

final FirebaseAuth _auth = FirebaseAuth.instance;

/* VARIABLES */
final _styleLabel = new TextStyle(fontSize: 12.0, color: colorNegro);
final _estiloLink = new TextStyle(fontSize: 12.0, color: colorNegro);
final _estiloLabel = new TextStyle(fontSize: 18, color: colorNegro);

final String _url = 'https://miincode.firebaseio.com';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isButonDisabled = false;
  bool isObscurTextPassword = true;
  Color colorBotonObscureTextPassword = Colors.black;
  Icon iconBotonObscureTextPassword = Icon(Icons.visibility_off);

  String tituloBoton = 'INGRESAR';
  Color colorBoton = Colors.black;
  Color colorTexto = Colors.white;

  final _formKey = GlobalKey<FormState>();
  final Color colorNegro = Colors.black;
  final Color colorButton = Colors.black;

  @override
  Widget build(BuildContext context) {
    validacionEstado(){
    if ( _emailController.text.isEmpty || _emailController.text == '') {
      print('El nombre de usuario esta vacío.');
      setState(() {
        isButonDisabled = true;
      });
    } else if ( _passwordController.text.isEmpty || _passwordController.text == '') {
      print('La contraseña esta vacía.');
      setState(() {
        isButonDisabled = true;
      });
    } else {
      setState(() {
        isButonDisabled = false;
      });
    }
  }
    
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 70.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icon/logo-miincode-2.png',
                    height: 120,
                  ),
                ),
                SizedBox(height: 20.0),
                // TITULO
               Container(
                    alignment: Alignment.center,
                    child: Text('LOGIN',
                        style: TextStyle(
                            fontSize: 35.0,
                            color: Color.fromRGBO(0, 0, 0, 0.8),
                            fontWeight: FontWeight.bold
                        )
                    )
                ),
                SizedBox(height: 20.0),

                Expanded(
                    child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    // Input USUARIO
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                      child: TextFormField(
                        onChanged: (text) { 
                          validacionEstado();
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
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorNegro, fontSize: 15),
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: 'Usuario',
                            labelStyle: _estiloLabel,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)))),
                      ),
                    ),
                    SizedBox(height: 10.0),

                    // Input PASSWORD
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                      child: Row(
                        children: <Widget>[
                          // CONTRASEÑA
                          Expanded(
                            flex: 10,
                            child: TextFormField(
                              onChanged: (text) {
                                validacionEstado();
                              },
                              validator: (value) {
                                if (value.length == 0 || value.isEmpty ) {
                                  return "Se requiere ingresar la contraseña.";
                                  }
                              },
                                obscureText: isObscurTextPassword,
                                keyboardType: TextInputType.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: colorNegro, fontSize: 15),
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    labelStyle: _estiloLabel,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            width: 1,
                                            color: Colors.red),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(8))))
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: iconBotonObscureTextPassword,
                              onPressed: (){
                                setState(() {
                                  isObscurTextPassword = !isObscurTextPassword; 
                                  if (isObscurTextPassword ) {
                                    colorBotonObscureTextPassword = Colors.black;
                                    iconBotonObscureTextPassword = Icon(Icons.visibility, color: colorBotonObscureTextPassword, size: 30);
                                  } else {
                                    colorBotonObscureTextPassword = Colors.grey;
                                    iconBotonObscureTextPassword = Icon(Icons.visibility_off, color: colorBotonObscureTextPassword, size: 30);
                                  }
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),

                    // Button INGRESAR y SALIR
                    /*  ********************************************************************  */
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                      child: Row(
                        children: <Widget>[
                          // BUton INGRESAR
                          Expanded(
                            flex: 8,
                            child: AbsorbPointer(
                              absorbing: isButonDisabled,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                color: colorBoton,
                                textColor: colorTexto,
                                onPressed: isButonDisabled ? null : (){
                                      print('Valor del BOOLEANO... ' + isButonDisabled.toString());
                                       if ( !_formKey.currentState.validate() ) { 
                                         setState(() {
                                          isButonDisabled = false; 
                                         });
                                       }
                                        verificarConexionInternet(context);
                                    },
                                child: Text(tituloBoton, style: TextStyle(fontSize: 20)),
                                disabledColor: Colors.grey,
                                disabledTextColor: Colors.white,
                              ),
                            )
                          ),

                          // Button SALIR
                          /*  ********************************************************************  */
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: AbsorbPointer(
                                absorbing: isButonDisabled,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                  color: Colors.red,
                                  textColor: colorTexto,
                                  onPressed: (){
                                    showAlertDialogCerrarsesion(context, 'Mensaje', 'Desea cerrar la aplicación ?');                                        
                                  },
                                  child: Text('Salir', style: TextStyle(fontSize: 20),),
                                  disabledColor: Colors.grey,
                                  disabledTextColor: Colors.white,
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),

                    /*  ********************************************************************  */
                    Container(
                      alignment: Alignment.center,
                      child:
                          Text('Aún no estas registrado ?', style: _styleLabel),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                        alignment: Alignment.center,
                        height: 20,
                        child: btnShowRegister(context)),
                    SizedBox(height: 5.0),
                    Container(
                        alignment: Alignment.center,
                        height: 20,
                        child: btnShowLoginEasy(context))
                        
                    /*  ********************************************************************  */
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btnCerrar(BuildContext context) {
    return InkWell(
      onTap: () {
        showAlertDialogCerrarsesion(context, 'Mensaje', 'Desea cerrar la aplicación.');
      },
      child: Center(
        child: Text("CLOSE",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Poppins-Bold",
                fontSize: 18,
                letterSpacing: 1.0)),
      ),
    );
  }

  Widget btnShowRegister(BuildContext context) {
    return OutlineButton(
      child: Text('Click Aquí', style: _estiloLink),
      borderSide:
          BorderSide(color: colorNegro, style: BorderStyle.solid, width: 0.8),
      onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
    );
  }

  Widget btnShowLoginEasy(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: Colors.green,
      textColor: colorTexto,
      onPressed: () => Navigator.pushReplacementNamed(context, 'logineasy'),
      child: Text('Login Facil', style: TextStyle(fontSize: 15),),
    );
  }

  bool validarVaciosEmailPass(BuildContext context, String _usu, String _pass) {
    try {
      if (_usu.isEmpty || _usu == null) {
        showAlertDialog(
            context, 'Mensaje', 'El campo de Username NO puede estar vacío.');
        return true;
      } else {
        if (_pass.isEmpty || _pass == null) {
          showAlertDialog(context, 'Mensaje',
              'El campo de Password no puede estar vacío.');
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      logger.w(e.toString());
    }
  }

verificarConexionInternet(BuildContext context) async {


    int opc = 0;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      opc = 1;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      opc = 2;
    } else {
      showAlertDialog(context, 'Error', 'No puede conectarse. Por favor, compruebe la conexión a Internet');
      opc = 0;
    }

    if (opc != 0) {
     // Provider.of<LoginState>(context).login(); /* A.C. COMENTADO POR QUE DEJABA INGRESAR SIN LOGUEAR */
        iniciarSesion(context);
    }

  }


  Future<http.Response> iniciarSesion (BuildContext context) async {

    setState(() {
    isButonDisabled=true; 
    });
    //LoginModel usLogueadoModel = new LoginModel();
    Usuarios usLogueadoModel = new Usuarios();
    String msj = '';

    try {
      
      usLogueadoModel.email = _emailController.text;

      if ( _passwordController.text != null || _passwordController.text != '') { /* Encriptando password ingresado */
        final plainText = _passwordController.text; 
        final key = encr.Key.fromLength(32);
        final iv = encr.IV.fromLength(16);
        final encrypter = encr.Encrypter(encr.AES(key));
        final encrypted = encrypter.encrypt(plainText, iv: iv);
        usLogueadoModel.password = encrypted.base64;
      }


      print("1 "+usLogueadoModel.password + " 2 "+ usLogueadoModel.email);

      //String datosJson = loginToJson(usLogueadoModel);
      String datosJson = loginToJson(usLogueadoModel);
      var url = urlLogin;
      var response = await http.post( url, headers: {"Content-Type": "application/json"}, body: datosJson );      
      var extractData = json.decode(response.body);

      if ( response.statusCode == 200 ) {
        // Almacena Datos en Shared Preference --------------------
        spGuardarDatosPersistentesDeUsuario( context, 
          extractData['data']['id'],                extractData['data']['uid'],             extractData['data']['email'],
          extractData['data']['nombres'],           extractData['data']['apepat'],          extractData['data']['apemat'],
          extractData['data']['nro_movil'],         extractData['data']['fec_nacimiento'],  extractData['data']['genero'],
          extractData['data']['dni'],               extractData['data']['url_foto'],        extractData['data']['fec_creacion'],
          extractData['data']['fec_actualizacion'], extractData['data']['estado'],          extractData['data']['perfiles_id'],
          'login.dart'
        );

        Navigator.pushReplacementNamed(context, 'home');
        setState(() {
          isButonDisabled = false; 
          tituloBoton = 'INGRESAR';
        });

      } else {
        setState(() {
          isButonDisabled = false; 
          tituloBoton = 'INGRESAR';
        });
        msj = extractData['message'];
        if ( _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty ) {
          showAlertDialog(context, 'ERROR', '['+response.statusCode.toString()+'] ' +  msj);
        }
      }
      /* setState(() {
        isButtonEnabled = !isButtonEnabled;
        print('------- setState -- valor Boolean ' + isButtonEnabled.toString());
      }); */

      return response;
    } catch (e) {
      logger.w(e.toString());
    }
  }

/*
  Future<http.Response> iniciarSesion (BuildContext context) async {

    LoginModel usLogueadoModel = new LoginModel();
    String msj = '';
    List data;

    try {
      
      usLogueadoModel.email = _emailController.text;

      if ( _passwordController.text != null || _passwordController.text != '') { 
        final plainText = _passwordController.text; 
        final key = encr.Key.fromLength(32);
        final iv = encr.IV.fromLength(16);
        final encrypter = encr.Encrypter(encr.AES(key));
        final encrypted = encrypter.encrypt(plainText, iv: iv);
        usLogueadoModel.password = encrypted.base64;
      }

      String datosJson = loginToJson(usLogueadoModel);
      var url = urlLogin;
      var response = await http.post( url, headers: {"Content-Type": "application/json"}, body: datosJson );      
      var  extractData = json.decode(response.body);

      if ( response.statusCode == 200 ) {        

        msj = extractData['message'];

        spGuardarDatosPersistentesDeUsuario( context, 
          extractData['data']['id'],                extractData['data']['uid'],             extractData['data']['email'],
          extractData['data']['nombres'],           extractData['data']['apepat'],          extractData['data']['apemat'],
          extractData['data']['nro_movil'],         extractData['data']['fec_nacimiento'],  extractData['data']['genero'],
          extractData['data']['dni'],               extractData['data']['url_foto'],        extractData['data']['fec_creacion'],
          extractData['data']['fec_actualizacion'], extractData['data']['estado'],          extractData['data']['perfiles_id'],
          'login.dart'
        );

        spPintarDatosUsuarioLogueado();
        goPage(context, Login());

      } else {
        msj = extractData['message'];
        if ( _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty ) {
          showAlertDialog(context, 'ERROR', '['+response.statusCode.toString()+'] ' +  msj);
        }
      }
      return response;
    } catch (e) {
      logger.w(e.toString());
    }
  }*/

  void showSnackBar(BuildContext context, String value) {
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(value),
        action: SnackBarAction(
          label: 'SI',
          onPressed: (){
            Navigator.pushReplacementNamed(context, 'home');
          },
        ),
      )
    );
  }
}



/*
  void _signInEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UsuarioModel um = new UsuarioModel();
      FirebaseUser userLogueado = (await _auth.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text)).user;
      assert(userLogueado != null);
      assert(await userLogueado.getIdToken() != null);
      final FirebaseUser currentUSer = await _auth.currentUser();
      assert(userLogueado.uid == currentUSer.uid);

      // Almacenando en SQFLITE <--------------------------------------
      if (userLogueado != null) {
        //final usu = UsuarioModel(id: 'A000001', uid: currentUSer.uid, email: currentUSer.email, nombres: 'Víctor Anselmo', apepat: 'Canta', apemat: 'Pandal', nromovil: '924294123', disponible: 'true', fotoUrl: 'https://res.cloudinary.com/ddsv1vilp/image/upload/v1568678410/personal/vacp_llezyi.jpg', fecnac: '24/08/1984', genero: 'Masculino', dni: '42570587');
        um.uid = userLogueado.uid;
        um.email = userLogueado.email;
        um.disponible = 'true';
        
        // Obteniendo ID de Usuario Logueado----------------------------------------------
        //UsuariosProvider up = new UsuariosProvider();
        final url = '$_url/usuarios.json';
        final resp = await http.get(url);
        final Map<String, dynamic> decodData = json.decode(resp.body);
        //final List<UsuarioModel> usuarios = new List();

        if ( decodData == null ) {
          logger.i('--------------------> NO se encontraron datos.');
        } else {
          decodData.forEach( (id, prod) {
            logger.i('--------------------> SE ENCONTRO ---->' + id);
            final prodTemp = UsuarioModel.fromJson(prod);
            if ( prodTemp.email == um.email) {
              um.id = id;
              logger.i('--------------------> SE ENCONTRO =======>' + id);
              logger.i('--------------------> SE ENCONTRO =======>' + um.id);
            }
          });
        }
        // -------------------------------------------------------------------------------
        //up.cargarUsuarios().then((onValue){  
        //});

        DatabaseHelper.db.existeUsuario(userLogueado.email).then(
          (value){
            if ( value ) {
              logger.i('------------------------> Se actualizaran Datos en SQLITE');
              DatabaseHelper.db.actualizarUsuario(um);
            } else {
              logger.i('------------------------> Se crearan Datos en SQLITE');
              DatabaseHelper.db.crearUsuario(um);
            }
            logger.i('------------------------> Existe usuario: ' + value.toString());
            DatabaseHelper.db.pintaDatosRegistradosDeUsuario(um.email);
          }, onError: (error) {
            logger.i('------------------------> ERROR: ' + error);
          }
        );        
      } else {
      }
      // Almacenando en SQFLITE <--------------------------------------
      Navigator.pushReplacementNamed(context, 'home');
      logger.i('------------------------> Usuario ' + userLogueado.email + ' Logueado Exitosamente.');
      //DatabaseHelper.db.pintaDatosRegistradosDeUsuario(userLogueado.email);
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          showAlertDialog(context, 'Importante', 'Correo electrónico inválido.');
          break;
        case 'ERROR_USER_NOT_FOUND':
          showAlertDialog(context, 'Importante', 'El correo indicado no esta registrado.');
          break;
        case 'ERROR_WRONG_PASSWORD':
          showAlertDialog(context, 'Importante', 'La contraseña no es correcta');
          break;
        case 'Error':
          showAlertDialog(context, 'Importante', e.message);
          logger.wtf(e.message);
          break;
        default:
          showAlertDialog(
              context, 'Importante', 'Error al intentar ingresar. ' + e.message);
          break;
      }
    }
  }
*/