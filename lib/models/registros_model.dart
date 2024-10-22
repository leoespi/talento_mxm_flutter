class Cesantia {
  final int id;
  final int userId;
  final String tipoincapacidadreportada;
  final int diasIncapacidad;
  final DateTime fechaInicioIncapacidad;
  final String entidadAfiliada;
  final String imagePath;

  Cesantia({required this.id, required this.userId, required this.tipoincapacidadreportada, required this.diasIncapacidad, required this.fechaInicioIncapacidad, 
  required this.entidadAfiliada, required this.imagePath});

  factory Cesantia.fromJson(Map<String, dynamic> json) {
    return Cesantia(
      id: json['id'],
      userId: json['user_id'],
      tipoincapacidadreportada: json['tipoincapacidadreportada'],
      diasIncapacidad: json['diasIncapacidad'],
      fechaInicioIncapacidad: DateTime.parse(json['fecha_inicio_incapacidad']),
      entidadAfiliada: json['entidad_afiliada'],
      imagePath: json['image_path'],
    );
  }
}


class Incapacidad {
  final int id;
  final int userId;
  final String tipocesantiareportada;
  final String imagePath;
  

  Incapacidad({required this.id, required this.imagePath, required this.tipocesantiareportada, required this.userId});

  factory Incapacidad.fromJson(Map<String, dynamic> json) {
    return Incapacidad(
      id: json['id'],
      userId: json['user_id'],
      tipocesantiareportada: json['tipocesantiareportada'],
      imagePath: json['image_path'],
    );
  }
}
