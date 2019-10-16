import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/models/codigo_model.dart';
import 'package:miincode/src/models/producto_model.dart';
import 'package:miincode/src/providers/codigos_provider.dart';
import 'package:miincode/src/providers/database_helper.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:miincode/src/utils/utils_conectividad.dart';
import 'package:miincode/src/views/code/create/qr_code_creater.dart';
import 'package:miincode/src/widgets/appbar.dart';
import 'package:miincode/src/widgets/for_create_qr.dart';

CodigosProvider cp = new CodigosProvider();
CodigoModel cm = new CodigoModel();

var logger = Logger( printer: PrettyPrinter() );
var loggerNoStack = Logger( printer: PrettyPrinter(methodCount: 0) );

TextEditingController controlerQRTexto = new TextEditingController();
TextEditingController controlerQRLink = new TextEditingController();
TextEditingController controlerQRPhone = new TextEditingController();
TextEditingController controlerQRSendSms = new TextEditingController();
TextEditingController controlerQRSendEmail = new TextEditingController();

class QRCreate extends StatefulWidget {

  
  @override
  _QRCreateState createState() => _QRCreateState();
}

class _QRCreateState extends State<QRCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProductoModel producto = new ProductoModel();
  File foto;
  final TextStyle estiloTexto = TextStyle(fontSize: 25);
  final Color colorRed = Colors.red;
  final Color colorBlue = Colors.blue;
  final Color colorPurple = Colors.purple;
  final Color colorGreen = Colors.green;
  final Icon iconText = Icon(Icons.library_books, color: Colors.blue, size: 35);
  final Icon iconLink = Icon(Icons.link, color: Colors.red, size: 35);
  final Icon iconImg = Icon(Icons.image, color: Colors.purple, size: 35);
  final Icon icon3D = Icon(Icons.perm_device_information, color: Colors.green, size: 35);

  @override
  Widget build(BuildContext context) {
    spReturnEmail().then((value){
      DatabaseHelper.db.pintaDatosRegistradosDeUsuario(value);
    });    
    
    return Scaffold(
        appBar:  myAppBar(context, 'CREAR CÓDIGO QR'),
        body: Form(
          key: _formKey,
          child: Container(
            color: Colors.black,
            child: ListView(
              padding: EdgeInsets.all(5),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                cardQrTexto(context, controlerQRTexto, foto),
                cardQrLink(context, controlerQRLink, foto),
                cardQrPhone(context, controlerQRPhone, foto),
                cardQrSendSms(context, controlerQRSendSms, foto),
                cardQrSendEmail(context, controlerQRSendEmail, foto)
              ],
            ),
          ),
        ));
    
  }

  Widget cardQrTexto(BuildContext context, TextEditingController controlerQRTexto, File foto) {
    return  Card(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: ExpandablePanel(
          tapBodyToCollapse: false,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          // Cabecera ----- TEXTO
          header: Container(
            height: 30,
            alignment: Alignment.centerLeft,
            //color: Colors.black26,
            child: FlatButton.icon(
              icon: Icon(Icons.format_align_justify, color: Colors.lightBlue,),
              label: Text('TEXTO'),
              onPressed: (){},
            )
          ),
          //collapsed: Text('CUERPO', softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis),
          expanded: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: TextField(
                      maxLength: 128,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: controlerQRTexto,
                      maxLines: 5,
                      minLines: 3,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        labelText: 'Ingrese cualquier texto'
                      ),
                    ),
                  ),
                  Container(
                    //color: colorBlue,
                    alignment: Alignment.centerRight,
                    child: RaisedButton.icon(
                      onPressed: (){
                        if ( controlerQRTexto.text == null || controlerQRTexto.text == '' ) {
                          showAlertDialog(context, 'Error', 'Debe digitar el texto.');
                        } else if ( controlerQRTexto.text.length < 5) {
                          showAlertDialog(context, 'Error', 'El texto debe tener por lo mínimo 5 caracteres.');
                        } else {
                          Navigator.of(context).push(
                              MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                                return QRCodeCreator(tipo: 'controlerQR_Texto', mensaje: controlerQRTexto, file: foto);
                              }
                            )
                          );
                        }
                      },
                      icon: Icon(Icons.save),
                      label: Text('Crear QR'),
                      textTheme: ButtonTextTheme.accent,
                    )
                  )

                ],
              )
              ),
          ),
          tapHeaderToExpand: false,
          hasIcon: true,
        ),
      ),
    );
    
  }

  Widget cardQrLink(BuildContext context, TextEditingController controlerQRLink, File foto) {
    return  Card(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: ExpandablePanel(
          tapBodyToCollapse: false,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          // Cabecera ----- TEXTO
          header: Container(
            height: 30,
            alignment: Alignment.centerLeft,
            //color: Colors.black26,
            child: FlatButton.icon(
              icon: Icon(Icons.link, color: Colors.lightBlue,),
              label: Text('DIRECCIÓN WEB'),
              onPressed: (){},
            )
          ),
          //collapsed: Text('CUERPO', softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis),
          expanded: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: TextField(
                      keyboardType: TextInputType.url,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.top,
                      controller: controlerQRLink,
                      maxLines: 1,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black12),
                        hintText: 'http://www.youtube.com',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        labelText: 'Ingrese cualquier dirección web'
                      ),
                    ),
                  ),
                  Container(
                    //color: colorBlue,
                    alignment: Alignment.centerRight,
                    child: RaisedButton.icon(
                      onPressed: (){
                        controlerQRLink.text == null || controlerQRLink.text == ''
                          ? 
                        showAlertDialog(context, 'Error', 'Debe digitar el texto.')
                          : 
                        Navigator.of(context).push(
                            MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                              return QRCodeCreator(tipo: 'controlerQR_Link', mensaje: controlerQRLink, file: foto);
                            }
                          )
                        );
                      },
                      icon: Icon(Icons.save),
                      label: Text('Crear QR'),
                      textTheme: ButtonTextTheme.accent,
                    )
                  )

                ],
              )
              ),
          ), //Text('ExpandablePaneltiene una serie de propiedades para personalizar su comportamiento, pero está restringido al tener un título en la parte superior y un icono de expansión que se muestra como una flecha hacia abajo (a la derecha o a la izquierda). Si eso no es suficiente, se puede implementar widgets personalizados ampliables mediante el uso de una combinación de Expandable, ExpandableNotifiery ExpandableButton:', softWrap: true, ),
          tapHeaderToExpand: false,
          hasIcon: true,
        ),
      ),
    );
    
  }

  Widget cardQrPhone(BuildContext context, TextEditingController controlerQRPhone, File foto) {
    return  Card(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: ExpandablePanel(
          tapBodyToCollapse: false,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          // Cabecera ----- TEXTO
          header: Container(
            height: 30,
            alignment: Alignment.centerLeft,
            //color: Colors.black26,
            child: FlatButton.icon(
              icon: Icon(Icons.phone_in_talk, color: Colors.lightBlue,),
              label: Text('TELÉFONO'),
              onPressed: (){},
            )
          ),
          //collapsed: Text('CUERPO', softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis),
          expanded: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: controlerQRPhone,
                      maxLines: 1,
                      minLines: 1,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        labelText: 'Ingrese un número telefónico válido'
                      ),
                    ),
                  ),
                  Container(
                    //color: colorBlue,
                    alignment: Alignment.centerRight,
                    child: RaisedButton.icon(
                      onPressed: (){
                        controlerQRPhone.text == null || controlerQRPhone.text == ''
                          ? 
                        showAlertDialog(context, 'Error', 'Debe digitar el texto.')
                          : 
                        Navigator.of(context).push(
                            MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                              return QRCodeCreator(tipo: 'controlerQR_Phone', mensaje: controlerQRPhone, file: foto);
                            }
                          )
                        );
                      },
                      icon: Icon(Icons.save),
                      label: Text('Crear QR'),
                      textTheme: ButtonTextTheme.accent,
                    )
                  )

                ],
              )
              ),
          ), //Text('ExpandablePaneltiene una serie de propiedades para personalizar su comportamiento, pero está restringido al tener un título en la parte superior y un icono de expansión que se muestra como una flecha hacia abajo (a la derecha o a la izquierda). Si eso no es suficiente, se puede implementar widgets personalizados ampliables mediante el uso de una combinación de Expandable, ExpandableNotifiery ExpandableButton:', softWrap: true, ),
          tapHeaderToExpand: false,
          hasIcon: true,
        ),
      ),
    );
    
  }

  Widget cardQrSendSms(BuildContext context, TextEditingController controlerQRSendSms, File foto) {
    return  Card(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: ExpandablePanel(
          tapBodyToCollapse: false,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          // Cabecera ----- TEXTO
          header: Container(
            height: 30,
            alignment: Alignment.centerLeft,
            //color: Colors.black26,
            child: FlatButton.icon(
              icon: Icon(Icons.sms, color: Colors.lightBlue,),
              label: Text('MENSAJE SMS'),
              onPressed: (){},
            )
          ),
          //collapsed: Text('CUERPO', softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis),
          expanded: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: TextField(
                      keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: controlerQRSendSms,
                      maxLines: 1,
                      minLines: 1,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        labelText: 'Ingrese un número telefónico válido'
                      ),
                    ),
                  ),
                  Container(
                    //color: colorBlue,
                    alignment: Alignment.centerRight,
                    child: RaisedButton.icon(
                      onPressed: (){
                        controlerQRSendSms.text == null || controlerQRSendSms.text == ''
                          ? 
                        showAlertDialog(context, 'Error', 'Debe digitar el texto.')
                          : 
                        Navigator.of(context).push(
                            MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                              return QRCodeCreator(tipo: 'controlerQR_SendSms', mensaje: controlerQRSendSms, file: foto);
                            }
                          )
                        );
                      },
                      icon: Icon(Icons.save),
                      label: Text('Crear QR'),
                      textTheme: ButtonTextTheme.accent,
                    )
                  )

                ],
              )
              ),
          ), //Text('ExpandablePaneltiene una serie de propiedades para personalizar su comportamiento, pero está restringido al tener un título en la parte superior y un icono de expansión que se muestra como una flecha hacia abajo (a la derecha o a la izquierda). Si eso no es suficiente, se puede implementar widgets personalizados ampliables mediante el uso de una combinación de Expandable, ExpandableNotifiery ExpandableButton:', softWrap: true, ),
          tapHeaderToExpand: false,
          hasIcon: true,
        ),
      ),
    );
    
  }

  Widget cardQrSendEmail(BuildContext context, TextEditingController controlerQRSendEmail, File foto) {
    return  Card(
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: ExpandablePanel(
          tapBodyToCollapse: false,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          // Cabecera ----- TEXTO
          header: Container(
            height: 30,
            alignment: Alignment.centerLeft,
            //color: Colors.black26,
            child: FlatButton.icon(
              icon: Icon(Icons.alternate_email, color: Colors.lightBlue,),
              label: Text('CORREO ELECTRONICO'),
              onPressed: (){},
            )
          ),
          //collapsed: Text('CUERPO', softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis),
          expanded: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: TextFormField(
                      validator: (value) {
                        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regExp = new RegExp(pattern);
                        if (value.length == 0) {
                          return "Ingrese un email.";
                        } else if (!regExp.hasMatch(value)) {
                          return "Email inválido";
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      //textAlignVertical: TextAlignVertical.top,
                      controller: controlerQRSendEmail,
                      maxLines: 1,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black12),
                        hintText: 'correo@midominio.com',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                        labelText: 'Ingrese un correo electrónico válido'
                      ),
                    ),
                  ),
                  Container(
                    //color: colorBlue,
                    alignment: Alignment.centerRight,
                    child: RaisedButton.icon(
                      onPressed: (){
                        print('======================================>' + _formKey.currentState.validate().toString() );
                        if ( _formKey.currentState.validate() ) {
                          controlerQRSendEmail.text == null || controlerQRSendEmail.text == ''
                            ? 
                          showAlertDialog(context, 'Error', 'Debe digitar el correo electrónico.')
                            : 
                          Navigator.of(context).push(
                              MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                                return QRCodeCreator(tipo: 'controlerQR_SendEmail', mensaje: controlerQRSendEmail, file: foto);
                              }
                            )
                          );
                        }
                      },
                      icon: Icon(Icons.save),
                      label: Text('Crear QR'),
                      textTheme: ButtonTextTheme.accent,
                    )
                  )

                ],
              )
              ),
          ), //Text('ExpandablePaneltiene una serie de propiedades para personalizar su comportamiento, pero está restringido al tener un título en la parte superior y un icono de expansión que se muestra como una flecha hacia abajo (a la derecha o a la izquierda). Si eso no es suficiente, se puede implementar widgets personalizados ampliables mediante el uso de una combinación de Expandable, ExpandableNotifiery ExpandableButton:', softWrap: true, ),
          tapHeaderToExpand: false,
          hasIcon: true,
        ),
      ),
    );
    
  }

  limpiarCampos() {
    controlerQRTexto.clear();
    controlerQRLink.clear();
    controlerQRPhone.clear();
    controlerQRSendEmail.clear();
    controlerQRSendSms.clear();
  }

}
