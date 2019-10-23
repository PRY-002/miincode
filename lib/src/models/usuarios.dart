import 'dart:convert';

Usuarios usuariosFromJson(String str) => Usuarios.fromJson(json.decode(str));
Usuarios usuariosListFromJson(String str) => Usuarios.fromJsonList(json.decode(str));

String usuariosToJson(Usuarios data) => json.encode(data.toJson());
String editToJson(Usuarios data) => json.encode(data.toJsonEdit());
String loginToJson(Usuarios data) => json.encode(data.toJsonLogin());
String registerToJson(Usuarios data) => json.encode(data.toJsonRegister());

class Usuarios {  

    int id;
    String uid;
    String email;
    String password;
    String nombres;
    String apepat;
    String apemat;
    String fec_nacimiento;
    String genero;
    String dni;
    String url_foto;
    String nro_movil;
    String fec_creacion;
    String fec_actualizacion;
    bool estado;
    int perfiles_id;

    Usuarios({
      this.id,
      this.uid,
      this.email,
      this.password,     
      this.nombres,
      this.apepat,
      this.apemat,
      this.fec_nacimiento,
      this.genero,
      this.dni,
      this.url_foto,
      this.nro_movil,
      this.fec_creacion,
      this.fec_actualizacion,
      this.estado,
      this.perfiles_id
    });

    Usuarios.Register({
      this.uid,
      this.email,
      this.password,     
      this.nombres,
      this.apepat,
      this.apemat,
      this.fec_nacimiento,
      this.genero,
      this.dni,
      this.url_foto,
      this.nro_movil,
      this.fec_creacion,
      this.fec_actualizacion,
      this.estado,
      this.perfiles_id
    });

    factory Usuarios.fromJson(Map<String, dynamic> json) {
      return Usuarios( 
        id                 : json['id'],
        uid                : json['uid'],
        email              : json['email'],
        nombres            : json['nombres'],
        apepat             : json['apepat'],
        apemat             : json['apemat'],
        fec_nacimiento     : json['fec_nacimiento'],
        genero             : json['genero'],
        dni                : json['dni'],
        url_foto           : json['url_foto'],
        nro_movil          : json['nro_movil'],
        fec_creacion       : json['fec_creacion'],
        fec_actualizacion  : json['fec_actualizacion'],
        estado             : json['estado'],
        perfiles_id        : json['perfiles_id'],
      );
    }

    Map<String, dynamic> toJson() => {
      //id                 : json['id'],
      'uid'                : uid,
      'email'              : email,
      'nombres'            : nombres,
      'apepat'             : apepat,
      'apemat'             : apemat,
      'fec_nacimiento'     : fec_nacimiento,
      'genero'             : genero,
      'dni'                : dni,
      'url_foto'           : url_foto,
      'nro_movil'          : nro_movil,
      'fec_creacion'       : fec_creacion,
      'fec_actualizacion'  : fec_actualizacion,
      'estado'             : estado,
      'perfiles_id'        : perfiles_id,
  };

  factory Usuarios.fromJsonLogin(Map<String, dynamic> json) {
    return Usuarios( 
        id                 : json['id'],
        email              : json['email'],
        password           : json['password']
      );

  }
  
  factory Usuarios.fromJsonList(Map<String, dynamic> json) => new Usuarios(
      id              : json["id"],
      uid             : json["uid"],
      email           : json["email"],
      nombres         : json["nombres"],
      apepat          : json["apepat"],
      apemat          : json["apemat"],
      nro_movil       : json["nro_movil"],
      estado          : json["estado"],
      url_foto        : json["url_foto"],
      fec_nacimiento  : json["fec_nacimiento"],
      genero          : json["genero"],
      dni             : json["dni"],
  );

  Map<String, dynamic> toJsonEdit() => {
      "id"              : id,
      "uid"             : uid,
      "email"           : email,
      "nombres"         : nombres,
      "apepat"          : apepat,
      "apemat"          : apemat,
      "nro_movil"       : nro_movil,
      "estado"          : estado,
      "url_foto"        : url_foto,
      "fec_nacimiento"  : fec_nacimiento,
      "genero"          : genero,
      "dni"             : dni,
  };

  Map<String, dynamic> toJsonLogin() => {
    
      //id                 : json['id'],
      'email'              : email,
      'password'           : password
  };   

  Map<String, dynamic> toJsonRegister() => {
      'uid'                : uid,
      'email'              : email,
      'password'           : password,
      'nombres'            : nombres,
      'apepat'             : apepat,
      'apemat'             : apemat,
      'fec_nacimiento'     : fec_nacimiento,
      'genero'             : genero,
      'dni'                : dni,
      'url_foto'           : url_foto,
      'nro_movil'          : nro_movil,
      'fec_creacion'       : fec_creacion,
      'fec_actualizacion'  : fec_actualizacion,
      'estado'             : estado,
      'perfiles_id'        : perfiles_id,
  };


}