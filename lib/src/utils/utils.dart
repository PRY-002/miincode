import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';

/* ----- LOGGER ---------------- */
var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));
/* ----- LOGGER ---------------- */

// Popup de Mensaje de Error - Muestra mensaje + un boton de cierre del alert
showAlertDialog(BuildContext context, String titulo, String mensaje) {
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
          Text(titulo, style: TextStyle(color: Colors.red, fontSize: 25),  textAlign: TextAlign.center,
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

// Popup de Mensaje de Exito - Muestra mensaje + un boton de cierre del alert - Post cierre de alert redirecciona a la pagina indicada
showAlertDialogRedireccionable(BuildContext context, String titulo, String mensaje, String page) {
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
          Text(titulo, style: TextStyle(color: Colors.red, fontSize: 25), textAlign: TextAlign.center,
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

// El redireccionamiento se ejecuta cuando responde NO <------------------
showAlertDialogRedireccionableOpc_siNO(BuildContext context, String titulo, String mensaje, String page) {
  Widget siButton = FlatButton(
    child: Icon(
      Icons.check,
      color: Colors.green,
      size: 40,
    ),
    onPressed: (){
      Navigator.of(context).pop();
    }
  );

  Widget noButton = FlatButton(
    child: Icon(
      Icons.close,
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
          Text(titulo, style: TextStyle(color: Colors.red, fontSize: 25), textAlign: TextAlign.center,
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
      siButton,
      noButton
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

// El redireccionamiento se ejecuta cuando responde SI <------------------
showAlertDialogRedireccionableOpc_SIno(BuildContext context, String titulo, String mensaje, String page) {
  Widget siButton = FlatButton(
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

  Widget noButton = FlatButton(
    child: Icon(
      Icons.close,
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
          Text(titulo, style: TextStyle(color: Colors.red, fontSize: 25), textAlign: TextAlign.center,
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
      siButton,
      noButton
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

// Cierra la aplicación al 100% (Solo debe utilizarse al cerrar desde el Login.)
showAlertDialogCerrarsesion(BuildContext context, String titulo, String mensaje) {
  Widget siButton = FlatButton(
    child: Icon(
      Icons.check,
      color: Colors.green,
      size: 40,
    ),
    onPressed: (){
      Navigator.of(context).pop();
      exit(0);
    }
  );
  Widget noButton = FlatButton(
    child: Icon(
      Icons.close,
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
          Text(titulo, style: TextStyle(color: Colors.red, fontSize: 25), textAlign: TextAlign.center,
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
      siButton,
      noButton
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

// Muestra el detalle del producto seleccionado.
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

/*   Widget shareButton = FlatButton(
    child: Icon(
      Icons.share,
      color: Colors.blueAccent,
      size: 40,
    ),
    onPressed: (){
      Navigator.of(context).pop();
    }
  ); */

  AlertDialog alert = AlertDialog(
    
    contentPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
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
    content: Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: Text(data[i]['mensaje'], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
    actions: <Widget>[
      okButton
      // shareButton
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}

// Validacion si el dato es numerico.
bool isNumeric( String s ) {
  if ( s.isEmpty ) return false;
  final n = num.tryParse(s);
  return ( n == null ) ? false : true;
}

// Redirecciona  hacia el layout indicado
goPage(BuildContext context, Widget page) {
  SchedulerBinding.instance.addPostFrameCallback((_) async {
    await Future.delayed(const Duration(milliseconds: 100));
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  });
}
