import 'package:flutter/material.dart';
import 'package:miincode/src/pages/home.dart';
import 'package:miincode/src/providers/database_helper.dart';
import 'package:miincode/src/services/service_locator.dart';
import 'package:miincode/src/utils/utils_conectividad.dart';
import 'package:miincode/src/views/account/login.dart';
import 'package:miincode/src/views/account/login_state.dart';
import 'package:miincode/src/views/account/register.dart';
import 'package:miincode/src/views/code/fetchpost.dart';
import 'package:provider/provider.dart';

import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final dbHelper = DatabaseHelper.instance;


  @override
  Widget build(BuildContext context) {
    //assert(!_debugLocked);
    try {
      spCrearLimpiarVariablesSesion(context);
      return ChangeNotifierProvider<LoginState>(
        builder: (BuildContext context) => LoginState(),
        child: MaterialApp(
          color: Colors.red,
          debugShowCheckedModeBanner: false,
          title: 'LECTOR QR',
          //initialRoute: 'login',
          routes: {
            '/' : (BuildContext context) {
              var state = Provider.of<LoginState>(context);
              if ( state.isLoading()) {
                return Home();
              } else {
                return Login(); // MyAppFetchPost(); 
              }
            },
            'login'   : (BuildContext context) => Login(),
            'register': (BuildContext context) => Register(),
            'home'    : (BuildContext context) => Home()
          },
        ),
      );
    } catch (e) {
      logger.w(e.toString());
    }
  }
  
}
