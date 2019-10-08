import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) => UsuarioModel.fromJson(json.decode(str));
String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {

    String id;
    String uid;
    String email;
    String nombres;
    String apepat;
    String apemat;
    String nromovil;
    String disponible;
    String fotoUrl;
    String fecnac;
    String genero;
    String dni;

    UsuarioModel({
        this.id,
        this.uid = '',
        this.email = '',
        this.nombres = '',
        this.apepat = '',
        this.apemat = '',
        this.nromovil = '',
        this.disponible = '',
        this.fotoUrl = '',
        this.fecnac = '',
        this.genero = '',
        this.dni = '',
    });

    factory UsuarioModel.fromJson(Map<String, dynamic> json) => new UsuarioModel(
        id          : json["id"],
        uid         : json["uid"],
        email       : json["email"],
        nombres     : json["nombres"],
        apepat      : json["apepat"],
        apemat      : json["apemat"],
        nromovil    : json["nromovil"],
        disponible  : json["disponible"],
        fotoUrl     : json["fotoUrl"],
        fecnac      : json["fecnac"],
        genero      : json["genero"],
        dni         : json["dni"],
    );

    Map<String, dynamic> toJson() => {
        "id"          : id,
        "uid"         : uid,
        "email"       : email,
        "nombres"     : nombres,
        "apepat"      : apepat,
        "apemat"      : apemat,
        "nromovil"    : nromovil,
        "disponible"  : disponible,
        "fotoUrl"     : fotoUrl,
        "fecnac"      : fecnac,
        "genero"      : genero,
        "dni"         : dni,
    };
}
