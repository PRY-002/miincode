
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:miincode/src/utils/utils_conectividad.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:miincode/src/models/usuario_model.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class DatabaseHelper {

  // Variables que identifican las las Tablas y Campos respectivos.
  static final _databaseName = "miincode.db";
  static final _databaseVersion = 1;
    static final tableUsuarios = 'usuarios';  
      static final column_Id = '_id';
      static final columnId = 'id';
      static final columnUid = 'uid';
      static final columnEmail = 'email';
      static final columnNombres = 'nombres';
      static final columnApePat = 'apepat';
      static final columnApeMat = 'apemat';
      static final columnNroMovil = 'nromovil';
      static final columnDisponible = 'disponible';
      static final columnFotoUrl = 'fotourl';
      static final columnFecNac = 'fecnac';
      static final columnGenero = 'genero';
      static final columnDni = 'dni';
  // --------------------------------------------------------------------

  static Database _database;
  static final DatabaseHelper db = DatabaseHelper._();

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Future<Database> get database async {
     if ( _database  != null ) return _database;
     _database = await initDB();
     return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join( documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE ' + tableUsuarios + ' ('+
          column_Id + ' INTEGER PRIMARY KEY AUTOINCREMENT, '+
          columnId + ' TEXT, '+
          columnUid + ' TEXT, '+
          columnEmail + ' TEXT, '+
          columnNombres + ' TEXT, '+
          columnApePat + ' TEXT, '+
          columnApeMat + ' TEXT, '+
          columnNroMovil + ' TEXT, '+
          columnDisponible + ' TEXT, '+       //TRUE  or  FALSE
          columnFotoUrl + ' TEXT, '+
          columnFecNac + ' TEXT, ' +
          columnGenero + ' TEXT, ' +
          columnDni + ' TEXT)'
        );
      } 

    );
  }

  // CREAR Registros
  nuevoUsuarioRaw ( UsuarioModel nuevoUsuario ) async {
    final db = await database;
    final res = await db.rawInsert(
      'INSERT Into Usuarios (id, uid, email, nombres, apepat, apemat, nromovil, disponible, fotourl, fecnac, genero, dni) '
      'VALUES ( ${ nuevoUsuario.id }, ${ nuevoUsuario.uid }, ${ nuevoUsuario.email }, ${ nuevoUsuario.nombres }, ${ nuevoUsuario.apepat }, ${ nuevoUsuario.apemat }, ${ nuevoUsuario.nromovil }, ${ nuevoUsuario.disponible }, ${ nuevoUsuario.fotoUrl }, ${ nuevoUsuario.fecnac }, ${ nuevoUsuario.genero }, ${ nuevoUsuario.dni })'
    );
    return res;
  }

  crearUsuario ( UsuarioModel nuevoUsuario ) async {
    final db = await database;
    final res = db.insert(tableUsuarios, nuevoUsuario.toJson());
    return res;
  }

  // SELECT - Obtener informacion
  Future<UsuarioModel> getUsuarioId( int id ) async {
    final db = await database;
    final res = await db.query(tableUsuarios, where: 'id = ?', whereArgs: [id] );
    return res.isNotEmpty ? UsuarioModel.fromJson( res.first ) : null;
  }

  pintaDatosRegistradosDeUsuario( String email ) async {
    final db = await database;
    final res = await db.query(tableUsuarios, where: 'email = ?', whereArgs: [email] );
    UsuarioModel um = UsuarioModel();    
    if ( res.isNotEmpty ) {
      um = UsuarioModel.fromJson( res.first );

      logger.i('--------------------> DATOS DEL USUARIO LOGUEADO <------------------ INI');
      logger.i(um.id == null ? null :          '--------------------> ID: ' + um.id);
      logger.i(um.uid == null ? null :         '--------------------> UID: ' + um.uid);
      logger.i(um.email == null ? null :       '--------------------> EMAIL: ' + um.email);
      logger.i(um.nombres == null ? null :     '--------------------> NOMBRES: ' + um.nombres);
      logger.i(um.apepat == null ? null :      '--------------------> APEPAT: ' + um.apepat);
      logger.i(um.apemat == null ? null :      '--------------------> APEMAT: ' + um.apemat);
      logger.i(um.nromovil == null ? null :    '--------------------> NROMOVIL: ' + um.nromovil);
      logger.i(um.disponible == null ? null :  '--------------------> DISPONIBLE: ' + um.disponible);
      //+ um.fotoUrl == null ? null :     '--------------------> FOTOURL: ' + um.fotoUrl
      logger.i(um.fecnac == null ? null :      '--------------------> FECNAC: ' + um.fecnac);
      logger.i(um.genero == null ? null :      '--------------------> GENERO: ' + um.genero);
      logger.i(um.dni == null ? null :         '--------------------> DNI: ' + um.dni);
      logger.i('--------------------> DATOS DEL USUARIO LOGUEADO <------------------ FIN');
      return um;
    } else {
      logger.i('--------------------> No se encontraron datos.');
      return null;
    }

    //return res.isNotEmpty ? UsuarioModel.fromJson( res.first ) : null;
  }

  Future<List<UsuarioModel>> getTodosUsuarios() async {
    try {
      final db = await database;
      final res = await db.query(tableUsuarios);
      List<UsuarioModel> list = res.isNotEmpty ? res.map( (c) => UsuarioModel.fromJson(c) ).toList() : [];
      return list;      
    } catch (e) {
      logger.w(e.toString());
    }
  }

  Future<List<UsuarioModel>> getTodosPorEmail( String email ) async {
    try {
      final db = await database;
      final res = await db.rawQuery("SELECT * FROM " + tableUsuarios + " WHERE email = " + email);
      List<UsuarioModel> list = res.isNotEmpty ? res.map( (c) => UsuarioModel.fromJson(c) ).toList() : [];
      return list;      
    } catch (e) {
      logger.w(e.toString());
    }
  }

  getEmailUsuarioLogueado() async {
    try {
      final db = await database;
      final res = await db.query(tableUsuarios, where: columnDisponible+' = ?', whereArgs: ['true']);
      return res.isNotEmpty ? UsuarioModel.fromJson( res.first ) : null;      
    } catch (e) {
      logger.w(e.toString());
    }
  }

  Future<UsuarioModel> getUsuarioPorEmail( String email ) async {
    try {
      final db = await database;
      final res = await db.query( tableUsuarios, where: 'email=?', whereArgs: [email] );
      return res.isNotEmpty ? UsuarioModel.fromJson( res.first ) : null; 
    } catch (e) {
      logger.w(' ERROR - getUsuarioPorEmail: '+e.toString());
    }
  } 

  Future<bool> existeUsuario( String email ) async {
    try {
      final db = await database;
      final res = await db.query( tableUsuarios, where: 'email=?', whereArgs: [email]);
      if ( res.length > 0 ) {
        logger.i('--------------------> Se encontraron [' + res.length.toString() + '] usuario(s).');
        return true;
      } else {
        logger.i('--------------------> Se encontraron [' + res.length.toString() + '] usuario(s).');
        return false;
      }      
    } catch (e) {
      logger.w(e.toString());
    }
  }

  // ACtualizar registros
  Future<int> actualizarUsuario( UsuarioModel nuevoUsuario) async {
    try {
      final db = await database;
      final res = await db.update(tableUsuarios, nuevoUsuario.toJson(), where: 'id = ?', whereArgs: [nuevoUsuario.id] );
      return res;      
    } catch (e) {
      logger.w(e.toString());
    }
  }

  // Eliminar registros
  Future<int> deleteUsuario( String email ) async {
    try {
      final db = await database;
      final res = await db.delete(tableUsuarios, where: 'email = ?', whereArgs: [email] );
      return res;
    } catch (e) {
      logger.w(e.toString());
    }
  }

  Future<int> deleteAll() async {
    try {
      final db = await database;
      final res = await db.rawDelete('DELETE FROM ' + tableUsuarios);
      return res;
    } catch (e) {
      logger.w(e.toString());
    }
  }
  
}