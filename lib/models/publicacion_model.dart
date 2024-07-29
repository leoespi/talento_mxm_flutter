class Publicacion {
  final int id;
  final int userId;
  final String contenido;
  final List<String> imagenes;
  final String userNombre;
  final String? videoLink; // Agregar esta propiedad

  Publicacion({
    required this.id,
    required this.userId,
    required this.contenido,
    required this.imagenes,
    required this.userNombre,
    this.videoLink, // Agregar esta propiedad
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['images'] != null && json['images'].length > 0) {
      images = List<String>.from(json['images'].map((image) => image['image_path']).toList());
    }

    return Publicacion(
      id: json['id'],
      userId: json['user_id'],
      contenido: json['content'], // 'content' en el backend
      imagenes: images,
      userNombre: json['user']['name'], // 'user' -> 'name' en el backend
      videoLink: json['video_link'], // 'video_link' en el backend
    );
  }
}
