class Malla {
  final int userId;
  final String proceso;
  final String pVenta;
  final String documento; // El nombre del archivo o la URL del archivo

  Malla({
    required this.userId,
    required this.proceso,
    required this.pVenta,
    required this.documento,
  });

  // Método para convertir un objeto Malla a un mapa (para enviar al backend)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'proceso': proceso,
      'p_venta': pVenta,
      'documento': documento,
    };
  }

  // Método para crear un objeto Malla desde el JSON de respuesta
  factory Malla.fromJson(Map<String, dynamic> json) {
    return Malla(
      userId: json['user_id'],
      proceso: json['proceso'],
      pVenta: json['p_venta'],
      documento: json['documento'],
    );
  }
}
