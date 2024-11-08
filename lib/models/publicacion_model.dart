class Publicacion {
  final int id;
  final int userId;
  final String categoria;
  final String contenido;
  final List<String> imagenes;
  final String userNombre;
  final String? videoLink; // Añadir esta línea

  Publicacion({
    required this.id,
    required this.userId,
    required this.categoria,
    required this.contenido,
    required this.imagenes,
    required this.userNombre,
    this.videoLink, // Añadir esta línea
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['images'] != null && json['images'].length > 0) {
      images = List<String>.from(json['images'].map((image) => image['image_path']).toList());
    }

    return Publicacion(
      id: json['id'],
      userId: json['user_id'],
      categoria:json['categoria'],
      contenido: json['content'],
      imagenes: images,
      userNombre: json['user']['name'],
      videoLink: json['video_link'], // Añadir esta línea
    );
  }
}
