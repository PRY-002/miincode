import 'dart:convert';

UsuarioRegistrarModel usuarioRMFromJson(String str) => UsuarioRegistrarModel.fromJson(json.decode(str));
String usuarioRmToJson(UsuarioRegistrarModel data) => json.encode(data.toJson());

class UsuarioRegistrarModel {  
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

    UsuarioRegistrarModel({
      this.uid,
      this.email,
      this.nombres,
      this.password,
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

    factory UsuarioRegistrarModel.fromJson(Map<String, dynamic> json) {
      return UsuarioRegistrarModel( 
        uid                : json['uid'],
        email              : json['email'],
        password           : json['password'],
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