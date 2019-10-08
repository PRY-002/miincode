import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:miincode/src/utils/utils_conectividad.dart';
import 'package:miincode/src/views/code/create/qr_code_creater.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool condicion1 = true;
// Utilizado en 'qr_create.dart' ----------------------------------- INI

  Widget card(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('BUY TICKETS'),
                    onPressed: () {/* ... */},
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () {/* ... */},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardQrTexto(BuildContext context, TextEditingController controlerQR_Texto, File foto) {
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
                      controller: controlerQR_Texto,
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
                        controlerQR_Texto.text == null || controlerQR_Texto.text == ''
                          ? 
                        showAlertDialog_1(context, 'IMPORTANTE', 'Debe digitar el texto.')
                          : 
                        Navigator.of(context).push(
                            MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                              return QRCodeCreator(tipo: 'controlerQR_Texto', mensaje: controlerQR_Texto, file: foto);
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

  Widget cardQrLink(BuildContext context, TextEditingController controlerQR_Link, File foto) {
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
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: controlerQR_Link,
                      maxLines: 1,
                      minLines: 1,
                      decoration: InputDecoration(
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
                        controlerQR_Link.text == null || controlerQR_Link.text == ''
                          ? 
                        showAlertDialog_1(context, 'IMPORTANTE', 'Debe digitar el texto.')
                          : 
                        Navigator.of(context).push(
                            MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                              return QRCodeCreator(tipo: 'controlerQR_Link', mensaje: controlerQR_Link, file: foto);
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

  Widget cardQrPhone(BuildContext context, TextEditingController controlerQR_Phone, File foto) {
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
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: controlerQR_Phone,
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
                        controlerQR_Phone.text == null || controlerQR_Phone.text == ''
                          ? 
                        showAlertDialog_1(context, 'IMPORTANTE', 'Debe digitar el texto.')
                          : 
                        Navigator.of(context).push(
                            MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                              return QRCodeCreator(tipo: 'controlerQR_Phone', mensaje: controlerQR_Phone, file: foto);
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

  Widget cardQrSendSms(BuildContext context, TextEditingController controlerQR_SendSms, File foto) {
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
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: controlerQR_SendSms,
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
                        controlerQR_SendSms.text == null || controlerQR_SendSms.text == ''
                          ? 
                        showAlertDialog_1(context, 'IMPORTANTE', 'Debe digitar el texto.')
                          : 
                        Navigator.of(context).push(
                            MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                              return QRCodeCreator(tipo: 'controlerQR_SendSms', mensaje: controlerQR_SendSms, file: foto);
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

  Widget cardQrSendEmail(BuildContext context, TextEditingController controlerQR_SendEmail, File foto) {
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
                    child: TextField(
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: controlerQR_SendEmail,
                      maxLines: 1,
                      minLines: 1,
                      decoration: InputDecoration(
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
                        controlerQR_SendEmail.text == null || controlerQR_SendEmail.text == ''
                          ? 
                        showAlertDialog_1(context, 'IMPORTANTE', 'Debe digitar el texto.')
                          : 
                        Navigator.of(context).push(
                            MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                              return QRCodeCreator(tipo: 'controlerQR_SendEmail', mensaje: controlerQR_SendEmail, file: foto);
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

// =====================================================================================================
  Widget cardButtonText(BuildContext context, String _titulo, Color _colorIcon, Icon _icon, TextEditingController _txt, File fotito) {
    return Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 15, 5, 10),
          child: Column(
            children: <Widget>[
              Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.format_align_justify,
                          color: _colorIcon, size: 25),
                      Icon(Icons.arrow_drop_up, color: Colors.grey, size: 25),
                      Icon(Icons.arrow_drop_down, color: Colors.grey, size: 25),
                      Icon(Icons.link, color: _colorIcon, size: 25),
                    ],
                  )),
              Expanded(
                flex: 9,
                child: TextField(
                  controller: _txt,
                  expands: false,
                  maxLines: 5,
                  minLines: 3,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                    labelText: _titulo,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                    onPressed: () {
                      _txt.text == null || _txt.text == ''
                          ? showAlertDialog_1(
                              context, 'IMPORTANTE', 'Debe digitar el texto.')
                          : Navigator.of(context).push(MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                              return Container(); //QRCodeCreator(tipo: , mensaje: _txt, file: fotito);
                            }));
                    },
                    icon: Icon(Icons.chevron_right, color: _colorIcon,size: 35,
                    )
                ),
              ),
            ],
          ),
            ],
          ),
          ),
      ),
    );
  }

  Widget cardButtonSeleccionaImage(BuildContext context, File image, Function picker, Color colorPurple) {
    return Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 15, 5, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Center(
                    //child: image == null ? Text('Seleccione una imagen', style: TextStyle(color: Colors.purple),) : Image.file(image)
                    child: image == null
                        ? Text(
                            'Seleccione una imagen de la galería.',
                            style: TextStyle(color: Colors.purple),
                          )
                        : Column(
                            children: <Widget>[
                              Image.file(image, width: 300),
                            ],
                          )),
              ),
              Expanded(
                  flex: 2,
                  child: image == null
                      ? IconButton(
                          onPressed: picker,
                          icon: Icon(
                            Icons.add_photo_alternate,
                            color: colorPurple,
                            size: 35,
                          ))
                      : Container(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                  onPressed: picker,
                                  icon: Icon(
                                    Icons.image,
                                    color: colorPurple,
                                    size: 35,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    showAlertDialog_1(context, 'Generar',
                                        'Muy pronto estara listo el CODIGO QR de la imagen.');
                                  },
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color: colorPurple,
                                    size: 35,
                                  )),
                            ],
                          ),
                        )),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardButtonImage(BuildContext context, dynamic metodo, File imagen, Color _colorIcon, Icon _icon, TextEditingController _txt) {
    return Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 15, 5, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 10,
                  child: imagen == null
                      ? Text('No hay imagen para mostrar.')
                      : Column(
                          children: <Widget>[
                            //Image.file(imagen, width: 150),
                            Text(imagen.path)
                          ],
                        )),
              Expanded(
                flex: 2,
                child: IconButton(
                    onPressed: () {
                      metodo();
                    },
                    icon: Icon(
                      Icons.chevron_right,
                      color: _colorIcon,
                      size: 35,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
