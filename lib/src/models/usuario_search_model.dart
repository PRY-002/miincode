import 'dart:convert';

UsuarioSearchModel usuarioSearchModelFromJson(String str) => UsuarioSearchModel.fromJson(json.decode(str));
String usuarioSearchModelToJson(UsuarioSearchModel data) => json.encode(data.toJson());

class UsuarioSearchModel {  
    int id;
    String uid;
    String email;
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

    UsuarioSearchModel({
      this.id,
      this.uid,
      this.email,
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

    factory UsuarioSearchModel.fromJson(Map<String, dynamic> json) {
      return UsuarioSearchModel( 
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
}