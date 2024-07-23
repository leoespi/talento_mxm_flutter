class Publicacion {
  final int id;
  final int userId;
  final String contenido; // 'content' en el backend
  final String imagen; // 'image_path' en el backend
  final String userNombre; // 'user' -> 'name' en el backend

  Publicacion({
    required this.id,
    required this.userId,
    required this.contenido,
    required this.imagen,
    required this.userNombre,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['id'],
      userId: json['user_id'],
      contenido: json['content'], // Mismo nombre que 'titulo' por ahora
      imagen: json['images'].isNotEmpty ? json['images'][0]['image_path'] : '', // Tomando la primera imagen si hay alguna
      userNombre: json['user']['name'],
    );
  }
}
