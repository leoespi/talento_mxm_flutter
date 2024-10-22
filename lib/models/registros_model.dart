class Cesantia {
  final int id;
  final String imagePath;

  Cesantia({required this.id, required this.imagePath});

  factory Cesantia.fromJson(Map<String, dynamic> json) {
    return Cesantia(
      id: json['id'],
      imagePath: json['image_path'],
    );
  }
}


class Incapacidad {
  final int id;
  final String imagePath;

  Incapacidad({required this.id, required this.imagePath});

  factory Incapacidad.fromJson(Map<String, dynamic> json) {
    return Incapacidad(
      id: json['id'],
      imagePath: json['image_path'],
    );
  }
}
