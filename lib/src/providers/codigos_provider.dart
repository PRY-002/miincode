import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/codigo_model.dart';
import 'package:miincode/src/models/codigos.dart';
import 'package:miincode/src/providers/ws.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; 

  // VARIABLES ----------------------------------
  String _email;
  String _idUsuario;

/* ----- LOGGER ---------------- */
var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));
/* ----- LOGGER ---------------- */

  void main() => runApp(CodigosProvider());

class CodigosProvider extends StatefulWidget {

  @override
  _CodigosProviderState createState() => _CodigosProviderState();

  // CREAR CODIGOS
  Future<bool> crearCodigo(Codigos codigo ) async {
    try {
      final url = urlCodigosCreate;
        logger.i('---------------------> 001 url' + url);
      final resp = await http.post(
        url, 
        body: codigosToJson(codigo) 
      );

        logger.i('---------------------> 002 resp' + resp.toString());
      final decodedData = json.decode(resp.body);
        logger.i('---------------------> 003 decodedData' + decodedData.toString());
      if ( decodedData == null ) {
        logger.w('---------------------> 004 NO se pudo registrar el producto en MYSQL. PORQUE no se encontraron datos.');        
      }

      //return true;
    } catch (e) {
      logger.w(e.toString());
      //return false;
    }
  }

  Future<http.Response> creaCodigos (BuildContext context, String datos) async {
    try {
      var url = urlCodigosCreate;
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: datos
      );
      if ( response.statusCode == 200 ) {
        showAlertDialog_1(context, 'Importante', 'QR guardado satisfactoriamente..');
      } else {
        showAlertDialog_1(context, 'ERROR', 'Hubo problemas al GUARDAR la informacion.\n Response.StatusCode: ' + response.statusCode.toString());
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