import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:miincode/qr_flutter.dart';
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
import 'package:miincode/src/widgets/esys_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'qr_image.dart';

//final String rutaImagenQRGenerado = 'assets/images/4.0x/logo_yakka.png';
String rt = '';
bool qrRegistrado = false;

var logger = Logger( printer: PrettyPrinter() );
var loggerNoStack = Logger( printer: PrettyPrinter(methodCount: 0));

class QRCodeCreator extends StatefulWidget {
  final String tipo;
  final TextEditingController mensaje;
  final File file;

  QRCodeCreator({Key key, @required this.tipo, @required this.mensaje, @required this.file})
      : super(key: key);

  @override
  _QRCodeCreator createState() => _QRCodeCreator(tipo: tipo, msj: mensaje, fotoImage: file);
}

class _QRCodeCreator extends State<QRCodeCreator> {
  final CallsAndMessagesService service = locator<CallsAndMessagesService>();

  //bool condicion1 = true;
  // Variables utilizados  para el GUARDADO de los datos a FIREBASE y Cloudinary ----------
  GlobalKey _renderObjectKey = GlobalKey();  
  final productoProvider = new ProductosProvider();
  ProductoModel producto = new ProductoModel();
  Codigos codigos = new Codigos();
  
  final codigoProvider = new CodigosProvider();

  bool _guardando = false;
  File foto;
  String rutaQrGenerado;
  // ---------------------------------------------------------------------------------------
  final String tipo;
  final TextEditingController msj;
  final File fotoImage;

  _QRCodeCreator({Key key2, @required this.tipo, @required this.msj, @required this.fotoImage});

  get mensaje => msj.text;
  get tip => tipo;

  @override
  Widget build(BuildContext context) {
    print('-------------------->PASE POR AQUI --------------------');
    final key3 = new GlobalKey();
    return Scaffold(
      key: key3,
      //color: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('QR CREADO'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Compartir',
            onPressed: () {
              
              if (codigos.ruta_url.toString().isEmpty || codigos.ruta_url.toString() == '') {
                showAlertDialog_1(context, 'Importante', 'Para poder compartir primero debe guardar la imagen.');
              } else {
                compartir2(context, rutaQrGenerado);
                //compartir(context, producto.fotoUrl.toString())
                //compartir(context, 'rutaImage');
              } 
              
            },
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
              //scrollDirection: Axis.vertical,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.all(5),
                      //alignment: Alignment.center,
                      //width: double.infinity,
                      // ===================================================      <------
                      child: RepaintBoundary(
                        key: _renderObjectKey,
                        child: QrImage(
                          embeddedImage: AssetImage('assets/icon/icon_miincode.png'),
                          //embeddedImageStyle: QrEmbeddedImageStyle(),
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(5),
                          
                          //errorCorrectionLevel: QrErrorCorrectLevel.H,
                          version: QrVersions.auto,
                          constrainErrorBounds: false,

                          //size: 250,
                          data: mensaje,
                          //embeddedImage: AssetImage('assets/images/logo_yakka.png'),
                        ),
                      ),
                      decoration: BoxDecoration(
                        
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.circular(5.0),
                      ),

                      // ===================================================      <------
                      ),
                ),
                Expanded(
                    flex: 7,
                    child: Container(
                      //color: Colors.black54,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 50),
                      //child: showMsjInFooter(msj: mensaje),
                      child: Container(
                        padding: EdgeInsets.all(0),
                          child: Form(
                              //key: formKey,
                              child: ListView(
                                children: <Widget>[
                                  _crearLabelMensaje(),
                                  _crearBoton(),
                                  insertarBoton(tip)
                                ],
                              ))),
                    )),
              ]),
        ),
      ),
    );
  }

