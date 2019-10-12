import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/codigo_model.dart';
import 'package:miincode/src/models/codigos.dart';
import 'package:miincode/src/providers/ws.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; 
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';


String _email;
String _idUsuario;


//String _urlCloudinary = 'https://api.cloudinary.com/v1_1/dfdy5e4tt/image/upload?upload_preset=h86ampvf';
String _urlCloudinary = 'https://api.cloudinary.com/v1_1/dfdy5e4tt/image/upload?upload_preset=h86ampvf';
String _urlApiBase = 'https://api.cloudinary.com/v1_1/dfdy5e4tt';

/* ----- LOGGER ---------------- */
var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));
/* ----- LOGGER ---------------- */

  void main() => runApp(CodigosProvider());

class CodigosProvider extends StatefulWidget {

  @override
  _CodigosProviderState createState() => _CodigosProviderState();

  Future<http.Response> creaCodigos (BuildContext context, String datos) async {

    try {

      var response = await http.post(urlCodigosCreate, headers: {"Content-Type": "application/json"}, body: datos);

      var extractData = json.decode(response.body);
      String _data = extractData['message'];    

      if ( response.statusCode == 200 ) {
        //showAlertDialog(context, 'Éxito', 'QR guardado satisfactoriamente..');´
        showAlertDialog(context, 'Éxito', _data );
      } else {
        showAlertDialog(context, 'Error', '[' + response.statusCode.toString() + '] ' + _data);        
        //showAlertDialog(context, 'ERROR', 'Hubo problemas al gu la informacion.\n Response.StatusCode: ' + response.statusCode.toString());
      }

      return response;

    } catch (e) {
      logger.w(e.toString());
    }
  }

  // LISTAR TODOS LOS CODIGOS
  Future<Codigos> fetchPost() async {
    final response = await http.get(urlCodigosListAll);
    if ( response.statusCode == 200 ) {
      return Codigos.fromJson(json.decode(response.body));
    } else {
      throw Exception('Errores al cargar los Codigos');
    }
  }

  Future<List<CodigoModel>> listarCodigos() async {
    
    final resp = await http.get('http://192.168.1.112:2800/api/codigos/list/4');//_urlListCodigos);
    logger.w('-------> 0001 ' + resp.body.toString());
    if ( resp == null ) {
      logger.w('SE ENCONTRO NULO');
    }
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<CodigoModel> codigos = new List();

    if ( decodedData == null ) return [];
    decodedData.forEach( ( id, cod ) {
      final codTemp = CodigoModel.fromJson(cod);
      if ( codTemp.usuarios_id == _idUsuario ) {
        codTemp.usuarios_id = id;
        codigos.add( codTemp );
      }
    });
    return codigos;
  }


  Future<String> subirImagen(File imagen) async {

    try {
      final url = Uri.parse(_urlCloudinary);
      final mimeType = mime(imagen.path).split('/');
      final imageUploadRequest = http.MultipartRequest('POST', url);
      final file = await http.MultipartFile.fromPath('file', imagen.path, contentType: MediaType(mimeType[0], mimeType[1])
      );

      imageUploadRequest.files.add(file);

      final streamResponse = await imageUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if ( resp.statusCode != 200 && resp.statusCode != 201) {
        return null;
      } else {
        final respData = json.decode(resp.body);
        return respData['secure_url'];
      }
    } catch (e) {
      logger.w(e.toString());
    }
  }



  Future<String> subirImagen_old(File imagen) async {

    try {
      final url = Uri.parse(_urlCloudinary);
      //final url = Uri.parse('https://api.cloudinary.com/v1_1/dfdy5e4tt/image/upload?upload_preset=h86ampvf');
      final mimeType = mime(imagen.path).split('/');

      final imageUploadRequest = http.MultipartRequest('POST', url);

      final file = await http.MultipartFile.fromPath('file', 
      imagen.path, contentType: MediaType(mimeType[0], mimeType[1])
      );

      imageUploadRequest.files.add(file);

      final streamResponse = await imageUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if ( resp.statusCode != 200 && resp.statusCode != 201) {
        return null;
      } else {
        final respData = json.decode(resp.body);
        return respData['secure_url'];
      }
    } catch (e) {
      logger.w(e.toString());
    }
  }  

}

class _CodigosProviderState extends State<CodigosProvider> {
  
  @override
  initState()  {
    super.initState();
    _loadDatos();
  }

  _loadDatos() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
    _email      = (sp.getString('spEmail')); 
    _idUsuario  = (sp.getString('spIdUsuario'));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return null;
  }
  
}