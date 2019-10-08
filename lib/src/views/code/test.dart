
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show ImageFilter, Gradient, Image, ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/usuario_model.dart';
import 'package:miincode/src/providers/productos_provider.dart';
import 'package:miincode/src/utils/utils_conectividad.dart';
import 'package:path_provider/path_provider.dart';

/* ----- LOGGER ---------------- */
var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));
/* ----- LOGGER ---------------- */

void main() => runApp(Test());

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}



class _TestState extends State<Test> {
  GlobalKey _globalKey = new GlobalKey();
  GlobalKey _renderObjectKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    /*
    return Scaffold(
        body: Column(children: [
      RepaintBoundary(
        key: _renderObjectKey,
        child: QrImage(
          data: "some text",
         // size: 300.0,
          version: 10,
          backgroundColor: Colors.white,
        ),
      ),
      RaisedButton(
        child: Text('BUTTON'),
        onPressed: () {
        _getWidgetImage();
      }),
            RaisedButton(
        child: Text('BUTTON2'),
        onPressed: () {
        _saveToImage();
        
      }),
            RaisedButton(
        child: Text('BUTTON3'),
        onPressed: () {
        _capturePNG();
        
      }),
            RaisedButton(
        child: Text('BUTTON4'),
        onPressed: () {
        _capturePNG();
      }),
    ]));
  */

    return Scaffold(
      body: obtenerDatosUsuarioLogueado(),
    );
  }

      // ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
    
    Widget obtenerDatosUsuarioLogueado() {
      logger.i('-------------------->iongresoooo');
      UsuarioModel new_um = UsuarioModel();
      FutureBuilder(
        future: spObtenerDatos(context),
        builder: (BuildContext context, AsyncSnapshot<UsuarioModel> snapshot) {
                  logger.i('-------------------->adentro');
          if (snapshot.hasData) {
            final usuarios = snapshot.data;
            return Container(
              child: ListView(
                scrollDirection: Axis.vertical ,
                children: <Widget>[
                  Container(child: Text(usuarios.id)),
                  Container(child: Text(usuarios.uid)),
                  Container(child: Text(usuarios.email)),
                  Container(child: Text(usuarios.nombres)),
                  Container(child: Text(usuarios.apepat)),
                  Container(child: Text(usuarios.apemat)),
                  Container(child: Text(usuarios.nromovil)),
                  Container(child: Text(usuarios.fotoUrl)),
                ],
              ),
            );
          } else {
            logger.i('-------------------->NO SE ENCONTRARON DATOS...........');
          }
        },
      );
      logger.i('-------------------->salioooooooo');
    }

  Future<Uint8List> _getWidgetImage() async {
    try {
      RenderRepaintBoundary boundary = _renderObjectKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      logger.i('-------------------->IMAGENNNNN');
      logger.i('-------------------->'+byteData.toString());
      var pngBytes = byteData.buffer.asUint8List();
       logger.i('-------------------->1:'+ pngBytes.toString());
      var bs64 = base64Encode(pngBytes);
       logger.i('-------------------->2:'+bs64);
       logger.i('-------------------->3:' +bs64.length.toString());
       logger.i('-------------------->4:' +pngBytes.toString());

      return pngBytes;
    } catch (exception) {}
  }

  ProductosProvider prod_prov = ProductosProvider();
  _saveToImage() async {
    RenderRepaintBoundary boundary = _renderObjectKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 5.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    logger.i('-------------------->butedata: ' + byteData.toString());
    Uint8List pngBytes = byteData.buffer.asUint8List();
    /**/
        String dir = (await getApplicationDocumentsDirectory()).path; //'assets/images'; //
        logger.i('-------------------->'+"-------------------->Ruta Local :"+dir);
        File file = File("$dir/QRCodeGenerado.png");
       // File file = File("$dir/QRCode_" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
            logger.i('-------------------->'+"-------------------->Ruta Local :"+file.toString());
        await file.writeAsBytes(pngBytes);
        prod_prov.subirImagen(file);
  }

  Widget _muestra(File rt) {
    return Image.file(rt, alignment: Alignment.center, width: 200);
  }

  Future<String> _createFileFromString() async {
    final encodedStr = "put base64 encoded string here";
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    logger.i('-------------------->'+"-------------------->Ruta Local :"+dir);
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  void _showImage(Uint8List imageBytes){
    showDialog(
      context: _renderObjectKey.currentContext,
      barrierDismissible: true,
      builder: (BuildContext context2) =>
        new Center(
          child: new Container(
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.green, width: 5.0),
              color: Colors.blue,
            ),
            child: new Image(image: new MemoryImage(imageBytes), fit: BoxFit.contain,)
          ),
        )
    );
  }

  void writeToFile(List<int> list, String filePath) { // VICTOR POdrias guarda r en una ruta local luego subirla
    var file = File(filePath);
   //  logger.i('-------------------->file :'+file);
    file.writeAsBytes(list, flush: true, mode: FileMode.write);
  }

    Future<Uint8List> _capturePNG() async {
    try {
      RenderRepaintBoundary boundary = _renderObjectKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String bs64 = base64Encode(pngBytes);
      logger.i('-------------------->'+pngBytes.toString());
      logger.i('-------------------->'+bs64);
      return pngBytes;
    } catch (exception) {}
  }

}

