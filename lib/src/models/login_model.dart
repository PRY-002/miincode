import 'dart:convert';

LoginModel loginFromJson(String str) => LoginModel.fromJson(json.decode(str));
String loginToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {  
    int id;
    String email;
    String password;

    LoginModel({
      this.id,
      this.email,
      this.password
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) {
      return LoginModel( 
        id                 : json['id'],
        email              : json['email'],
        password           : json['password']
      );
    }

    Map<String, dynamic> toJson() => {
      //id                 : json['id'],
      'email'              : email,
      'password'           : password
  };
}