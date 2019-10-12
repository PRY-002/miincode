import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:miincode/src/providers/ws.dart';
import 'package:http/http.dart' as http;
import 'package:miincode/src/utils/utils.dart';
import 'package:miincode/src/widgets/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(History());

var logger = Logger(printer: PrettyPrinter());
var loggerNoStack = Logger(printer: PrettyPrinter(methodCount: 0));



class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List data;
  int idUsu;

  Future<String> loadCodigos(int idUsuario) async {
    

   try {
      final url = urlCodigosListXIdUsuario + idUsuario.toString();
      final resp = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      if (resp.statusCode < 200 || resp.statusCode > 400 || json == null) {
        logger.w(throw new Exception(
            "ERROR! El servicio presento un error en la conexión: " +
                resp.statusCode.toString()));
      }

      setState(() {
        var extractdata = json.decode(resp.body);
        data = extractdata["data"];
      });

    } catch (e) {
      logger.w(e.toString());
    }
  }

  @override
  void  initState() {
    super.initState();
    //this.loadCodigos(idUsu);
    _funcionObtieneID();
    
  }

  _funcionObtieneID() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
   
    setState(() {
       idUsu = sp.getInt('spId');
       
        
    });
print('-------------> 002' + idUsu.toString());
    this.loadCodigos(idUsu);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: myAppBar(context, 'HISTORIAL'),
      body: _items(context),
    );
  }

  Widget _items (BuildContext context) {
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, i) {
      return Container(
        //color: Colors.black54,
        child: Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: ( direccion ){
            //productosProvider.borrarProducto(data[i]['id']);
          },
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 2, 5, 1),
              child: Card(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: ( data[i]['ruta_url'] == null )
                              ? Image(image: AssetImage('assets/no-image.png'))
                              : FadeInImage(
                                image: NetworkImage( data[i]['ruta_url'] ),
                                placeholder: AssetImage('assets/jar-loading.gif'),
  //                              height: 100.0,
                                //width: 100.0, //double.infinity,
                                fit: BoxFit.fill,
                              ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            height: 100,
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            color: Colors.green[50],
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text( new DateFormat("dd-MM-yyyy").format(DateTime.parse(data[i]['fec_creacion'])),
                                      //data[i]['fec_creacion'],
                                      textAlign: TextAlign.left, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                //Text( data[i]['usuarios_id'] == '' ? 'NO SE REGISTRO ID' : data[i]['usuarios_id'].toString() ),
                                recortaMsj(data[i]['mensaje'].toString())//Text( data[i]['mensaje'], style: TextStyle(fontSize: 8), )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                                icon: Icon(Icons.remove_red_eye, color: Colors.black, size: 25,),
                                onPressed: (){
                                  showPopUp2(context, data, i);
                                },
                              ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ),
      );
  
      }
    );
  }

}

Widget recortaMsj(String msj) {
  String _msj;
  if ( msj.length > 80 ) {
    _msj = msj.substring(0, 80) + ' ...';
  } else {
    _msj = msj;
  }
  return Text( _msj );
}