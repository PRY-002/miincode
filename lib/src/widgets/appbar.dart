import 'package:flutter/material.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:miincode/src/views/account/login.dart';

Widget myAppBar (BuildContext context, String titulo){
  return AppBar(
    backgroundColor: Colors.black,
    title: Text(titulo),
    //centerTitle: true,
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.power_settings_new,
          color: Colors.red,
        ),
        onPressed: () {
          showAlertDialog_redireccionable(context, 'Mensaje', 'Seguro que desea Salir...?', 'login');
        },
      )
    ],
  );
} 