import 'dart:convert';

CodigosModel codigosFromJson(String str) => CodigosModel.fromJson(json.decode(str));
String codigosToJson(CodigosModel data) => json.encode(data.toJson());

class CodigosModel {
  int id;
  int usuarios_id;
  String mensaje;
  String ruta_url;
  String fec_creacion;
  String fec_actualizacion;
  bool estado;

  CodigosModel({
    this.id,
    this.usuarios_id,
    this.mensaje,
    this.ruta_url,
    this.fec_creacion,
    this.fec_actualizacion,
    this.estado
  });

  factory CodigosModel.fromJson(Map<String, dynamic> json) {
    return CodigosModel(
      id                : json['id'],
      usuarios_id       : json['usuarios_id'],
      mensaje           : json['mensaje'],
      ruta_url          : json['ruta_url'],
      fec_creacion      : json['fec_creacion'],
      fec_actualizacion : json['fec_actualizacion'],
      estado            : json['estado'],
    );
  }

  factory CodigosModel.fromJsonListado(Map<String, dynamic> json) {
    return CodigosModel(
      mensaje           : json["mensaje"],
      ruta_url          : json["ruta_url"],
      fec_creacion      : json["fec_creacion"],
      fec_actualizacion : json["fec_actualizacion"],
      estado            : json["estado"]
    );
  }
  
  Map<String, dynamic> toJson() => {
    //"id"                : id,
    "usuarios_id"       : usuarios_id,
    "mensaje"           : mensaje,
    "ruta_url"          : ruta_url,
    "fec_creacion"      : fec_creacion,
    "fec_actualizacion" : fec_actualizacion,
    "estado"            : estado
  };
}