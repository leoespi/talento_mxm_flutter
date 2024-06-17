  import 'dart:convert';

  CesantiasModel cesantiasModelFromJson(String str) => CesantiasModel.fromJson(json.decode(str));

  String cesantiasModelToJson(CesantiasModel data) => json.encode(data.toJson());

  class CesantiasModel {
    CesantiasModel({
        this.id,
        required this.userId,
        required this.tipocesantiareportada,
      
        this.uuid,
        this.image,
    });

    int? id;
    int userId;
    String tipocesantiareportada;

    String? uuid;
    String? image;

    factory CesantiasModel.fromJson(Map<String, dynamic> json) => CesantiasModel(
          id: json["id"],
          userId: json["user_id"],
          tipocesantiareportada: json["tipo_cesantia_reportada"],
          
          uuid: json["uuid"],
          image: json["image"],
        );


    Map<String, dynamic> toJson() => {
          "id": id,
          "user_id": userId,
          "tipo_cesantia_reportada": tipocesantiareportada,
          "uuid": uuid,
          "image": image,
        };

  }

