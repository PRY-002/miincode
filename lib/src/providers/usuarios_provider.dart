import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'package:http_parser/http_parser.dart';
import 'package:miincode/src/models/usuario_model.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:mime_type/mime_type.dart';

class UsuariosProvider {

  final String _url = 'https://miincode.firebaseio.com';

  Future<bool> crearUsuario( UsuarioModel usuario) async {
    final url = '$_url/usuarios.json';
    final resp = await http.post( url, body: usuarioModelToJson(usuario) );
    final decodedData = json.decode(resp.body);
//    print('-------------------->'+decodedData);
    return true;
  }

  Future<bool> editarUsuario( UsuarioModel usuario ) async {
    final url = '$_url/usuarios/${ usuario.id }.json';
    final resp = await http.put( url, body: usuarioModelToJson(usuario) );
    final decodedData = json.decode(resp.body);
    if ( decodedData != null ) {
      return true;  
    } else {
      return false;
    }
  }

  Future<bool> existeUsuario( String idUsuario ) async {
    final url = '$_url/usuarios/'+ idUsuario +'.json';
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    if ( decodedData == null ) {
      return false;
    } else {
      return true;
    }
  }

  Future<UsuarioModel> obtenerUsuario( BuildContext context, String idUsuario ) async {
    final url = '$_url/usuarios/'+ idUsuario +'.json';
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    UsuarioModel um = decodedData;
    if ( um == null ) { showAlertDialog(context, 'ALERTA', 'NO SE ENCONTRARON DATOS.'); }
    return um;
  }

/* LISTADO DE USUARIOS ************************************************************ INI */
/*  Widget obtenerDatosUsuario_xEmail(String email) {
    return FutureBuilder(
      future: cargarUsuarios(),
      builder: (BuildContext context, AsyncSnapshot<List<UsuarioModel>> snapshot) {
        if ( snapshot.hasData ) {
          final usuarios = snapshot.data;

          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, i) => _crearItemUsuarios( context, usuarios[i], email),
          );
        } else {
          return Center( child: CircularProgressIndicator() );
        }
      }
    );
  }
*/

  Future<List<UsuarioModel>> cargarUsuarios() async {
    final url  = '$_url/usuarios.json';  
    final resp = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<UsuarioModel> usuarios = new List();
    
    if ( decodedData == null ) return [];
    decodedData.forEach( ( id, prod ){
      print('--------------------> 6.1.9' + id);
      final prodTemp = UsuarioModel.fromJson(prod);
            print('--------------------> 6.2');
            print('--------------------> 6.2' + prodTemp.id);
            print('--------------------> 6.2' + prodTemp.id);
            print('--------------------> 6.2.1'+prodTemp.toString());
      usuarios.add( prodTemp );
    });
    return usuarios;
  }

  Future<int> borrarUsuario( String id ) async { 
    final url  = '$_url/usuarios/$id.json';
    final resp = await http.delete(url);
    print('-------------------->'+ resp.body );
    return 1;
  }

  String tramaEjemploBase64 = 'iVBORw0KGgoAAAANSUhEUgAABDgAAAQ4CAYAAADsEGyPAAAAAXNSR0IArs4c6QAAAARzQklUCAgICHwIZIgAACAASURBVHic7NrRrtvKkiRQcuD/Zv0556HRQJ/pOeXtqzIZUVoL4KuclZmk5Ng87/u+DwAAAIBi/+ftAgAAAAA+JeAAAAAA6gk4AAAAgHoCDgAAAKCegAMAAACoJ+AAAAAA6gk4AAAAgHoCDgAAAKCegAMAAACoJ+AAAAAA6gk4AAAAgHoCDgAAAKCegAMAAACoJ+AAAAAA6gk4AAAAgHoCDgAAAKCegAMAAACoJ+AAAAAA6gk4AAAAgHoCDgAAAKCegAMAAACoJ+AAAAAA6gk4AAAAgHoCDgAAAKCegAMAAACoJ+AAAAAA6v168h87z/PJf44Q932/XcI/2MMuq/Zn1dzT6lnFueZ2Pdeu0uaVxv7M2Z85+zOXtj9p80rrD894cg+9wQEAAADUE3AAAAAA9QQcAAAAQD0BBwAAAFBPwAEAAADUE3AAAAAA9QQcAAAAQD0BBwAAAFBPwAEAAADUE3AAAAAA9QQcAAAAQD0BBwAAAFBPwAEAAADUE3AAAAAA9QQcAAAAQD0BBwAAAFBPwAEAAADUqww47vt2PXDtKrE/Y4zX5516rlUS+5PkPM8l10r2p0fa/iTO67quqHqS2J/fsz//zv58p1V9du23h5UBB+xkjPF2CX/FrufiGfaHndhnPmF/AH7uvB+MZlalo61pUhvzmtu1P7ueK83qtx12s+v+7Hp/OdfcqnOl1bOKc83ZnznnmnMuPtE4L29wAAAAAPUEHAAAAEA9AQcAAABQT8ABAAAA1BNwAAAAAPUEHAAAAEA9AQcAAABQT8ABAAAA1BNwAAAAAPUEHAAAAEA9AQcAAABQT8ABAAAA1BNwAAAAAPUEHAAAAEA9AQcAAABQ79fbBbzpPM+3S/gr7vt+u4S/Im1eq/q86lxpc087V1o9aec6juMYYxzXdX30GavqSZuXerqkfV+k1';
  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/ddsv1vilp/image/upload?upload_preset=roim6us7');
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', 
    imagen.path, contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201) {
      print('-------------------->Algo salio mal');
      print('-------------------->'+resp.body);
      return null;
    } else {
      final respData = json.decode(resp.body);
      print('-------------------->IMAGEN SUBIDA ------------------------------');
      print('-------------------->'+respData);
      print('-------------------->respBody'+resp.body);
      return respData['secure_url'];
    }
  }
}