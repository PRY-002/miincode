import 'package:flutter/material.dart';
import 'package:miincode/src/utils/utils.dart';
import 'package:miincode/src/views/account/login.dart';
import 'package:miincode/src/widgets/appbar.dart';
import 'package:qrcode_plugin/qrcode_plugin.dart';

class CameraPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CameraPageState();
  }
}

class CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CameraController cameraController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    availableCameras().then((cameras) {
      initCamera(cameras[0]);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera(cameraController.description);
    }
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void initCamera(CameraDescription description) {
    cameraController?.dispose();
    cameraController = CameraController(description, ResolutionPreset.high,
        onScanSuccess: (content) {
      showInSnackBar(content);
    });

    cameraController.addListener(() {
      if (mounted) {
        setState(() {
          if (cameraController.value.hasError) {
            showInSnackBar(
                'Camera error ${cameraController.value.errorDescription}');
          }
        });
      }
    });

    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:  myAppBar(context, 'ESCANEAR'),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          _buildBody(context),
          Container(
            alignment: Alignment.bottomRight,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 9,
                  child: Text('')
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    //height: double.infinity,
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    //color: Colors.lime,
                    alignment: Alignment.bottomRight,
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          tooltip: 'RESTAURAR',
                          icon: Icon(Icons.play_circle_outline, color: Colors.white),
                          iconSize: 35,
                          onPressed: () {
                            cameraController.startPreview();
                          },
                        ),
                        IconButton(
                          tooltip: 'CAPTURAR',
                          icon: Icon(Icons.linked_camera, color: Colors.white),
                          iconSize: 35,
                          onPressed: () {
                            cameraController.stopPreview();
                          },
                        ),
                      ],
                    ),
                  )
                )
              ],
            )
          ),
          
          Row(
            children: <Widget>[
              
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (cameraController == null || !cameraController.value.isInitialized) {
      return CircularProgressIndicator();
    }

    return Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 100/100, //cameraController.value.aspectRatio,
                  child: CameraPreview(cameraController),
                ),
              ),
            ],
          )
        ),

      ],
    );
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}