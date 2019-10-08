import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/usuario_model.dart';
import 'package:miincode/src/providers/database_helper.dart';
import 'package:miincode/src/providers/usuarios_provider.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:miincode/src/utils/utils_conectividad.dart';
import 'package:miincode/src/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() => runApp(Ajustes());

String controllerId;
String controllerUid;
TextEditingController controllerEmail = TextEditingController();
TextEditingController controllerNombres = TextEditingController();
TextEditingController controllerApePat = TextEditingController();
TextEditingController controllerApeMat = TextEditingController();
TextEditingController controllerNroMovil = TextEditingController();
TextEditingController controllerDisponible = TextEditingController();
TextEditingController controllerFecNac = TextEditingController();
TextEditingController controllerGenero = TextEditingController();
TextEditingController controllerDni = TextEditingController();

String _fecnac;
String _genero;
String __nroMovil;

DateTime fecNacimiento;
UsuariosProvider up = new UsuariosProvider();

String correo = 'vacpcanta@gmail.com';
String _email = '';
String _idUsuario = '';
int _conteoItems = 0;

class Ajustes extends StatefulWidget {
  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {

  @override
  initState()  {
    super.initState();
    _loadDatos();

    selectedRadio = 0;
  }

  _loadDatos() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
     _email = sp.getString('spEmail');
     _idUsuario = (sp.getString('spIdUsuario'));
     _conteoItems = _conteoItems;
     controllerEmail.text = _email;
    });
  }

  bool estadoInputs = false;
  bool condicion1 = true;
  int selectedRadio = 0;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final up = new UsuariosProvider();
  UsuarioModel newUm = new UsuarioModel();
  UsuarioModel um = new UsuarioModel();
  
  bool _guardando = false;
  File foto;
  File image;
  String dtFecNac;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //_email.dispose();
    //_nombres.dispose();
    //_apepat.dispose();
    //_apemat.dispose();
    //_nromovil.dispose();
    //_dni.dispose();

    super.dispose();
  }

  /* PROCESAMIENTO DE LAS IMAGENES  ---------------------------------*/
  picker() async {
    print('-------------------->Picker is called');
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    _procesarImagen(image);
    print('-------------------->IMAGEN CAPTURADA ------------------------------');
    print('-------------------->RUTA: '+img.path);
    setState(() {});
  }  
  _procesarImagen(File img) async {
    foto = image;
    if ( foto != null ) {
      um.fotoUrl = null;
    }
    setState(() {});
  }
  /* PROCESAMIENTO DE LAS IMAGENES  ---------------------------------*/