// -------------------------------------------------------------------------------
  insertarBoton(String tipo) {
    switch (tipo) {
      case 'controlerQR_Texto':
      {
        return Container();
      }
      break;
      case 'controlerQR_Link':
      {
        return _crearBotonShowWebPage(mensaje.toString());
      }
      break;
      case 'controlerQR_Phone':
      {
        return _crearBotonCallPhone(mensaje.toString());
      }
      break;
      case 'controlerQR_SendSms':
      {
        return _crearBotonSendSms(mensaje.toString());
      }
      break;
      case 'controlerQR_SendEmail':
      {
        return _crearBotonSendEmail(mensaje.toString());
      }
      break;

    }
  }

  Widget _crearLabelMensaje() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 15),
      child: Center(
        child: Text(
          mensaje,
          style: TextStyle(
            fontSize: 15, 
          ),
        ),
      )
    );
  }

  Widget _crearBotonShowWebPage (String mensaje) {
    return AbsorbPointer(
      absorbing: false,
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.black,
        textColor: Colors.white,
        label: Text('Abrir página Web'),
        icon: Icon(Icons.link),
        onPressed: () => _submitShowWebPage(mensaje)
      ),
    );
  }

  Widget _crearBotonSendSms (String mensaje) {
    return AbsorbPointer(
      absorbing: false,
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.black,
        textColor: Colors.white,
        label: Text('Enviar mensaje SMS'),
        icon: Icon(Icons.sms),
        onPressed: () => _submitSendSms(mensaje)
      ),
    );
  }

  Widget _crearBotonSendEmail (String mensaje) {
    return AbsorbPointer(
      absorbing: false,
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.black,
        textColor: Colors.white,
        label: Text('Enviar Email'),
        icon: Icon(Icons.email),
        onPressed: () => _submitSendEmail(mensaje)
      ),
    );
  }

  Widget _crearBotonCallPhone(String number) {
    return AbsorbPointer(
      absorbing: false,
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.black,
        textColor: Colors.white,
        label: Text('Llamar a este número'),
        icon: Icon(Icons.phone_in_talk),
        onPressed: () => _submitCallPhone(number)
      ),
    );
  }

  Widget _crearBoton() {
    return AbsorbPointer(
      absorbing: false,
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.deepPurple,
        textColor: Colors.white,
        label: Text('GUARDAR'),
        icon: Icon(Icons.save),
        onPressed: (_guardando) ? null : _submit
      ),
    );
  }



  void _submitShowWebPage(String web) async {
    String url = web;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showAlertDialog_1(context, 'Error', 'NO se pudo abrir la pagina web indicada.');
      print(throw 'No se pudo iniciar URL');
    }

    /* FUENTE: https://medium.com/@muaazmusthafa08/how-to-load-a-web-page-in-flutter-app-607fa9184e4a */
  }

  void _submitCallPhone(String number) {
    service.call(number);
  }

  void _submitSendSms(String mensaje) {
    service.sendSms(mensaje);
  }

  void _submitSendEmail(String mensaje) {
    service.sendEmail(mensaje);
  }

  void _submit() async {
      setState(() {
        _guardando = true;
        //condicion1 = false;
      });
    try {
      // Guardar IMAGEN en CLOUDINARY =================================================== INI
      RenderRepaintBoundary boundary =
          _renderObjectKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);

      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      print('-------------------->bytedata: ' + byteData.toString());
      Uint8List pngBytes = byteData.buffer.asUint8List();

      rt = pngBytes.toString(); // <-------------------

      String dir = (await getApplicationDocumentsDirectory()).path;
      rutaQrGenerado = dir;
      print('-------------------->'+"-------------------->Ruta Local :" + dir);
      File file = File("$dir/QRCodeGenerado.png");
      print('-------------------->'+"-------------------->Ruta Local :" + file.toString());
      await file.writeAsBytes(pngBytes);
      print('-------------------->'+"-------------------->RRUUTTAA" + file.toString());

      // Valida si hay o no imagen ----
      if (file != null) {
      codigos.ruta_url = await productoProvider.subirImagen(file);
      } else {  }
      //================================================================================= FIN

      // LLENANDO DATOS --------------------------
      codigos.mensaje = mensaje;
      codigos.fec_creacion = DateTime.now().toString();
      codigos.fec_actualizacion = "";
      codigos.estado = true;

      SharedPreferences sp = await SharedPreferences.getInstance();
      final _email = await sp.getString(spEmail);
      
        producto.idUsuario = sp.getInt('spId');
        
        print('=====================================.......' + sp.getInt('spId').toString());

      DatabaseHelper.db.getUsuarioPorEmail(_email).then((value){
        //print('---------------------> idUsuario IN producto ' + value.id);

        // -----------------------------------------
        logger.i('---------------> codigos.id ' + codigos.id.toString());
        if (codigos.id == null) {
          try {
            //codigoProvider.crearCodigo(codigos);  <---- GUARDABA EN Firebase
            
            codigos.usuarios_id = producto.idUsuario; //  <------------------------ PERSONALIZAR
            String datosJson = codigosToJson(codigos);
            codigoProvider.creaCodigos(context, datosJson);
            qrRegistrado = true;
          } catch (e) {
            print('-------------------->'+e);
            qrRegistrado = false;
          }
        }
        setState(() {
          _guardando = false;
        });
      });
      
    } catch (e) {
      logger.w(e.toString());
    }
  }
// -------------------------------------------------------------------------------
}

void compartir2(BuildContext context, String ruta) async {
  //ruta = ruta+'QR.png'; //'assets/images/4.0x/logo_yakka.png';
  //print('==========='+ruta+'===========');
  final ByteData bytes = await rootBundle.load('/data/user/0/com.acanta.miincode/app_flutter/QRCodeGenerado.png');

  await Share.file('esys image', 'esys.png', bytes.buffer.asUint8List(), 'image/png');
}

void compartir(BuildContext context, String rutaImage) async {
  Uint8List _bytesImages;

  final ByteData bytes = await rootBundle.load(rt);
  print('-------------------->RT------------------');
  print('-------------------->rt:'+rt);
  print('-------------------->bytes:'+bytes.toString());
  print('-------------------->RT------------------');
  _bytesImages = bytes.buffer.asUint8List();

  if (rutaImage.isEmpty) {
    showAlertDialog_1(context, 'Importante', 'NO ha indicado una imagen.');
  } else {
    try {
      Share.text('IMPORTANTE', 'Compartido contigo... ', 'HOLA');
      //print('-------------------->Compartiendo en redes sociales --------------------------------');
      //print('-------------------->'+rutaImage);
      print('-------------------->IMAGEN COMPARTIDA---> ');
      //await Share.file('Compartir Ubicacion.', 'escaneado.png', _bytesImages, 'image/png', text: 'Hola aqui compartimos la imagen escaneada.');
    } catch (e) {
      print('-------------------->Compartiendo en redes sociales --------------------------------');
      print('-------------------->'+e);
    }
  }
}

/* MUESTRA Mensaje en el footer de la APP. */
class showMsjInFooter extends StatelessWidget {
  final String msj;

  showMsjInFooter({Key key, @required this.msj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlineButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: msj));
          final snackBar = SnackBar(
            content:
                Text('Mensaje [ ' + msj + ' ] copiado en el portapapeles.'),
            action: SnackBarAction(
              label: 'Ocultar',
              onPressed: () {},
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: Text('Copiar al portapapeles'),
      ),
    );
  }
}
