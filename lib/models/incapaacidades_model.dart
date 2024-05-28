import 'dart:convert';

IncapacidadModel incapacidadModelFromJson(String str) => IncapacidadModel.fromJson(json.decode(str));

String incapacidadModelToJson(IncapacidadModel data) => json.encode(data.toJson());

class IncapacidadModel {
  IncapacidadModel({
    this.id,
    required this.userId,
    required this.tipoincapacidadreportada,
    required this.diasIncapacidad,
    required this.fechaInicioIncapacidad,
    required this.entidadAfiliada,
    this.uuid,
    this.image,
  });

  int? id;
  int userId;
  String tipoincapacidadreportada;
  int diasIncapacidad;
  DateTime fechaInicioIncapacidad;
  String entidadAfiliada;
  String? uuid;
  String? image;

  factory IncapacidadModel.fromJson(Map<String, dynamic> json) => IncapacidadModel(
        id: json["id"],
        userId: json["user_id"],
        tipoincapacidadreportada: json["tipo_incapacidad_reportada"],
        diasIncapacidad: json["dias_incapacidad"],
        fechaInicioIncapacidad: DateTime.parse(json["fecha_inicio_incapacidad"]),
        entidadAfiliada: json["entidad_afiliada"],
        uuid: json["uuid"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "tipo_incapacidad_reportada": tipoincapacidadreportada,
        "dias_incapacidad": diasIncapacidad,
        "fecha_inicio_incapacidad": fechaInicioIncapacidad.toIso8601String(),
        "entidad_afiliada": entidadAfiliada,
        "uuid": uuid,
        "image": image,
      };
}
