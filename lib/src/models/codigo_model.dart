
import 'dart:convert';

CodigoModel codigoModelFromJson(String str) => CodigoModel.fromJson(json.decode(str));
String codigoModelToJson(CodigoModel data) => json.encode(data.toJson());

class CodigoModel {
  String usuarios_id;
  String mensaje;
  String ruta_url;
  String fec_creacion;
  String fec_actualizacion;
  int estado;

  CodigoModel({
    this.usuarios_id,
    this.mensaje            = '',
    this.ruta_url           = '',
    this.fec_creacion       = '',
    this.fec_actualizacion  = '',
    this.estado             = 1
  });

  factory CodigoModel.fromJson(Map<String, dynamic> json) => new CodigoModel(
    //usuarios_id         : json["usuarios_id"]
    mensaje               : json["mensaje"],
    ruta_url              : json["ruta_url"],
    fec_creacion          : json["fec_creacion"],
    fec_actualizacion     : json["fec_actualizacion"],
    estado                : json["estado"],
  );

  Map<String, dynamic> toJson() => {
    "usuarios_id"       : usuarios_id,
    "mensaje"           : mensaje,
    "ruta_url"          : ruta_url,
    "fec_creacion"      : fec_creacion,
    "fec_actualizacion" : fec_actualizacion,
    "estado"            : estado
  };
}