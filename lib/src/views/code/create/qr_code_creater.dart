import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Image, ImageByteFormat;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:miincode/qr_flutter.dart';
import 'package:miincode/src/models/codigos.dart';
import 'package:miincode/src/providers/codigos_provider.dart';
import 'package:miincode/src/services/calls_and_messages_service.dart';
import 'package:miincode/src/services/service_locator.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:miincode/src/utils/utils_conectividad.dart';

import 'package:miincode/src/widgets/esys_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'qr_image.dart';

var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));

String rutaImgQRCode   = '';
String nombreImgQRCode = 'QRCodeGenerado.png';

class QRCodeCreator extends StatefulWidget {

  final String tipo;
  final TextEditingController mensaje;
  final File file;

QRCodeCreator(
      {Key key,
      @required this.tipo,
      @required this.mensaje,
      @required this.file})
      : super(key: key);

  @override
  _QRCodeCreator createState() =>
      _QRCodeCreator(tipo: tipo, msj: mensaje, fotoImage: file);
}

class _QRCodeCreator extends State<QRCodeCreator> {
  bool isButonDisabled = false;
  String tituloBotonCrearCodigo = 'GUARDAR';
  bool saving = false;

  setStateLoader(bool val) {
    setState(() {
      saving = val;
    });
  }


  final CallsAndMessagesService service = locator<CallsAndMessagesService>();

  GlobalKey _renderObjectKey = GlobalKey();
  Codigos codigos = new Codigos();
  final codigoProvider = new CodigosProvider();

  File foto;

  // ---------------------------------------------------------------------------------------
  final String tipo;
  final TextEditingController msj;
  final File fotoImage;

  _QRCodeCreator(
      {Key key2,
      @required this.tipo,
      @required this.msj,
      @required this.fotoImage});

  get mensaje => msj.text;
  get tip => tipo;

  @override
  Widget build(BuildContext context) {
    validacionEstado(){
    if ( mensaje == '' || mensaje == null) {
      print('NO ha indicado un Mensaje...');
      setState(() {
        isButonDisabled = true;
      });
    } else {
      setState(() {
        isButonDisabled = false;
      });
    }
  }

    final key3 = new GlobalKey();
    return Scaffold(
      key: key3,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('QR CREADO'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Compartir',
            onPressed: () {
              if (rutaImgQRCode.isEmpty || rutaImgQRCode == '') {
                showAlertDialog(context, 'Error','Se requiere guardar el codigo para compartir.');
              } else {
                sharingQRCode();
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
          child: Column(children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(5),
                child: RepaintBoundary(
                  key: _renderObjectKey,
                  child: QrImage(
                    embeddedImage: AssetImage('assets/icon/icon_miincode.png'),
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(5),
                    version: QrVersions.auto,
                    constrainErrorBounds: false,                    
                    data: mensaje,
                    //size: 100,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5.0),
                ),
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
        ));
  }

  Widget _crearBotonShowWebPage(String mensaje) {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.black,
        textColor: Colors.white,
        label: Text('Abrir página Web'),
        icon: Icon(Icons.link),
        onPressed: () => _submitShowWebPage(mensaje));
  }

  Widget _crearBotonSendSms(String mensaje) {
    return AbsorbPointer(
      absorbing: false,
      child: RaisedButton.icon(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.black,
          textColor: Colors.white,
          label: Text('Enviar mensaje SMS'),
          icon: Icon(Icons.sms),
          onPressed: () => _submitSendSms(mensaje)),
    );
  }

  Widget _crearBotonSendEmail(String mensaje) {
    return AbsorbPointer(
      absorbing: false,
      child: RaisedButton.icon(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.black,
          textColor: Colors.white,
          label: Text('Enviar Email'),
          icon: Icon(Icons.email),
          onPressed: () => _submitSendEmail(mensaje)),
    );
  }

  Widget _crearBotonCallPhone(String number) {
    return AbsorbPointer(
      absorbing: false,
      child: RaisedButton.icon(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: Colors.black,
          textColor: Colors.white,
          label: Text('Llamar a este número'),
          icon: Icon(Icons.phone_in_talk),
          onPressed: () => _submitCallPhone(number)),
    );
  }

  Widget _crearBoton() {
    return AbsorbPointer(
      absorbing: isButonDisabled,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.redAccent,
        textColor: Colors.white,
        onPressed: isButonDisabled ? null : ()  {
          _submit();
          setState(() {
            isButonDisabled = true;
            tituloBotonCrearCodigo = 'Procesando ...';
          });
        },
        child: Text(tituloBotonCrearCodigo),
        disabledColor: Colors.grey,
        disabledTextColor: Colors.white,
      ),
    );
  }

  void _submitShowWebPage(String web) async {
    if (await canLaunch(web)) {
      await launch(web);
    } else {
      showAlertDialog(context, 'Error', 'No se pudo abrir la pagina web registrada.');
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

    try {
      /* INI Guardar IMAGEN en CLOUDINARY */
        RenderRepaintBoundary boundary = _renderObjectKey.currentContext.findRenderObject();
        ui.Image image = await boundary.toImage(pixelRatio: 5.0);
        ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData.buffer.asUint8List();

        rutaImgQRCode = (await getApplicationDocumentsDirectory()).path;
        File file = File("$rutaImgQRCode/$nombreImgQRCode");
        await file.writeAsBytes(pngBytes);

       if (file != null) { // Valida si hay o no imagen 
          codigos.ruta_url = await codigoProvider.subirImagen(file);  // Sube img a Cloudinary
        } 
      /* FIN Guardar IMAGEN en CLOUDINARY */

      // Carga de datos a la entidad para ser enviados a la base de datos
      codigos.mensaje = mensaje;
      codigos.fec_creacion = DateTime.now().toString();
      codigos.fec_actualizacion = DateTime.now().toString();
      codigos.estado = true;
      SharedPreferences sp = await SharedPreferences.getInstance();
      codigos.usuarios_id = sp.getInt(spId);
      if (codigos.mensaje != null || codigos.mensaje.isNotEmpty || codigos.mensaje != '') {
          String datosJson = codigosToJson(codigos);
          codigoProvider.creaCodigos(context, datosJson);          
      }
      setState(() {
        isButonDisabled = true;
        tituloBotonCrearCodigo = 'Procesado';
      });
    } catch (e) {
      logger.w(e.toString());
    }
  }

  void sharingQRCode() async {
    try{
      // /data/user/0/com.acanta.miincode/app_flutter/QRCodeGenerado.png
      var bytesImgQR = await new File('$rutaImgQRCode/$nombreImgQRCode').readAsBytes();  
      await Share.file('esys image', 'esys.png', bytesImgQR.buffer.asUint8List(), 'image/png');
    } catch (e) {
      logger.w(e.toString());
    }    
  }

}
