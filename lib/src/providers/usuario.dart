/*
import 'dart:convert';

import 'package:http/http.dart'

class UsuarioProvider {

  final String _firebaseToken = 'AIzaSyBTngGCG1I0MOOQOGsLQvR7XAciam8U_pA';

  Future nuevoUsuario (String email, String password) {
    final authData = {
      'email'     : email,
      'password'  : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode( authData )
    );

    Map<String, dynamic> decodedResp = json.decode(source)

  }
}*/