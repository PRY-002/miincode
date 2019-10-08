import 'package:flutter/material.dart';

//void main() => runApp(new miBotonDesplegable());
bool _isExpanded = true;
class miBotonDesplegable extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<miBotonDesplegable> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
            body: new ListView(
                children: <Widget>[
                  new ExpansionPanelList(
                    expansionCallback: (int panelIndex, bool isExpanded) {
                      setState(() {
                        _isExpanded = !isExpanded;
                      });
                    },
                    children: <ExpansionPanel>[
                      new ExpansionPanel(
                          headerBuilder: (BuildContext context, bool isExpanded) => const Text("Test"),
                          body: TextField(
                            showCursor: true,
                          ),
                          isExpanded: _isExpanded,
                      ),
                    ],
                  ),
                ],
            ),
        );
  }
}