import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/usuarios.dart';
import 'package:miincode/src/providers/ws.dart';
import 'package:miincode/src/utils/utils_conectividad.dart';
import 'package:miincode/src/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

String url = urlUsuarioXId;

final String datoNull = 'Dato NO indicado';
String dtFecNac;
DateTime fecNacimiento;

final textoParrafo = new TextStyle(color: Colors.blueAccent, fontSize: 12);
bool estadoInputs = true;
int selectedRadio = 0;

var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));

String controllerId;
TextEditingController controllerEmail = TextEditingController();
TextEditingController controllerNombres = TextEditingController();
TextEditingController controllerApePat = TextEditingController();
TextEditingController controllerApeMat = TextEditingController();
TextEditingController controllerFecNac = TextEditingController();
TextEditingController controllerGenero = TextEditingController();
TextEditingController controllerDni = TextEditingController();
TextEditingController controllerUrlFoto = TextEditingController();
TextEditingController controllerNroMovil = TextEditingController();
String _fecnac;
String _genero;
String __nroMovil;

Future<Usuarios> fetchPost() async {
  spPintarDatosUsuarioLogueado();
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.getInt(spId);
  try {
    print('----------------> sp.getInt(spId) ' + sp.getInt(spId).toString());
    final response = await http.get(url + sp.getInt(spId).toString());
    print('----------------> response ' + response.toString());

    if (response.statusCode == 200) {
      return Usuarios.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  } catch (e) {
    logger.w(e.toString());
  }
}

void main() => runApp(MyAppFetchPost(usuarios: fetchPost()));

class MyAppFetchPost extends StatefulWidget {
  final Future<Usuarios> usuarios;

  MyAppFetchPost({Key key, this.usuarios}) : super(key: key);

  @override
  _MyAppFetchPostState createState() => _MyAppFetchPostState();
}

class _MyAppFetchPostState extends State<MyAppFetchPost> {
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, 'AJUSTES'),
      body: Container(
          //padding: EdgeInsets.all(0),
          color: Colors.black,
          child: FutureBuilder<Usuarios>(
            future: fetchPost(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                return Card(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            // TITULO
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                              child: Text(
                                'DATOS DEL USUARIO',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // EMAIL
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              height: 40,
                              child: TextField(
                                enabled: estadoInputs,
                                textAlign: TextAlign.center,
                                textAlignVertical: TextAlignVertical.center,
                                controller: controllerEmail
                                  ..text = data.email != null
                                      ? data.email
                                      : '', //TextEditingController(text: usuarios[i].email),//..text = usuarios[i].email,
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(),
                                    border: OutlineInputBorder(),
                                    labelText: 'Email'),
                              ),
                            ),
                            // NOMBRES
                            Container(
                              padding: EdgeInsets.all(5.0),
                              height: 35,
                              child: TextField(
                                enabled: estadoInputs,
                                textAlign: TextAlign.center,
                                controller: controllerNombres
                                  ..text =
                                      data.nombres != '' ? data.nombres : '',
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nombres'),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                //APELLIDO PATERNO
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      height: 40,
                                      child: TextField(
                                        enabled: estadoInputs,
                                        textAlign: TextAlign.center,
                                        controller: controllerApePat
                                          ..text = data.apepat != ''
                                              ? data.apepat
                                              : '',
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
                                      height: 40,
                                      child: TextField(
                                        enabled: estadoInputs,
                                        textAlign: TextAlign.center,
                                        controller: controllerApeMat
                                          ..text = data.apemat != ''
                                              ? data.apemat
                                              : '',
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
                                          height: 32,
                                          child: TextField(
                                            scrollPadding: EdgeInsets.all(5),
                                            enabled: estadoInputs,
                                            textAlign: TextAlign.center,
                                            controller: controllerDni
                                              ..text = data.dni != ''
                                                  ? data.dni
                                                  : '',
                                            decoration: InputDecoration(
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
                                                      BorderRadius.circular(
                                                          6.0),
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
                                                    data.fec_nacimiento != '' &&
                                                            data.fec_nacimiento ==
                                                                null
                                                        ? data.fec_nacimiento
                                                        : dtFecNac == null
                                                            ? 'Elige Fecha'
                                                            : '${dtFecNac}',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  icon: Icon(Icons.date_range),
                                                  onPressed: () {
                                                    estadoInputs == true
                                                        ? DatePicker
                                                            .showDatePicker(
                                                            context,
                                                            theme: DatePickerTheme(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                cancelStyle: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                                itemStyle: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                containerHeight:
                                                                    220,
                                                                doneStyle: TextStyle(
                                                                    color: Colors
                                                                        .green)),
                                                            showTitleActions:
                                                                true,
                                                            minTime: DateTime(
                                                                1980, 1, 1),
                                                            maxTime: DateTime(
                                                                2030, 12, 31),
                                                            onConfirm: (date) {
                                                              fecNacimiento =
                                                                  date;
                                                              if (fecNacimiento !=
                                                                      null ||
                                                                  fecNacimiento !=
                                                                      '') {
                                                                final f = new DateFormat(
                                                                        'dd-MM-yyyy')
                                                                    .format(
                                                                        fecNacimiento);
                                                                setState(() {
                                                                  dtFecNac = f
                                                                      .toString();
                                                                  _fecnac =
                                                                      dtFecNac;
                                                                });
                                                              }
                                                            },
                                                            currentTime:
                                                                DateTime.now(),
                                                            locale:
                                                                LocaleType.es,
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
                                            borderRadius:
                                                BorderRadius.circular(6.0),
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
                                              alignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                //Masculino
                                                Column(
                                                  children: <Widget>[
                                                    Radio(
                                                        value:
                                                            data.genero == 'M'
                                                                ? 1
                                                                : 0,
                                                        groupValue:
                                                            selectedRadio,
                                                        activeColor:
                                                            Colors.black,
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
                                                        value:
                                                            data.genero == 'F'
                                                                ? 0
                                                                : 1,
                                                        groupValue:
                                                            selectedRadio,
                                                        activeColor:
                                                            Colors.black,
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
                                    child: TextField(
                                      enabled: estadoInputs,
                                      textAlign: TextAlign.center,
                                      controller: controllerNroMovil
                                        ..text = data.nro_movil,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Número Móvil'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            estadoInputs == true
                                ? Container(
                                    height: 50,
                                    width: double.infinity,
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: RaisedButton.icon(
                                        icon: Icon(Icons.update,
                                            color: Colors.white),
                                        label: Text('ACTUALIZAR',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold)),
                                        color: Colors.black,
                                        onPressed: () {
                                          //DatabaseHelper.db.pintaDatosRegistradosDeUsuario(usuarios[i].email);
                                          //up.editarUsuario(newUm);

                                          setState(() {
                                            estadoInputs == true
                                                ? estadoInputs = false
                                                : estadoInputs = true;
                                          });
                                        }))
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: estadoInputs != true
                                  ? Container(
                                      height: 50,
                                      color: Colors.black,
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Center(
                                        child: SwitchListTile(
                                            value:
                                                estadoInputs, //usuarios[i].disponible == 'true' ? condicion1=true : condicion1=false,
                                            title: estadoInputs == true
                                                ? Text('Modificar')
                                                : Text(
                                                    'MODIFICAR DATOS',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                  ),
                                            dense: false,
                                            activeColor: Colors.red,
                                            inactiveThumbColor: Colors.white,
                                            onChanged: (value) => setState(() {
                                                  estadoInputs = value;
                                                }),
                                            secondary: estadoInputs == true
                                                ? Icon(Icons.edit,
                                                    color: Colors.red)
                                                : Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                    size: 25,
                                                  )),
                                      ),
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}",
                    style: TextStyle(color: Colors.black, fontSize: 25));
              }
              return CircularProgressIndicator();
            },
          )),
    );
  }
}

Widget datos(BuildContext context) {
  logger.i('----ddd---------: ');
  try {
    logger.i('----ggg---------: ' + context.toString());
    FutureBuilder<Usuarios>(
      future: fetchPost(),
      builder: (context, snapshot) {
        logger.i('snapshot has data: ' + snapshot.hasData.toString());
        if (snapshot.hasData) {
          return Text(snapshot.data.nombres,
              style: TextStyle(color: Colors.black, fontSize: 25));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}",
              style: TextStyle(color: Colors.black, fontSize: 25));
        }
        // Por defecto, muestra un loading spinner
        return CircularProgressIndicator();
      },
    );
  } catch (e) {
    logger.w(e.toString());
  }
}
