import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/codigo_model.dart';
import 'package:miincode/src/models/codigos.dart';
import 'package:miincode/src/models/producto_model.dart';
import 'package:miincode/src/providers/codigos_provider.dart';
import 'package:miincode/src/providers/database_helper.dart';
import 'package:miincode/src/providers/productos_provider.dart';
import 'package:miincode/src/services/calls_and_messages_service.dart';
import 'package:miincode/src/services/service_locator.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:miincode/src/utils/utils_conectividad.dart';
import 'package:miincode/src/widgets/appbar.dart';
import 'package:miincode/src/widgets/for_create_qr.dart';
import 'package:path_provider/path_provider.dart';

CodigosProvider cp = new CodigosProvider();
CodigoModel cm = new CodigoModel();

var logger = Logger( printer: PrettyPrinter() );
var loggerNoStack = Logger( printer: PrettyPrinter(methodCount: 0) );

TextEditingController controlerQR_Texto = new TextEditingController();
TextEditingController controlerQR_Link = new TextEditingController();
TextEditingController controlerQR_Phone = new TextEditingController();
TextEditingController controlerQR_SendSms = new TextEditingController();
TextEditingController controlerQR_SendEmail = new TextEditingController();

class QRCreate extends StatefulWidget {
  @override
  _QRCreateState createState() => _QRCreateState();
}

class _QRCreateState extends State<QRCreate> {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  final String number = "924294123";
  final String email = "vacpcanta@gmail.com";

  bool condicion1 = false;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductosProvider();
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File foto;
  File image;
  picker() async {
    logger.i('-------------------->Picker is called');
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
    foto = image; /* <---- GUARDA imagen en VARIABLE FLOBAL */
    _procesarImagen(image);
    logger.i('-------------------->Imagen CAPTURADA de la GALERIA <------------------------------');
    logger.i('-------------------->RUTA: ' + img.path);
    setState(() {});
  }

  final TextStyle estiloTexto = TextStyle(fontSize: 25);

  final Color colorRed = Colors.red;
  final Color colorBlue = Colors.blue;
  final Color colorPurple = Colors.purple;
  final Color colorGreen = Colors.green;
  final Icon iconText = Icon(Icons.library_books, color: Colors.blue, size: 35);
  final Icon iconLink = Icon(Icons.link, color: Colors.red, size: 35);
  final Icon iconImg = Icon(Icons.image, color: Colors.purple, size: 35);
  final Icon icon3D =
      Icon(Icons.perm_device_information, color: Colors.green, size: 35);
  final TextEditingController _texto = TextEditingController();

  @override
  Widget build(BuildContext context) {
    spReturnEmail().then((value){
      DatabaseHelper.db.pintaDatosRegistradosDeUsuario(value);
    });    
    
    return Scaffold(
        appBar:  myAppBar(context, 'CREAR CÓDIGO QR'),
        body: Container(
          color: Colors.black,
          child: ListView(
            padding: EdgeInsets.all(5),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              cardQrTexto(context, controlerQR_Texto, foto),
              cardQrLink(context, controlerQR_Link, foto),
              cardQrPhone(context, controlerQR_Phone, foto),
              cardQrSendSms(context, controlerQR_SendSms, foto),
              cardQrSendEmail(context, controlerQR_SendEmail, foto),
              //_test1()
            ],
          ),
        ));
    
  }

  Widget _crearBotonTEST() {
    return AbsorbPointer(
      absorbing: false,
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.deepPurple,
        textColor: Colors.white,
        label: Text('TEST 1'),
        icon: Icon(Icons.save),
        onPressed: (){
          cp.fetchPost();//_test1();
        },
      )
    );
  }
  
  Widget _test1() {

    try {  
      logger.i('ESTOY DENTRO DEL TEST -----------------');
      return FutureBuilder(
        future: cp.listarCodigos(),
        builder: (BuildContext context, AsyncSnapshot<List<CodigoModel>> snapshot) {
          //final data = snapshot.data;
          if ( snapshot.hasData ) {
            final codigos = snapshot.data;
            print('/**********************************************************/');
            logger.i(snapshot);
            return ListView.builder(
              itemCount: codigos.length,
              itemBuilder: (context, i) {
                return Text(codigos[i].mensaje);
              },
            );
          } else {
            logger.w('snapshot NO TIENE DATA');
          }
        });
    } catch (e) {
      logger.w(e.toString());
    }

  }

  Widget _containerQRGenerado(TextEditingController msj, File file) {
    return Container(
      //width: double.infinity,
      child: Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              child: Text('Data')//QRCodeCreator(mensaje: msj, file: file),
            ),
          ),
        ),
      )

    );
  }

  Widget _switch_Show_Hide() {
      return SwitchListTile(
        value: condicion1,
        title: condicion1 ? Text('OCULTAR', style: TextStyle(color: Colors.red)) : Text('MOSTRAR', style: TextStyle(color: Colors.green)),
        dense: true,
        activeColor: Colors.red,
        inactiveThumbColor: Colors.green,
        onChanged: (value)=> setState((){
          condicion1 = value;
        }),
      );
    }

  void dispose() {
    _texto.dispose();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    logger.i('-------------------->'+"-------------------->Ruta Local :" + directory.path);
    return directory.path;
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productoProvider.subirImagen(foto);
    }

      if (producto.id == null) {
        productoProvider.crearProducto(producto);
        logger.i('-------------------->PRODUCTO --> CREAR');
      } else {
        productoProvider.editarProducto(producto);
        logger.i('-------------------->PRODUCTO --> EDITAR');
      }
    setState(() {
      _guardando = false;
    });

    logger.i('-------------------->VALORES: ');
    logger.i('-------------------->TITULO: ' + producto.titulo);
    logger.i('-------------------->VALOR: ' + producto.valor.toString());
    logger.i('-------------------->DISPONIBLE: ' + producto.disponible.toString());
    logger.i('-------------------->URL: ' + producto.fotoUrl);

    showAlertDialog_1(context, 'Guardado', 'EXITOSO....');
    //mostrarSnackbar('Registro guardado');
    Navigator.pop(context);
  }

  /* ***************************************************************************************  */
  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _procesarImagen(File img) async {
    foto = image;
    if (foto != null) {
      producto.fotoUrl = null;
    }
    setState(() {});
  }

}
