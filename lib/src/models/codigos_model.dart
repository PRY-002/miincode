class CodigosModel  {

  final List<CodigosModelData> data;

  CodigosModel({ this.data  });

  factory CodigosModel.fromJson(Map<String, dynamic> parsedJson) {
    return CodigosModel(
      data: parsedJson['data']
    );
  }
}

class CodigosModelData {
  int id;
  int usuarios_id;
  String mensaje;
  String ruta_url;
  String fec_creacion;
  String fec_actualizacion;
  bool estado;

  CodigosModelData({
    this.id,
    this.usuarios_id,
    this.mensaje,
    this.ruta_url,
    this.fec_creacion,
    this.fec_actualizacion,
    this.estado
  });

  factory CodigosModelData.fromJson(Map<String, dynamic> parsedJson) {
    return CodigosModelData(
      id                    : parsedJson['id'],
      usuarios_id           : parsedJson['usuarios_id'],
      mensaje               : parsedJson['mensaje'],
      ruta_url              : parsedJson['ruta_url'],
      fec_creacion          : parsedJson['fec_creacion'],
      fec_actualizacion     : parsedJson['fec_actualizacion'],
      estado                : parsedJson['estado'],
    );
  }

}
