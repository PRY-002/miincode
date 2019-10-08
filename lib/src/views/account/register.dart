import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/usuario_model.dart';
import 'package:miincode/src/models/usuario_registrar_model.dart';
import 'package:miincode/src/providers/productos_provider.dart';
import 'package:miincode/src/providers/usuarios_provider.dart';
import 'package:miincode/src/providers/ws.dart';
import 'package:miincode/src/utils/utils.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encr;

/* LOGGER ------------------------------- */
var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));
/* LOGGER ------------------------------- */
final FirebaseAuth _auth = FirebaseAuth.instance;

Login login = new Login();

final Color colorNegro = Colors.black;

String dtFecNac;
DateTime fecNacElegido;
String _fecNacActual;
String _genero;
int idPerfil = 1; // 1: Invitado

bool estadoInputs = true;
bool condicion1 = true;
int selectedRadio = 0;

String controllerId;
String controllerUid;
TextEditingController controllerEmail = TextEditingController();
TextEditingController controllerPassword = TextEditingController();
TextEditingController controllerNombres = TextEditingController();
TextEditingController controllerApePat = TextEditingController();
TextEditingController controllerApeMat = TextEditingController();
TextEditingController controllerNroMovil = TextEditingController();
TextEditingController controllerDisponible = TextEditingController();
TextEditingController controllerFecNac = TextEditingController();
TextEditingController controllerGenero = TextEditingController();
TextEditingController controllerDni = TextEditingController();

