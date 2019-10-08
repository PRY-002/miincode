import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));
String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {

    String id;                // ID autogenerado de cada Producto
    String titulo;            // Descripcion del mensje encriptado
    double valor;             // valor aun no definido.
    bool disponible;          // Estado de la descripción
    String fotoUrl;           // Url de la imagen QR generado
    String fechaCreacion;     // Fecha de generación del QR
    int idUsuario;         // ID del usuario que genero el QR

    ProductoModel({
        this.id,
        this.titulo         = '',
        this.valor          = 0.0,
        this.disponible     = true,
        this.fotoUrl        = '',
        this.fechaCreacion  = '',
        this.idUsuario      = null,
    });

    factory ProductoModel.fromJson(Map<String, dynamic> json) => new ProductoModel(
        //id              : json["id"],
        titulo          : json["titulo"],
        valor           : json["valor"],
        disponible      : json["disponible"],
        fotoUrl         : json["fotoUrl"],
        fechaCreacion   : json["fechaCreacion"],
        idUsuario       : json["idUsuario"],
    );

    Map<String, dynamic> toJson() => {
        "id"            : id,
        "titulo"        : titulo,
        "valor"         : valor,
        "disponible"    : disponible,
        "fotoUrl"       : fotoUrl,
        "fechaCreacion" : fechaCreacion,
        "idUsuario"     : idUsuario,
    };
}
