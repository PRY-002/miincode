
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/providers/codigos_provider.dart';
import 'package:miincode/src/views/code/ajustes.dart';
import 'package:miincode/src/widgets/appbar.dart';

CodigosProvider _codigosProvider = new CodigosProvider();
/* ----- LOGGER ---------------- */
var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));
/* ----- LOGGER ---------------- */

class HistoryCodigos extends StatefulWidget {

  @override
  _HistoryCodigosState createState() => _HistoryCodigosState();

}

class _HistoryCodigosState extends State<HistoryCodigos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context, 'CODIGOS - HISTORIAL'),
      body: Container(
        color: Colors.black,
        child: _crearListadoCodigos(),
      ),
    );
  }

  Widget _crearListadoCodigos() {

    try {
      return FutureBuilder(
        //future: _codigosProvider.listarCodigos(),
      );
    } catch (e) {
      logger.w(e.toString());
    }    

  }

}