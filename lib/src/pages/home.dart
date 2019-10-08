import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/views/code/ajustes.dart';
import 'package:miincode/src/views/code/create/qr_create.dart';
import 'package:miincode/src/views/code/fetchpost.dart';
import 'package:miincode/src/views/code/history.dart';
import 'package:miincode/src/views/code/read/code_reader.dart';
import 'package:countdown_flutter/countdown_flutter.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          //color: Colors.red,
          child: Column(
          children: <Widget>[
            Expanded(child: _callPage(currentIndex)),
          ],
        )),
        bottomNavigationBar: _crearBottomNavigationBar());
  }

  Widget _crearBottomNavigationBar() {
    try {
      return BottomNavigationBar(
        fixedColor: Colors.red,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.library_add),
            title: Text('Crear'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.crop_free),
            title: Text('Escanear'),
          ),
          
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.history),
            title: Text('Historial'),
          ),
          
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.settings),
            title: Text('Ajustes'),
          )

        ],
      );  
    } catch (e) {
      logger.w(e.toString());
    }
  }

  _callPage(int paginaActual) {
    try {
      switch (paginaActual) {
        case 0:
          return QRCreate();
        case 1:
          return CameraPage();
        case 2:
          return History(); // fetchPost();
        case 3:
          return MyAppFetchPost(); //Ajustes(); //Test();
      }      
    } catch (e) {
      logger.w(e.toString());
    }
  }
}
