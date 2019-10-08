import 'dart:convert';

Codigos codigosFromJson(String str) => Codigos.fromJson(json.decode(str));
String codigosToJson(Codigos data) => json.encode(data.toJson());

class Codigos {
  int id;
  int usuarios_id;
  String mensaje;
  String ruta_url;
  String fec_creacion;
  String fec_actualizacion;
  bool estado;

  Codigos({
    this.id,
    this.usuarios_id,
    this.mensaje,
    this.ruta_url,
    this.fec_creacion,
    this.fec_actualizacion,
    this.estado
  });
/** {'id':4,
 * 'usuarios_id':0,
 * 'mensaje':'mensaje desde api',
 * 'ruta_url':'ruta_url',
 * 'fec_creacion':'01-01-2019',
 * 'fec_actualizacion':'01-01-2019',
 * 'estado':true} */
  factory Codigos.fromJson(Map<String, dynamic> json) {
    return Codigos(
      id                    : json['id'],
      usuarios_id           : json['usuarios_id'],
      mensaje               : json['mensaje'],
      ruta_url              : json['ruta_url'],
      fec_creacion          : json['fec_creacion'],
      fec_actualizacion     : json['fec_actualizacion'],
      estado                : json['estado'],
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