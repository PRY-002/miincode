import 'package:flutter/material.dart';
import 'package:miincode/src/utils/utils.dart';

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
          showAlertDialogRedireccionableOpc_SIno(context, 'Mensaje', 'Seguro que desea Salir...?', 'login');
        },
      )
    ],
  );
} 