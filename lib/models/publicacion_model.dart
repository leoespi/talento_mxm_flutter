class Publicacion {
  final int id;
  final int userId;
  final String titulo;
  final String contenido;
  final String imagen;
  final String userNombre;

  Publicacion({
    required this.id,
    required this.userId,
    required this.titulo,
    required this.contenido,
    required this.imagen,
    required this.userNombre,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['id'],
      userId: json['user_id'],
      titulo: json['titulo'],
      contenido: json['contenido'],
      imagen: json['imagen'],
      userNombre: json['user']['name'],
    );
  }
}