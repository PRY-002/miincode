import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miincode/src/utils/utils.dart';

bool condicion1 = true;

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
                          ? showAlertDialog(
                              context, 'Mensaje', 'Debe digitar el texto.')
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
                                    showAlertDialog(context, 'Generar',
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

