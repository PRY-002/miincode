import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/usuario_registrar_model.dart';
import 'package:miincode/src/providers/codigos_provider.dart';
import 'package:miincode/src/providers/ws.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encr;

/* LOGGER ------------------------------- */
var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));
/* LOGGER ------------------------------- */

String _fecNacElegidoFormateado;
DateTime _fecNacElegido;
String _fecNacActual;
String _genero = 'F';
int idPerfil = 1; // 1: Invitado

int selectedRadio = 0;

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
String _urlFoto;

class Register extends StatefulWidget {
  createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool isButonDisabled2 = false;

  bool isButonDisabled = false;
  String tituloBoton = 'REGISTRAR';
  Color colorBoton = Colors.black;
  Color colorTexto = Colors.white;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File image;
  File foto;
  
  pickerCamera() async {
    File img = await ImagePicker.pickImage( source: ImageSource.camera); //ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    foto = image; /* <---- GUARDA imagen en VARIABLE FLOBAL */
    //_procesarImagen(context, image);
    setState(() {});
  }
 
@override
  void initState() {
    isButonDisabled = true;
    super.initState();
  }


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
    validacionEstado(){
      if ( controllerEmail.text.isEmpty || controllerEmail.text == '') {
        setState(() {
          isButonDisabled = true;
        });
      } else if ( controllerPassword.text.isEmpty || controllerPassword.text == '') {
        setState(() {
          isButonDisabled = true;
        });
      } else if ( controllerNombres.text.isEmpty || controllerNombres.text == '') {
        setState(() {
          isButonDisabled = true;
        });
      } else if ( controllerApePat.text.isEmpty || controllerApePat.text == '') {
        setState(() {
          isButonDisabled = true;
        });
      } else if ( controllerApeMat.text.isEmpty || controllerApeMat.text == '') {
        setState(() {
          isButonDisabled = true;
        });
      } else if ( _fecNacActual == null || _fecNacActual.isEmpty || _fecNacActual == '' ) {
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
        body: Container(
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
                            onChanged: (text) { 
                              validacionEstado();
                            },
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
                            onChanged: (text) { 
                              validacionEstado();
                            },
                            validator: (value) {
                              //validarVacio(value, 'contraseña');
                              if (value.length == 0 || value.isEmpty) {
                                return "La contraseña es necesaria.";
                              }
                            },
                            obscureText: true,
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
                              onChanged: (text) { 
                                validacionEstado();
                              },
                              validator: (value) {
                                //validarVacio(value, 'contraseña');
                                if (value.length == 0 || value.isEmpty) {
                                  return "Los nombres son necesarios.";
                                }
                              },
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
                                  onChanged: (text) { 
                                    validacionEstado();
                                  },
                                  validator: (value) {
                                    if (value.length == 0 || value.isEmpty) {
                                      return "El apellido paterno es necesario.";
                                    }
                                  },
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
                                  onChanged: (text) { 
                                    validacionEstado();
                                  },
                                  validator: (value) {
                                    if (value.length == 0 || value.isEmpty) {
                                      return "El apellido materno es necesario.";
                                    }
                                  },
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
                                      onChanged: (text) { 
                                        validacionEstado();
                                      },
                                      maxLength: 8,
                                      scrollPadding: EdgeInsets.all(5),
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      controller: controllerDni,
                                      decoration: InputDecoration(
                                        hintText: '88888888',
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
                                              _fecNacActual != null && _fecNacElegidoFormateado == null
                                                ? 
                                              _fecNacActual = ''
                                                : 
                                              _fecNacElegidoFormateado == null
                                                  ? 
                                                'Elige Fecha'
                                                  : 
                                                '${_fecNacElegidoFormateado}',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            icon: Icon(Icons.date_range),
                                            onPressed: () {
                                              DatePicker.showDatePicker( context,
                                                  currentTime: null, //DateTime.now(),
                                                  locale: LocaleType.es,                                                      
                                                  theme: DatePickerTheme(
                                                    backgroundColor: Colors.black,
                                                    cancelStyle: TextStyle( color: Colors.red),
                                                    itemStyle: TextStyle( color: Colors.white),
                                                    containerHeight: 220,
                                                    doneStyle: TextStyle( color: Colors.green)
                                                  ),
                                                  showTitleActions: true,
                                                  
                                                  minTime: DateTime(1980, 1, 1),
                                                  maxTime: DateTime(2030, 12, 31),
                                                  //onChanged: (date) {},
                                                  onConfirm: (date) {
                                                    _fecNacElegido = date;
                                                    if (_fecNacElegido != null) {
                                                      final fechaFormateada = new DateFormat('dd-MM-yyyy').format(_fecNacElegido);
                                                      setState(() {
                                                        _fecNacElegidoFormateado = fechaFormateada.toString();
                                                        _fecNacActual = _fecNacElegidoFormateado;
                                                      });
                                                    } else {
                                                      showAlertDialog( context, 'Mensaje de Error.', 'Debe seleccioanr una fecha.' );
                                                    }
                                                  },
                                                );
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
                                onChanged: (text) { 
                                  validacionEstado();
                                },
                                maxLength: 20,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: controllerNroMovil,
                                decoration: InputDecoration(
                                  hintText: '999999999',
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
                          // boton REGISTRAR
                          Expanded(
                              flex: 8,
                              child: AbsorbPointer(
                                absorbing: isButonDisabled,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                  color: colorBoton,
                                  textColor: colorTexto,
                                  onPressed: isButonDisabled ? null : () {                                    
                                      if (_fecNacActual == null || _fecNacActual.isEmpty) {
                                        showAlertDialog( context, '! Error', 'Debe seleccionar una fecha de nacimiento.');
                                      } else if (_genero == null || _genero.isEmpty) {
                                        showAlertDialog( context, '! Error', 'Debe seleccionar el género.');
                                      } else if ( !_formKey.currentState.validate() ) {
                                        setState(() {
                                          isButonDisabled = true; 
                                        });
                                      } else {

                                        registrarUsuario('SN', controllerEmail, controllerPassword, controllerNombres, controllerApePat,
                                          controllerApeMat, _fecNacActual, _genero, controllerDni, controllerNroMovil,
                                          DateTime.now().toString(), DateTime.now().toString(), true, idPerfil);
                                      }
                                    },
                                  child: Text(tituloBoton,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins-Bold",
                                      fontSize: 18,
                                      letterSpacing: 1.0)),
                                  disabledColor: Colors.grey,
                                  disabledTextColor: Colors.white,
                                ),
                              )
                          ),
                          // Button SALIR
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                color: Colors.red,
                                onPressed: (){
                                  showAlertDialogRedireccionableOpc_siNO( context, 'Mensaje', 'Desea crear usuario ?', 'login');
                                },
                                child: Text('CERRAR', style: TextStyle(color: Colors.white)),
                              )
                            )
                          )
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
      )
    );
  }

  void limpiarCampos() {
    controllerEmail.clear();
    controllerPassword.clear();
    controllerNombres.clear();
    controllerApePat.clear();
    controllerApeMat.clear();
    controllerDni.clear();
    controllerNroMovil.clear();
    _fecNacElegido = null;
    _fecNacElegidoFormateado = '';
    _fecNacActual = '';
    _genero = 'F';
    _urlFoto = '';
  }

  registrarUsuario( String _uid, TextEditingController _email, TextEditingController _password,
    TextEditingController _nombres, TextEditingController _apePat, TextEditingController _apeMat,
    String _fecNacimiento, String _genero, TextEditingController _dni, TextEditingController _nroMovil,
    String _fecCreacion, String _fecActualizacion, bool _estado, int _perfilesId) async {

    setState(() {
      isButonDisabled = true;
      tituloBoton = 'Procesando ...';
    });

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
      usRegistrarModel.dni = _dni.text == '' ? '88888888' : _dni.text;

      _urlFoto = await cp.verificarConexionInternetSubirImagen(context, foto); // SUBE LA FOTO
        if (_urlFoto == null || _urlFoto.isEmpty || _urlFoto == '') {
          showAlertDialog(context, 'Error', 'Se requiere agregar una foto.');
          usRegistrarModel.url_foto = '';
        } else if( _urlFoto == 'No hay Internet') {
          showAlertDialog(context, 'Error', 'No puede conectarse. Por favor, compruebe la conexión a Internet');
        } else {          
          usRegistrarModel.url_foto = _urlFoto;
          usRegistrarModel.nro_movil = _nroMovil.text == '' ? '999999999' : _nroMovil.text;
          usRegistrarModel.fec_creacion = _fecCreacion;
          usRegistrarModel.fec_actualizacion = _fecActualizacion;
          usRegistrarModel.estado = _estado;
          usRegistrarModel.perfiles_id = _perfilesId;
          var response;

          if (usRegistrarModel.email != '' && usRegistrarModel.password != '' && usRegistrarModel.nombres != '' &&
            usRegistrarModel.apepat != '' && usRegistrarModel.apemat != '' && usRegistrarModel.fec_nacimiento != '' &&
            usRegistrarModel.genero != '' && usRegistrarModel.url_foto != '') {             

            String datosJson = usuarioRmToJson(usRegistrarModel);
            var url = urlRegisterUser;
            response = await http.post(url, headers: {"Content-Type": "application/json"}, body: datosJson);
            var extractData = json.decode(response.body);
            String _data = extractData['message'];

            if (response.statusCode == 200) {
              limpiarCampos();
              showAlertDialogRedireccionable(
                  context, 'Éxito', _data + '\n' + controllerEmail.text, 'login');
            } else {
              setState(() {
                isButonDisabled = false;
                tituloBoton = 'REGISTRAR';
              });              
              showAlertDialog(context, 'Error', '[' + response.statusCode.toString() + ']¨' + _data);
            }
          }
          return response;
        }
    } catch (e) {
      logger.w('ERROR:\n' + e.toString());
    }
  }
}