//  @override
//  void initState() {
//
//  }

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
        padding: EdgeInsets.all(5),
        color: Colors.black45,
        child: _muestraDatosUsuarioRegistrado(_email)
      )
    );
  }
  _up() { 
    String vr;
    spReturnEmail().then((value){
      print('111111111' + value);
      vr = value;
      print('222222222' + vr);
    });

    _muestraDatosUsuarioRegistrado(vr);
    print(vr);
    print('333333333' + vr.toString());

  }

  showDatosUsuarioPorEmail(String email) {
    return FutureBuilder<UsuarioModel>(
      future: DatabaseHelper.db.getUsuarioPorEmail(email),
      builder: (BuildContext context, AsyncSnapshot<UsuarioModel> snapshot ) {
        //if ( !snapshot.hasData ) { return Center(child: Text('NO SE ENCONTRARON DATOS')); }
        
        UsuarioModel usuarios = snapshot.data;


        return Center(
          child: Column(
            children: <Widget>[
              Text(usuarios.email),
              Text(usuarios.nombres),
              Text(usuarios.apepat),
              Text(usuarios.apemat),
              Text(usuarios.nromovil),
              Text(usuarios.disponible),
              Text(usuarios.fecnac),
              Text(usuarios.genero),
              Text(usuarios.dni)
            ],
          ),
        );
      },
    );
  }

  Widget _muestraDatosUsuarioRegistrado_Email(String email) {
    return FutureBuilder<List<UsuarioModel>>(
      future: DatabaseHelper.db.getTodosPorEmail(email),
      builder: (BuildContext context, AsyncSnapshot<List<UsuarioModel>> snapshot ) {

        if ( !snapshot.hasData ) { return Center(child: CircularProgressIndicator());}
        final usuarios = snapshot.data;
        
        return ListView.builder(
          itemCount: usuarios.length,
          itemBuilder: (BuildContext context, int i) => Container(
            child: Column(
              children: <Widget>[
                Text(usuarios[i].id == null ? '' : usuarios[i].id),
                Text(usuarios[i].uid == null ? '' : usuarios[i].uid),
                Text(usuarios[i].email == null ? '' : usuarios[i].email),
                Text(usuarios[i].nombres == null ? '' : usuarios[i].nombres),
                Text(usuarios[i].apepat == null ? '' : usuarios[i].apepat),
                Text(usuarios[i].apemat == null ? '' : usuarios[i].apemat),
                Text(usuarios[i].nromovil == null ? '' : usuarios[i].nromovil),
                Text(usuarios[i].fecnac == null ? '' : usuarios[i].fecnac),
                Text(usuarios[i].fotoUrl == null ? '' : usuarios[i].fotoUrl),
                Text(usuarios[i].genero == null ? '' : usuarios[i].genero),
                Text(usuarios[i].dni == null ? '' : usuarios[i].dni)
              ],
            ),
          ),
        );
      } 
    );
  }

  Widget _muestraDatosUsuarioRegistrado(String correo) {
    
    if (correo == null  || correo.isEmpty) {
      showAlertDialog_1(context, '!!!!', 'El valor de la Variable necesaria es [ ' + correo.toString() + ' ]');  
    }
    

    return FutureBuilder<List<UsuarioModel>>(
      future: DatabaseHelper.db.getTodosUsuarios(),
      builder: (BuildContext context, AsyncSnapshot<List<UsuarioModel>> snapshot ){

        if ( !snapshot.hasData ) { return Center(child: CircularProgressIndicator()); }

        final usuarios = snapshot.data;
        if ( usuarios.length == 0) {
          return Center(
            child: Text('No se ha podido descargar la información.'),
          );
        }

        return Card(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 30),
            itemCount: usuarios.length,
            itemBuilder: (BuildContext context, int i ) => usuarios[i].email == correo 
              ?  
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
                  // IMAGEN Y BOTON PARA AGREGAR IMAGEN...
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Center( 
                      //child: image == null ? Text('Seleccione una imagen', style: TextStyle(color: Colors.purple),) : Image.file(image)
                      child: Container(
                        child: image != null //usuarios[i].fotoUrl != null || usuarios[i].fotoUrl.isEmpty
                        ? 
                        ClipOval(
                          child: Align(
                            heightFactor: 1,
                            widthFactor: 0.7,
                            child: Image.network(
                            usuarios[i].fotoUrl
                            )
                          ),
                        )                        
                        : 
                        Column(
                          children: <Widget>[
                            ClipOval(
                              child: Align(
                                heightFactor: 1,
                                widthFactor: 0.7,
                                child: Image.asset(
                                  'assets/no-image.png', width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ]
                        ),
                      )
                    ),
                  ),
                  // EMAIL
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 40,
                        child: TextField(
                          enabled: estadoInputs,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          controller: controllerEmail, //TextEditingController(text: usuarios[i].email),//..text = usuarios[i].email,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(),
                            border: OutlineInputBorder(),
                            labelText: 'Email'
                          ),
                        ),
                      ),
                    ),
                  ),
                  // NOMBRES
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 40,
                        child: TextField(
                          enabled: estadoInputs,
                          textAlign: TextAlign.center,
                          controller: TextEditingController()..text = usuarios[i].nombres,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nombres'
                          ),
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
                            height: 40,
                            child: TextField(
                              enabled: estadoInputs,
                              textAlign: TextAlign.center,
                              controller: controllerApePat..text = usuarios[i].apepat, //TextEditingController()..text = usuarios[i].apepat,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Apellido Paterno'
                              ),
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
                              controller: controllerApeMat..text = usuarios[i].apemat,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Apellido Materno'
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Expanded(
                        child:  Column(
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
                                controller: controllerDni..text = usuarios[i].dni,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'DNI'
                                ),
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
                                        border: Border.all(color: Colors.black12, style: BorderStyle.solid, width: 1)
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Text('Fecha de Nacimiento', style: TextStyle(fontSize: 12, color: Colors.black38), textAlign: TextAlign.right),
                                      RaisedButton.icon(
                                      //textTheme: ButtonTextTheme.normal,
                                      color: Colors.white,
                                      label: Text( 
                                        usuarios[i].fecnac != null && dtFecNac == null 
                                          ? 
                                        usuarios[i].fecnac
                                          :
                                        dtFecNac == null ? 'Elige Fecha' : '${dtFecNac}',
                                          style: TextStyle(color: Colors.black),
                                      ),
                                      icon: Icon(Icons.date_range),
                                      onPressed: () {
                                        estadoInputs == true 
                                          ?
                                        DatePicker.showDatePicker(
                                          context,
                                          theme: DatePickerTheme(
                                              backgroundColor: Colors.black,
                                              cancelStyle: TextStyle(color: Colors.red),
                                              itemStyle: TextStyle(color: Colors.white),
                                              containerHeight: 220,
                                              doneStyle: TextStyle(color: Colors.green)
                                            ),
                                          showTitleActions: true,
                                          minTime: DateTime(1980, 1, 1),
                                          maxTime: DateTime(2030, 12, 31), 
                                          onChanged: (date) {
                                            print('change $date');
                                          }, 
                                          onConfirm: (date) {
                                            fecNacimiento = date;
                                            if (fecNacimiento != null || fecNacimiento != '') {
                                              final f = new DateFormat('dd-MM-yyyy').format( fecNacimiento);
                                              setState(() {
                                                dtFecNac = f.toString();  
                                                _fecnac = dtFecNac;
                                              });                                    
                                            }
                                          }, 
                                          currentTime: DateTime.now(), locale: LocaleType.es,
                                        )
                                          :
                                        Container();
                                      },
                                    ),
                                    ]
                                  )
                                ),

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
                              border: Border.all(color: Colors.black12, style: BorderStyle.solid, width: 1)
                            ),
                            child: Column(
                              children: <Widget>[
                                Text('Género', style: TextStyle(fontSize: 12, color: Colors.black38)),
                                ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    //Masculino
                                    Column(
                                      children: <Widget>[
                                        Radio(
                                          value: usuarios[i].genero == 'M' ? 1 : 0,
                                          groupValue: selectedRadio,
                                          activeColor: Colors.black,
                                          onChanged: (val){
                                            print('Radio $val');
                                            setSelectedRadio(val);
                                          }
                                        ),
                                        Text('Masculino', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                    //Femenino
                                    Column(
                                      children: <Widget>[
                                        Radio(
                                          value: usuarios[i].genero == 'F' ? 0 : 1,
                                          groupValue: selectedRadio,
                                          activeColor: Colors.black,
                                          onChanged: (val){
                                            print('Radio $val');
                                            setSelectedRadio(val);
                                          }
                                        ),
                                        Text('Femenino', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
                                      ],
                                    ),
                                  ],
                                )
                              
                              ],
                            ),
                          )
                        ),
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
                            controller: controllerNroMovil..text = usuarios[i].nromovil,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Número Móvil'
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  estadoInputs == true ?
                  
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child:RaisedButton.icon(
                      icon: Icon(Icons.update,color: Colors.white),
                      label: Text('ACTUALIZAR', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                      color: Colors.black,
                      onPressed: () {
                        DatabaseHelper.db.pintaDatosRegistradosDeUsuario(usuarios[i].email);
                        //up.editarUsuario(newUm);

                        setState(() {
                          estadoInputs == true ? estadoInputs = false : estadoInputs = true;  
                        });
                        
                      }
                    )
                  )
                  :
                  Container(),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: estadoInputs != true ?
                    Container(
                      height: 50,
                      color: Colors.black,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Center(
                        child: SwitchListTile(
                          value: estadoInputs,//usuarios[i].disponible == 'true' ? condicion1=true : condicion1=false,
                          title: estadoInputs == true ? Text('Modificar') : Text('MODIFICAR DATOS', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                          dense: false,
                          activeColor: Colors.red,
                          inactiveThumbColor: Colors.white,
                          onChanged: (value)=> setState((){
                              estadoInputs = value;
                            }
                          ),
                          secondary: estadoInputs == true ? Icon(Icons.edit, color: Colors.red) : Icon(Icons.edit, color: Colors.white, size: 25,)
                        ),
                      ),
                    )
                    :
                    Container(),
                  )
                ],
              ),
            )
              
              :
            Container()
            

          ),
        
        );
      },
    );

  }

  void _submit() async {
    try {
      if ( !formKey.currentState.validate() ) return;
      formKey.currentState.save();
      setState(() {_guardando = true; });

      if ( foto != null ) {
        um.fotoUrl = await up.subirImagen(foto);
        print('-------------------->Foto del Usuario subida con éxito en el servidor.');
      }

      if ( um.id == null ) {
        showAlertDialog_1(context, 'Importante', 'No ha registrado el nro de ID correspondiente.');
      } else {
        up.editarUsuario(um);
        showAlertDialog_1(context, 'ÉXITO', 'DATOS ACTUALIZADOS.');
      }
      setState(() {_guardando = false; });

    } catch (e) {
      showAlertDialog_1(context, 'Importante', e.toString());
    }
    //Navigator.pop(context);
  }

}
