import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/producto_model.dart';
import 'package:miincode/src/providers/database_helper.dart';
import 'package:miincode/src/utils/utils_conectividad.dart';
final nombreProyecto = 'ALLARO';

/* ----- LOGGER ---------------- */
var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));
/* ----- LOGGER ---------------- */

// ALERTS **********************************************************************
showAlertDialog_1(BuildContext context, String titulo, String mensaje) {
  Widget okButton = FlatButton(
    child: Icon(
      Icons.check,
      color: Colors.green,
      size: 40,
    ),
    onPressed: (){
      Navigator.of(context).pop();
    }
  );

  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
    backgroundColor: Colors.black87,
    contentTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1)),
    titleTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1), fontSize: 20, fontWeight: FontWeight.bold),
    title: Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Icon(
            Icons.priority_high,
            color: Colors.red,
            size: 50,
            textDirection: TextDirection.ltr,
          ),
          Text(titulo, style: TextStyle(color: Colors.red, fontSize: 25),
          )
        ],
      ),
    ),
    content: Text(
      '\n'+mensaje,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    actions: <Widget>[
      okButton
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

showAlertDialog_Register(BuildContext context, String mensaje, String page) {
  Widget okButton = FlatButton(
    child: Icon(
      Icons.check,
      color: Colors.green,
      size: 40,
    ),
    onPressed: (){
      Navigator.of(context).pop();
      Navigator.pushReplacementNamed(context, page);
    }
  );

  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
    backgroundColor: Colors.black87,
    contentTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1)),
    titleTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1), fontSize: 20, fontWeight: FontWeight.bold),
    title: Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Icon(
            Icons.priority_high,
            color: Colors.red,
            size: 50,
            textDirection: TextDirection.ltr,
          ),
          Text('Error.', style: TextStyle(color: Colors.red, fontSize: 25),
          )
        ],
      ),
    ),
    content: Text(
      '\n'+mensaje,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    actions: <Widget>[
      okButton
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

showAlertDialog_2(BuildContext context, String titulo, String mensaje, Widget page) {
  Widget btnSi = FlatButton(
    child: Icon(
      Icons.check,
      color: Colors.green,
      size: 40,
    ),
    onPressed: (){
      Navigator.of(context).pop();
    }
  );

  Widget btnNo = FlatButton(
    child: Icon(
      Icons.not_interested,
      color: Colors.red,
      size: 40,
    ),
    onPressed: (){
      goPage(context, page);
    }
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.black54,
    contentTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1)),
    titleTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1), fontSize: 20, fontWeight: FontWeight.bold),
    title: Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Icon(
            Icons.priority_high,
            color: Colors.red,
            size: 50,
            textDirection: TextDirection.ltr,
          ),
          Text(titulo, style: TextStyle(color: Colors.red, fontSize: 25),
          )
        ],
      ),
    ),
    content: Text(
      '\n'+mensaje,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    actions: <Widget>[
      btnSi, btnNo
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

showAlertDialog_3(BuildContext context, String titulo, String mensaje, Widget page) {
  Widget btnSi = FlatButton(
    child: Icon(
      Icons.check,
      color: Colors.green,
      size: 40,
    ),
    onPressed: (){
      goPage(context, page);
    }
  );

  Widget btnNo = FlatButton(
    child: Icon(
      Icons.not_interested,
      color: Colors.red,
      size: 40,
    ),
    onPressed: (){
      Navigator.of(context).pop();
    }
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.black54,
    contentTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1)),
    titleTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1), 
    fontSize: 20, fontWeight: FontWeight.bold),
    title: Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Icon(
            Icons.priority_high,
            color: Colors.red,
            size: 50,
            textDirection: TextDirection.ltr,
          ),
          Text(titulo, style: TextStyle(color: Colors.red, fontSize: 25),
          )
        ],
      ),
    ),
    content: Text(
      '\n'+mensaje,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    actions: <Widget>[
      btnSi, btnNo
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

showAlertCerrarSesion_SP(BuildContext context, String titulo, String mensaje, String nameLayout, String email) {
  Widget btnSi = FlatButton(
    child: Icon(
      Icons.check,
      color: Colors.green,
      size: 40,
    ),
    onPressed: (){
      spCrearLimpiarVariablesSesion(context);
      Navigator.pushReplacementNamed(context, 'login');
      logger.i('-------------------->CERRANDO SESION ------------ fin');
      //spBorrarDatosVariablesSesionPersistente(context, nameLayout);
      //DatabaseHelper.db.deleteUsuario(email);
    }
  );

  Widget btnNo = FlatButton(
    child: Icon(
      Icons.not_interested,
      color: Colors.red,
      size: 40,
    ),
    onPressed: (){
      Navigator.of(context).pop();
    }
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.black54,
    contentTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1)),
    titleTextStyle: TextStyle(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold),
    title: Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Icon(
            Icons.priority_high,
            color: Colors.red,
            size: 50,
            textDirection: TextDirection.ltr,
          ),
          Text(titulo, style: TextStyle(color: Colors.red, fontSize: 25),
          )
        ],
      ),
    ),
    content: Text(
      '\n'+mensaje,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    actions: <Widget>[
      btnSi,
      btnNo
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

showPopUp1(BuildContext context, ProductoModel producto, String mensaje) {
  Widget okButton = FlatButton(
    child: Icon(
      Icons.check,
      color: Colors.green,
      size: 40,
    ),
    onPressed: (){
      Navigator.of(context).pop();
    }
  );

  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
    backgroundColor: Colors.black54,
    contentTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1)),
    titleTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1), fontSize: 20, fontWeight: FontWeight.bold),
    title: Container(
      alignment: Alignment.center,
      child: Center(
        child: ( producto.fotoUrl == null ) 
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
              image: NetworkImage( producto.fotoUrl ),
              placeholder: AssetImage('assets/jar-loading.gif'),
              height: 200.0,
              width: 200.0, //double.infinity,
              fit: BoxFit.fill,
            ),
      ),
    ),
    content: Text(mensaje, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    actions: <Widget>[
      okButton
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

showPopUp2(BuildContext context, List data, int i) {
  Widget okButton = FlatButton(
    child: Icon(
      Icons.check,
      color: Colors.green,
      size: 40,
    ),
    onPressed: (){
      Navigator.of(context).pop();
    }
  );

  AlertDialog alert = AlertDialog(
    
    contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
    backgroundColor: Colors.black87,
    contentTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1)),
    titleTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1), fontSize: 20, fontWeight: FontWeight.bold),
    title: Container(
      alignment: Alignment.center,
      child: Center(
        child: ( data[i]['ruta_url'] == null ) 
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
              image: NetworkImage( data[i]['ruta_url'] ),
              placeholder: AssetImage('assets/jar-loading.gif'),
              height: 200.0,
              width: 200.0, //double.infinity,
              fit: BoxFit.fill,
            ),
      ),
    ),
    content: Text(data[i]['mensaje'], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    actions: <Widget>[
      okButton
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

/* ============================================================== */

bool showAlertDialog_4(BuildContext context, String titulo, String mensaje) {
  Widget btnSi = FlatButton(
    padding: EdgeInsets.all(5),
    child: Text(
      'SI',
      style: TextStyle(
        color: Colors.redAccent, 
        fontSize: 20,
        fontWeight: 
        FontWeight.bold
      ),
    ),
    onPressed: (){
      Navigator.of(context).pop();
      return true;
    }
  );

  Widget btnNo = FlatButton(
    child: Text(
      'NO',
      style: TextStyle(
        color: Color.fromRGBO(39, 191, 178, 1), 
        fontSize: 20,
        fontWeight: 
        FontWeight.bold
      ),
    ),
    onPressed: (){
      Navigator.of(context).pop();
      return false;
    }
  );

  AlertDialog alert = AlertDialog(
    contentTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1)),
    titleTextStyle: TextStyle(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold),
    title: Text(titulo),
    content: Text(mensaje),
    actions: <Widget>[
      btnSi,
      btnNo
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

goPage(BuildContext context, Widget page) {
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    await Future.delayed(const Duration(milliseconds: 100));
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  });
}

showAlertError(BuildContext context, String titulo, String mensaje) {
  Widget okButton = FlatButton(
    child: Text(
      'OK',
      style: TextStyle(
        color: Colors.red, 
        fontSize: 20,
        fontWeight: 
        FontWeight.bold
      ),
    ),
    onPressed: (){
      Navigator.of(context).pop();
    }
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1)),
    titleTextStyle: TextStyle(color: Color.fromRGBO(39, 191, 178, 1), fontSize: 20, fontWeight: FontWeight.bold),
    title: Text(titulo, style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
    content: Text(mensaje),
    actions: <Widget>[
      okButton
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

bool isNumeric( String s ) {
  if ( s.isEmpty ) return false;
  final n = num.tryParse(s);
  return ( n == null ) ? false : true;
}