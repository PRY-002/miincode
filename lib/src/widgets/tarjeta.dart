

import 'package:flutter/material.dart';
import 'package:miincode/src/utils/utils.dart';

class MyTarjeta extends StatelessWidget {
  final String nameCompany;
  final String nameProduct;
  final String nameExtImage;

  MyTarjeta({
    Key key,
    @required this.nameCompany,
    @required this.nameProduct,
    @required this.nameExtImage
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            width: 100,
            height: 120,
            //color: Colors.deepOrange,
          ),
          Card(
            child: InkWell(
              //splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                showAlertDialog(context, nameCompany, nameProduct);
              },
              child: Column(
                children: <Widget>[
                    Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(2, 2, 0, 0),
                    width: 90,  
                    height: 15,
                    //color: Colors.blue,
                    child: Text(
                      this.nameProduct,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                  Expanded(
                    child: Container(
                      //color: Colors.redAccent,
                      child: Image.asset('assets/productos/categorias/'+ this.nameExtImage),
                      //child: Image.network(this.nameExtImage, height: 100, width: 100),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    alignment: Alignment.center,
                    width: 90,
                    height: 23,
                    //color: Colors.red,
                    child: Text(
                      this.nameCompany,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
          // Boton en el CARD
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(0),
            width: 45,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 1,
                color: Colors.white,
                style: BorderStyle.solid
              )
            ),
            child: Text(
              'Probar', 
              style: TextStyle(
                color: Colors.white,
                fontSize: 10
              ),
            ),
          )
        ],
      )
    );
  }
}