class Register extends StatefulWidget {
  createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  File image;
  File foto;
  picker() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    foto = image; /* <---- GUARDA imagen en VARIABLE FLOBAL */
    _procesarImagen(image);
    setState(() {});
  }

  bool _success;
  String _userEmail;
  String _userUid;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;

      if ( val == 0 ) {
        _genero = 'F';
      } else if ( val == 1 ) {
        _genero = 'M';
      }

    });
  }

  @override
  Widget build(BuildContext contextRegister) {
    return Scaffold(
      //appBar: myAppBar(context, 'REGISTRO'),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Container(height: 20, child: Text('')),
            Expanded(child: datosCompletos(contextRegister))
          ],
        ),
      ),
    );
  }

  Widget datosCompletos(BuildContext context) {
    return Container(
      child: ListView(children: <Widget>[
        Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // TITULO
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Text(
                    'REGISTRO DE USUARIO',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // IMAGEN Y BOTON PARA AGREGAR IMAGEN...
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Center(
                      //child: image == null ? Text('Seleccione una imagen', style: TextStyle(color: Colors.purple),) : Image.file(image)
                      child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: 100,

                          //Image.file(image, width: 100, fit: BoxFit.cover),
                          child: image != null //usuarios[i].fotoUrl != null || usuarios[i].fotoUrl.isEmpty
                              ? ClipOval(
                                  child: Align(
                                    heightFactor: 1,
                                    widthFactor: 1,
                                    child: Image.file(image,
                                        width: 100, fit: BoxFit.cover),
                                    //child: Image.network('https://blogdesuperheroes.es/wp-content/plugins/BdSGallery/BdSGaleria/33783.jpg', width: 100, fit: BoxFit.cover)//usuarios[i].fotoUrl
                                  ),
                                )
                              : Column(children: <Widget>[
                                  ClipOval(
                                    child: Align(
                                      heightFactor: 1,
                                      widthFactor: 1,
                                      child: Image.asset('assets/no-image-account.png',
                                          width: 100, fit: BoxFit.cover),
                                    ),
                                  ),
                                ]),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.insert_photo),
                        onPressed: () {
                          picker();
                        },
                      )
                    ],
                  )),
                ),

                  //EMAIL
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      child: TextFormField(
                        validator: (value) {
                        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = new RegExp(pattern);
                          if (value.length == 0) {
                            return "El Email es necesario.";
                          } else if(!regExp.hasMatch(value)){
                            return "Email inválido";
                          }else {
                            return null;
                          }
                        },
                        enabled: estadoInputs,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        controller: controllerEmail,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Email'),
                      ),
                    ),
                  ),
                  // CONTRASEÑA
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      child: TextFormField(
                        validator: (value) {
                          //validarVacio(value, 'contraseña');
                          if (value.length == 0 || value.isEmpty ) {
                            return "La contraseña es necesaria.";
                          }
                        },
                        obscureText: true,
                        enabled: estadoInputs,
                        textAlign: TextAlign.center,
                        controller: controllerPassword,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Contraseña'),
                      ),
                    ),
                  ),
                // NOMBRES
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      child: TextFormField(
                        validator: (value) {
                          //validarVacio(value, 'contraseña');
                          if (value.length == 0 || value.isEmpty ) {
                            return "Los nombres son necesarios.";
                          }
                        },
                        enabled: estadoInputs,
                        textAlign: TextAlign.center,
                        controller: controllerNombres,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Nombres'),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    //APELLIDO PATERNO
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          child: TextFormField(
                            validator: (value) {
                            if (value.length == 0 || value.isEmpty ) {
                              return "El apellido paterno es necesario.";
                              }
                            },
                            enabled: estadoInputs,
                            textAlign: TextAlign.center,
                            controller: controllerApePat,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Apellido Paterno'),
                          ),
                        ),
                      ),
                    ),
                    //APELLIDO MATERNO
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          child: TextFormField(
                            validator: (value) {
                            if (value.length == 0 || value.isEmpty ) {
                              return "El apellido materno es necesario.";
                              }
                            },
                            enabled: estadoInputs,
                            textAlign: TextAlign.center,
                            controller: controllerApeMat,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Apellido Materno'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          // DNI
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              child: TextFormField(
                                validator: (value) {
                                if (value.length == 0 || value.isEmpty ) {
                                  return "El dni es necesario.";
                                  }
                                },
                                maxLength: 8,
                                scrollPadding: EdgeInsets.all(5),
                                enabled: estadoInputs,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: controllerDni,
                                decoration: InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(),
                                  labelText: 'DNI'),
                              ),
                            ),
                          ),
                          // FECHA DE NACIMIENTO
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: ButtonTheme(
                              minWidth: double.infinity,
                              height: 35,
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.0),
                                      border: Border.all(
                                          color: Colors.black12,
                                          style: BorderStyle.solid,
                                          width: 1)),
                                  child: Column(children: <Widget>[
                                    Text('Fecha de Nacimiento',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black38),
                                        textAlign: TextAlign.right),
                                    RaisedButton.icon(
                                      //textTheme: ButtonTextTheme.normal,
                                      color: Colors.white,
                                      label: Text(
                                        _fecNacActual != null && dtFecNac == null
                                            ? _fecNacActual = ''
                                            : dtFecNac == null
                                                ? 'Elige Fecha'
                                                : '${dtFecNac}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      icon: Icon(Icons.date_range),
                                      onPressed: () {
                                        estadoInputs == true
                                            ? DatePicker.showDatePicker(
                                                context,
                                                theme: DatePickerTheme(
                                                    backgroundColor: Colors.black,
                                                    cancelStyle: TextStyle(
                                                        color: Colors.red),
                                                    itemStyle: TextStyle(
                                                        color: Colors.white),
                                                    containerHeight: 220,
                                                    doneStyle: TextStyle(
                                                        color: Colors.green)),
                                                showTitleActions: true,
                                                minTime: DateTime(1980, 1, 1),
                                                maxTime: DateTime(2030, 12, 31),
                                                onChanged: (date) {
                                                },
                                                onConfirm: (date) {
                                                  fecNacElegido = date;
                                                  if (fecNacElegido != null ||
                                                      fecNacElegido != '') {
                                                    final f = new DateFormat('dd-MM-yyyy').format(fecNacElegido);
                                                    setState(() {
                                                      dtFecNac = f.toString();
                                                      _fecNacActual = dtFecNac;
                                                    });
                                                  } else {
                                                    showAlertDialog_1(context, 'Mensaje de Error.', 'Debe seleccioanr una fecha.');
                                                  }
                                                },
                                                currentTime: DateTime.now(),
                                                locale: LocaleType.es,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ])),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // GENERO Masculino o Femenino
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                    color: Colors.black12,
                                    style: BorderStyle.solid,
                                    width: 1)),
                            child: Column(
                              children: <Widget>[
                                Text('Género',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black38)),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    //Masculino
                                    Column(
                                      children: <Widget>[
                                        Radio(
                                            value: 1,
                                            groupValue: selectedRadio,
                                            activeColor: Colors.black,
                                            onChanged: (val) {
                                              setSelectedRadio(val);
                                            }),
                                        Text(
                                          'Masculino',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    //Femenino
                                    Column(
                                      children: <Widget>[
                                        Radio(
                                            value: 0,
                                            groupValue: selectedRadio,
                                            activeColor: Colors.black,
                                            onChanged: (val) {
                                              setSelectedRadio(val);
                                            }),
                                        Text(
                                          'Femenino',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    )
                  ],
                ),

                // NUMERO TELEFONICO
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          validator: (value) {
                          if (value.length == 0 || value.isEmpty ) {
                            return "El número móvil es necesario.";
                            }
                          },
                          maxLength: 20,
                          keyboardType: TextInputType.number,
                          enabled: estadoInputs,
                          textAlign: TextAlign.center,
                          controller: controllerNroMovil,
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(),
                            labelText: 'Número Móvil'),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 8,
                        child: Container(
                            child: InkWell(
                                child: Container(
                                    //padding: EdgeInsets.all(12.0),
                                    height: double.parse('50.0'),
                                    decoration: BoxDecoration(
                                      color: colorNegro,
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Material(
                                        color: Colors.transparent,
                                        child: btnRegistrar(context)
                                    ))))),
                    // Button SALIR
                    /*  ********************************************************************  */
                    Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: InkWell(
                            child: Container(
                              height: double.parse('50.0'),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Material(
                                  color: Colors.transparent,
                                  child: btnCerrar(context)),
                            ),
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        )
      ], padding: EdgeInsets.fromLTRB(10, 20, 10, 30)),
    );
  }

  Widget btnRegistrar(BuildContext context) {
    return InkWell(
        onTap: () {
          if ( _formKey.currentState.validate() ) {
          }
          registrarUsuario( 'SN', 
                            controllerEmail, 
                            controllerPassword, 
                            controllerNombres, 
                            controllerApePat, 
                            controllerApeMat, 
                            _fecNacActual, 
                            _genero, 
                            controllerDni, 
                            controllerNroMovil, 
                            DateTime.now().toString(), 
                            '', 
                            true, 
                            idPerfil
          );
          
        },
        child: Center(
          child: Text("REGISTRAR",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins-Bold",
                  fontSize: 18,
                  letterSpacing: 1.0)),
        ));
  }

  void limpiarCampos() {
    controllerEmail.clear();
    controllerPassword.clear();
    controllerNombres.clear();
    controllerApePat.clear();
    controllerApeMat.clear();
    controllerDni.clear();
    controllerNroMovil.clear();

  }

  Widget btnCerrar(BuildContext context) {
    return InkWell(
      onTap: () {
        showAlertDialog_3(context, 'IMPORTANTE', 'Desea cerrar la aplicación.', login );
      },
      child: Center(
        child: Text("CLOSE",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Poppins-Bold",
                fontSize: 18,
                letterSpacing: 1.0)),
      ),
    );
  }

  void _register( BuildContext context) async {
    try {
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
              email: controllerEmail.text, password: controllerPassword.text))
          .user;
      if (user != null) {
        UsuariosProvider up = UsuariosProvider();
        UsuarioModel um = UsuarioModel();
        setState(() {
          _success = true;
          _userEmail = user.email;
          _userUid = user.uid;

          um.uid = _userUid;
          um.email = _userEmail;

          if (_success) {
            up.crearUsuario(um);
            showAlertDialog_2(
                context,
                'IMPORTANTE',
                'Usuario ' +
                    _userEmail +
                    '\n registrado exitosamente. \n Deseas registrar otro ?',
                Login());
          }
        });
      } else {
        _success = false;
        if (_success != null) {
          showAlertDialog_2(
              context, 'IMPORTANTE', 'Could not register user.', Register());
        }
      }
    } on PlatformException catch (e) {
      print('-------------------->' +
          "-------------------->CODIGO ERROR: " +
          e.code);
      switch (e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          showAlertError(context, 'ERROR!',
              e.message + '\nEste correo ya esta en registrado.');
          break;
        case 'Error':
          showAlertError(context, 'ERROR!', e.message);
          break;
        default:
          showAlertDialog_1(context, 'ERROR!', 'Error al intentar REGISTRAR. ');
          break;
      }
    }
  }

  String validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El Email es necesario.";
    } else if(!regExp.hasMatch(value)){
      return "Email inválido";
    }else {
      return null;
    }
  }

  String validarVacio(String value, String nombreCampo) {
    if (value.length == 0 || value.isEmpty ) {
      return "El " + nombreCampo + " es necesario.";
    }
  }

  _procesarImagen(File img) async {
    foto = image;
    if (foto != null) {
      //producto.fotoUrl = null;
    }
    setState(() {});
  }

  Future<http.Response> registrarUsuario( String _uid, TextEditingController _email, TextEditingController _password, 
    TextEditingController _nombres, TextEditingController _apePat, TextEditingController _apeMat, String _fecNacimiento, String _genero, 
    TextEditingController _dni, TextEditingController _nroMovil, String _fecCreacion, String _fecActualizacion, bool _estado, int _perfilesId) async {
      
      ProductosProvider pp = new ProductosProvider();
      UsuarioRegistrarModel usRegistrarModel = new UsuarioRegistrarModel();

    try {

      usRegistrarModel.uid = _uid;
      usRegistrarModel.email = _email.text;

        /* Encriptandooo ------------------- */
          final plainText = _password.text; //
          final key = encr.Key.fromLength(32);
          final iv = encr.IV.fromLength(16);
          final encrypter = encr.Encrypter(encr.AES(key));
          final encrypted = encrypter.encrypt(plainText, iv: iv);
          print('--------------- PASS ENCRYPT... ' + encrypted.base64.toString());
        /* Encriptandooo ------------------- */

          usRegistrarModel.password       = encrypted.base64;
          usRegistrarModel.nombres        = _nombres.text;
          usRegistrarModel.apepat         = _apePat.text;
          usRegistrarModel.apemat         = _apeMat.text;
          usRegistrarModel.fec_nacimiento = _fecNacimiento;
          usRegistrarModel.genero         = _genero;
          usRegistrarModel.dni            = _dni.text;

          final _urlFoto = await pp.subirImagen(foto);  // SUBE LA FOTO
          if ( _urlFoto == null || _urlFoto.isEmpty) {
            showAlertDialog_1(context, 'Error', 'Se requiere agregar una foto.');
            usRegistrarModel.url_foto = '';  
          } else {

          usRegistrarModel.url_foto           = _urlFoto; 
          usRegistrarModel.nro_movil          = _nroMovil.text;
          usRegistrarModel.fec_creacion       = _fecCreacion;
          usRegistrarModel.fec_actualizacion  = _fecActualizacion;
          usRegistrarModel.estado             = _estado;
          usRegistrarModel.perfiles_id        = _perfilesId;

          String datosJson = usuarioRmToJson(usRegistrarModel);
          var url = urlRegisterUser;
          var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: datosJson);
       
          var extractData = json.decode(response.body);
          String _data = extractData['message'];
         // bool _rsEstado = extractData['estado'];

          if (response.statusCode == 200) {
            limpiarCampos();
            showAlertDialog_Register( context, _data + '\n' + controllerEmail.text, 'login');
          } else {
            showAlertDialog_1(context, 'Error','' + response.statusCode.toString() +' - '+ _data);
          }
            return response;
        }
    } catch (e) {
      logger.w('ERROR:\n' + e.toString());
    }
  }
}
