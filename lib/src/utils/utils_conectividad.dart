import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/usuario_model.dart';
import 'package:miincode/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*================================================== LOGGER ================================================ */
var logger = Logger( printer: PrettyPrinter() );
var loggerNoStack = Logger( printer: PrettyPrinter(methodCount: 0) );
/*================================================== LOGGER ================================================ */

/*=========================================== SHARED PREFERENCES =========================================== */
final String spSesionActiva = 'spSesionActiva';
final String spId = 'spId';
final String spUid = 'spUid';
final String spEmail = 'spEmail';
final String spNombres = 'spNombres';
final String spApePat = 'spApePat';
final String spApeMat = 'spApeMat';
final String spFecNac = 'spFecNac';
final String spGenero = 'spGenero';
final String spDni = 'spDni';
final String spFecCreacion = 'spFecCreacion';
final String spFecActualizacion = 'spFecActualizacion';
final String spNroMovil = 'spNroMovil';
final String spUrlFoto = 'spUrlFotoUsuario';
final String spEstado = 'spEstado';
final String spPerfilId = 'spPerfilId';
/*=========================================== SHARED PREFERENCES =========================================== */

UsuariosProvider up; // = UsuariosProvider();

// COMPRUEBA LA CONEXION A INTERNET
existeConexionInternet() async {
  try {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) { 
      logger.i('-------------------->Conectado a la Red Móbil.');
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      logger.i('-------------------->Conectado a Wifi.');
      return true;
    } else {
      logger.i('-------------------->No puede conectarse. \nPor favor, compruebe la conexión a Internet');
      return false;
    }    
  } catch (e) {
    logger.w(e.toString());
  }
}

spCrearLimpiarVariablesSesion(BuildContext context) async {
  try {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(spSesionActiva, false);
    sp.setString(spEmail, '');
    return sp;    
  } catch (e) {
    logger.w('' + e.toString());
  }
}

spReturnEmail() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final em = await prefs.getString(spEmail);
    logger.i('--------------------> Email: ' + em);
    return em;    
  } catch (e) {
    logger.w(e.toString());
  }
}

// ------------------------------------------------------------------------------------------------------------------
// Utilizado para guardar datos DEl Usuario PERSISTENTES EN EL TIEMPO de ejecucion del Programa. -------------------------------------
spGuardarDatosPersistentesDeUsuario(BuildContext context, int _spId, String _spUid, String _spEmail, String _spNombres, String _spApePat, String _spApeMat, String _spNroMovil, String _spFecNacimiento, String _spGenero, String _spDni, String _spUrlFoto,String _spFecCreacion, String _spFecActualizacion, bool _spEstado, int _spPerfilesId, String nameLayout) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt(spId, _spId);
  bool check = sp.containsKey(spId);
  if (check) {
    try {
      sp.setString(spUid, _spUid);
      sp.setString(spEmail, _spEmail);
      sp.setString(spNombres, _spNombres);
      sp.setString(spApePat, _spApePat);
      sp.setString(spApeMat, _spApeMat);
      sp.setString(spFecNac, _spFecNacimiento);
      sp.setString(spGenero, _spGenero);
      sp.setString(spDni, _spDni);
      sp.setString(spUrlFoto, _spUrlFoto);
      sp.setString(spNroMovil, _spNroMovil);
      sp.setString(spFecCreacion, _spFecCreacion);
      sp.setString(spFecActualizacion, _spFecActualizacion);
      sp.setBool(spEstado, _spEstado);
      sp.setInt(spPerfilId, _spPerfilesId); 
    } catch (e) {
      logger.w(e.toString());
    }
  }
}

spPintarDatosUsuarioLogueado() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  print('=================================================');
  print('=================================================');
  print(sp.getInt(spId));
  print(sp.getString(spUid));
  print(sp.getString(spEmail));
  print(sp.getString(spNombres));
  print(sp.getString(spApePat));
  print(sp.getString(spApeMat));
  print(sp.getString(spFecNac));
  print(sp.getString(spGenero));
  print(sp.getString(spDni));
  print(sp.getString(spUrlFoto));
  print(sp.getString(spNroMovil));
  print(sp.getString(spFecCreacion));
  print(sp.getString(spFecActualizacion));
  print(sp.getBool(spEstado));
  print(sp.getInt(spPerfilId));
  print('=================================================');
  print('=================================================');
}
// ------------------------------------------------------------------------------------------------------------------

Future<UsuarioModel> spObtenerDatos(BuildContext context) async {
  UsuarioModel um = UsuarioModel();
  SharedPreferences sp = await SharedPreferences.getInstance();
  um.id = sp.getString(spId);
  um.uid = sp.getString(spUid);
  um.email = sp.getString(spEmail);
  um.nombres = sp.getString(spNombres);
  um.apepat = sp.getString(spApePat);
  um.apemat = sp.getString(spApeMat);
  um.nromovil = sp.getString(spNroMovil);
  um.disponible = sp.getString(spEstado);
  um.fotoUrl = sp.getString(spUrlFoto);
  return um;
}

spBorrarDatosVariablesSesionPersistente(BuildContext context, String nameLayout) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool check = sp.containsKey(spId);
  if (check) {
    sp.setString(spEmail, '');
    sp.setString(spNombres, '');
    sp.setString(spApePat, '');
    sp.setString(spApeMat, '');
    sp.setString(spId, '');
    sp.setString(spUid, '');
    sp.setString(spNroMovil, '');
    sp.setString(spUrlFoto, '');
    sp.setBool(spEstado, false);
  } else {
    logger.i('-------------------->IMPRESO DESDE: utils_conectividad.dart');
    logger.i('-------------------->[spBorrarDatosVariablesSesionPersistente] ------------------------------------------------------' + DateTime.now().toString());
    logger.i('-------------------->bool check = sp.containsKey(spIdUsuario);');
  }
}

Future<bool> verificarSesionIniciada(BuildContext context) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool checkValue = sp.containsKey('spEstadoSesion');
  //bool valBoolean = sp.getBool('sessionIniciada');
  if (checkValue) {
    bool estado = sp.getBool('spEstadoSesion');
    if ( estado ) {
      return true; //Navigator.pushReplacementNamed(context, 'home');
    } else {
      return false; //Navigator.pushReplacementNamed(context, 'login');
    }
  } else {
    logger.i('-------------------->La variable de Sesion Aun no ha sido creada.');
    return false;
  }  
}

