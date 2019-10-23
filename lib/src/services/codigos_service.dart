import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:miincode/src/providers/ws.dart';

var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));

Future loadCodigos2(int idUsuario) async {
  List data;

  try {
    logger.v('Iniciando lista de Codigos ');

    final url = urlCodigosListXIdUsuario + idUsuario.toString();
    logger.v('-------------------------> 001' + url);
    final resp = await http.get(url);
    if (resp.statusCode < 200 || resp.statusCode > 400 || json == null) {
      logger.w(throw new Exception(
          "ERROR! El servicio presento un error en la conexión: " +
              resp.statusCode.toString()));
    }
    var extractdata = json.decode(resp.body);
    data = extractdata["data"];

    logger.v('-------------------------> 001' + url);
    _createItem(data);

    return null;
  } catch (e) {
    logger.w(e.toString());
  }
}

Widget _createItem(List data) {
  return new Scaffold(
    appBar: new AppBar(
      title: new Text('Contact List'),
    ),
    body: new ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, i) {
        return new ListTile(
          title: new Text(data[i]["mensaje"]),
          subtitle: new Text(data[i]["mensaje"])
          /*leading: new CircleAvatar(
            backgroundImage:
                new NetworkImage(data[i]["picture"]["thumbnail"]),
          )
          */
        );
      }
    )
  );
}
