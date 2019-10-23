import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loggedIn = false;
  bool _loading = false;

  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;
  
  void login() async {
    _loading = true;
    //_loggedIn = true;
    notifyListeners();
    /*var user = await _handleSignIn();
    _loading = false;
    if (user != null) {_loggedIn = true;
      notifyListeners();
    } else {
      _loggedIn = false;
      notifyListeners();
    }*/
  }

  void logout() {
    _loading = false;
    //_loggedIn = false;
    notifyListeners();
    //_googleSignIn.signOut();
  }

  void logIn() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    
  }
/*Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    return user;
  }*/
}