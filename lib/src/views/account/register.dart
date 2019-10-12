import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:async_loader/async_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/usuario_model.dart';
import 'package:miincode/src/models/usuario_registrar_model.dart';
import 'package:miincode/src/providers/codigos_provider.dart';
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

String _fecNacElegidoFormateado;
DateTime _fecNacElegido;
String _fecNacActual;
String _genero = 'F';
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

  bool isBtnEnabled = true;
  String tituloBoton = 'REGISTRAR';
  Color colorBoton = Colors.black;
  
  Animation tween;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File image;
  File foto;
  picker() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    foto = image; /* <---- GUARDA imagen en VARIABLE FLOBAL */
    _procesarImagen(image);
    setState(() {});
  }

  pickerCamera() async {
    File img = await ImagePicker.pickImage(
        source: ImageSource
            .camera); //ImagePicker.pickImage(source: ImageSource.gallery);
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

      if (val == 0) {
        _genero = 'F';
      } else if (val == 1) {
        _genero = 'M';
      }
    });
  }

  @override
  Widget build(BuildContext contextRegister) {
    return Scaffold(
      //appBar: myAppBar(context, 'REGISTRO'),
      body: Stack(
        alignment: Alignment.center,
        children: _datosCompletos(contextRegister),
      ),
    );
  }

  List<Widget> _datosCompletos(BuildContext context) {
    Container contenedor = new Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          Container(height: 20, child: Text('')),
          Expanded(
              child: Container(
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
                        child: Center(
                            child: Container(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Container(
                                //color: Colors.redAccent,
                                child: image != null
                                    ? ClipOval(
                                        child: Image.file(image,
                                            fit: BoxFit.cover,
                                            height: 150,
                                            width: 150),
                                      )
                                    : Column(children: <Widget>[
                                        ClipOval(
                                          child: Image.asset(
                                              'assets/no-image-account.png', //-account.png',
                                              fit: BoxFit.cover,
                                              height: 150,
                                              width: 150),
                                        ),
                                      ]),
                              ),
                              Container(
                                child: IconButton(
                                    icon: Icon(Icons.photo_camera, size: 30),
                                    onPressed: () {
                                      pickerCamera();
                                    }),
                              ),
                            ],
                          ),
                        )),
                      ),

                      //EMAIL
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          child: TextFormField(
                            validator: (value) {
                              String pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regExp = new RegExp(pattern);
                              if (value.length == 0) {
                                return "Ingrese un email.";
                              } else if (!regExp.hasMatch(value)) {
                                return "Email inválido";
                              } else {
                                return null;
                              }
                            },
                            enabled: estadoInputs,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.emailAddress,
                            controller: controllerEmail,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email'),
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
                              if (value.length == 0 || value.isEmpty) {
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
                                if (value.length == 0 || value.isEmpty) {
                                  return "Los nombres son necesarios.";
                                }
                              },
                              enabled: estadoInputs,
                              textAlign: TextAlign.center,
                              controller: controllerNombres,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nombres'),
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
                                    if (value.length == 0 || value.isEmpty) {
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
                                    if (value.length == 0 || value.isEmpty) {
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
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            border: Border.all(
                                                color: Colors.black12,
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        child: Column(children: <Widget>[
                                          Text('Fecha de Nacimiento',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black38),
                                              textAlign: TextAlign.right),
                                          RaisedButton.icon(
                                            //textTheme: ButtonTextTheme.normal,
                                            color: Colors.white,
                                            label: Text(
                                              _fecNacActual != null &&
                                                      _fecNacElegidoFormateado ==
                                                          null
                                                  ? _fecNacActual = ''
                                                  : _fecNacElegidoFormateado ==
                                                          null
                                                      ? 'Elige Fecha'
                                                      : '${_fecNacElegidoFormateado}',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            icon: Icon(Icons.date_range),
                                            onPressed: () {
                                              estadoInputs == true
                                                  ? DatePicker.showDatePicker(
                                                      context,
                                                      theme: DatePickerTheme(
                                                          backgroundColor:
                                                              Colors.black,
                                                          cancelStyle:
                                                              TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                          itemStyle: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          containerHeight: 220,
                                                          doneStyle: TextStyle(
                                                              color: Colors
                                                                  .green)),
                                                      showTitleActions: true,
                                                      minTime:
                                                          DateTime(1980, 1, 1),
                                                      maxTime: DateTime(
                                                          2030, 12, 31),
                                                      onChanged: (date) {},
                                                      onConfirm: (date) {
                                                        _fecNacElegido = date;
                                                        if (_fecNacElegido !=
                                                                null ||
                                                            _fecNacElegido !=
                                                                '') {
                                                          final f = new DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(
                                                                  _fecNacElegido);
                                                          setState(() {
                                                            _fecNacElegidoFormateado =
                                                                f.toString();
                                                            _fecNacActual =
                                                                _fecNacElegidoFormateado;
                                                          });
                                                        } else {
                                                          showAlertDialog(
                                                              context,
                                                              'Mensaje de Error.',
                                                              'Debe seleccioanr una fecha.');
                                                        }
                                                      },
                                                      currentTime:
                                                          DateTime.now(),
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
                                              fontSize: 12,
                                              color: Colors.black38)),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                          height: double.parse('50.0'),
                                          decoration: BoxDecoration(
                                            color: colorBoton,
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          child: Material(
                                              color: Colors.transparent,
                                              child: btnRegistrar(context)))))),
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
          ))
        ],
      ),
    );

    var l = new List<Widget>();
    l.add(contenedor);


    return l;
  }

  Widget btnRegistrar(BuildContext context) {
    return InkWell(
        onTap: isBtnEnabled
            ? () {
              print('valor BOOLEAN true           ---> ' + isBtnEnabled.toString());
                if (!_formKey.currentState.validate()) {
                }
                if (_fecNacActual == null || _fecNacActual.isEmpty) {
                  showAlertDialog( context, '! Error', 'Debe seleccionar una fecha de nacimiento.');
                } else if (_genero == null || _genero.isEmpty) {
                  showAlertDialog( context, '! Error', 'Debe seleccionar el género.');
                } else {
                  registrarUsuario('SN', controllerEmail, controllerPassword, controllerNombres, controllerApePat,
                      controllerApeMat, _fecNacActual, _genero, controllerDni, controllerNroMovil,
                      DateTime.now().toString(), DateTime.now().toString(), true, idPerfil);
                }

              }
            : () {
                print('valor BOOLEAN false           ---> ' + isBtnEnabled.toString());
              },
        child: Center(
          child: Text(tituloBoton,
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
    _fecNacActual = '';
    _genero = 'F';
  }

  Widget btnCerrar(BuildContext context) {
    return InkWell(
      onTap: () {
        showAlertDialog_redireccionable(
            context, 'Mensaje', 'Desea cerrar la aplicación.', 'login');
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

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Ingrese un email.";
    } else if (!regExp.hasMatch(value)) {
      return "Email inválido";
    } else {
      return null;
    }
  }

  _procesarImagen(File img) async {
    foto = image;
    if (foto != null) {
      //producto.fotoUrl = null;
    }
    setState(() {});
  }

  Future<http.Response> registrarUsuario( String _uid,
                                          TextEditingController _email,
                                          TextEditingController _password,
                                          TextEditingController _nombres,
                                          TextEditingController _apePat,
                                          TextEditingController _apeMat,
                                          String _fecNacimiento,
                                          String _genero,
                                          TextEditingController _dni,
                                          TextEditingController _nroMovil,
                                          String _fecCreacion,
                                          String _fecActualizacion,
                                          bool _estado,
                                          int _perfilesId) async {

    CodigosProvider cp = new CodigosProvider();
    UsuarioRegistrarModel usRegistrarModel = new UsuarioRegistrarModel();

    try {

      usRegistrarModel.fec_nacimiento = _fecNacimiento;
      usRegistrarModel.uid = _uid;
      usRegistrarModel.email = _email.text;

      /* Encriptandooo ------------------- */
      final plainText = _password.text; //
      final key = encr.Key.fromLength(32);
      final iv = encr.IV.fromLength(16);
      final encrypter = encr.Encrypter(encr.AES(key));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      /* Encriptandooo ------------------- */

      usRegistrarModel.password = encrypted.base64;
      usRegistrarModel.nombres = _nombres.text;
      usRegistrarModel.apepat = _apePat.text;
      usRegistrarModel.apemat = _apeMat.text;
      usRegistrarModel.genero = _genero;
      usRegistrarModel.dni = _dni.text;

      final _urlFoto = await cp.subirImagen(foto); // SUBE LA FOTO


      

        if (_urlFoto == null || _urlFoto.isEmpty || _urlFoto == '') {
          showAlertDialog(context, 'Error', 'Se requiere agregar una foto.');
          usRegistrarModel.url_foto = '';
        } else {
            if (isBtnEnabled){
              setState(() {
                isBtnEnabled = false;
                tituloBoton = 'Procesando...';
                colorBoton = Colors.grey;
              });        


              usRegistrarModel.url_foto = _urlFoto;
              usRegistrarModel.nro_movil = _nroMovil.text;
              usRegistrarModel.fec_creacion = _fecCreacion;
              usRegistrarModel.fec_actualizacion = _fecActualizacion;
              usRegistrarModel.estado = _estado;
              usRegistrarModel.perfiles_id = _perfilesId;
              var response;

              if (usRegistrarModel.email != '' &&
                  usRegistrarModel.password != '' &&
                  usRegistrarModel.nombres != '' &&
                  usRegistrarModel.apepat != '' &&
                  usRegistrarModel.apemat != '' &&
                  usRegistrarModel.fec_nacimiento != '' &&
                  usRegistrarModel.genero != '' &&
                  usRegistrarModel.url_foto != '') {

                String datosJson = usuarioRmToJson(usRegistrarModel);
                var url = urlRegisterUser;
                response = await http.post(url,
                    headers: {"Content-Type": "application/json"}, body: datosJson);

                var extractData = json.decode(response.body);
                String _data = extractData['message'];
                // bool _rsEstado = extractData['estado'];

                if (response.statusCode == 200) {
                  limpiarCampos();
                  showAlertDialog_redireccionable(
                      context, 'Éxito', _data + '\n' + controllerEmail.text, 'login');
                } else {
                  showAlertDialog(context, 'Error',
                      '[' + response.statusCode.toString() + ']¨' + _data);
                }

              setState(() {
                isBtnEnabled = true;
                tituloBoton = 'REGISTRAR';
                colorBoton = Colors.black;
              });

          }



          return response;
        }
      }


    } catch (e) {
      logger.w('ERROR:\n' + e.toString());
    }
  }
}
