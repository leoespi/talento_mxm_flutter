import 'dart:convert';

class Solicitud {
  final int userId;
  final String pVenta;
  final String categoriaSolicitud;
  final String tiempoRequerido;
  final String unidadTiempo;
  final String hora;
  final DateTime fechaPermiso;
  final DateTime fechaSolicitud;
  final String justificacion;

  Solicitud({
    required this.userId,
    required this.pVenta,
    required this.categoriaSolicitud,
    required this.tiempoRequerido,
    required this.unidadTiempo,
    required this.hora,
    required this.fechaPermiso,
    required this.fechaSolicitud,
    required this.justificacion,
  });

  // Método para convertir un mapa JSON en una instancia de Solicitud
  factory Solicitud.fromJson(Map<String, dynamic> json) {
    return Solicitud(
      userId: json['user_id'],
      pVenta: json['p_venta'],
      categoriaSolicitud: json['categoria_solicitud'],
      tiempoRequerido: json['tiempo_requerido'],
      unidadTiempo: json['unidad_tiempo'],
      hora: json['hora'],
      fechaPermiso: DateTime.parse(json['fecha_permiso']),
      fechaSolicitud: DateTime.parse(json['fecha_solicitud']),
      justificacion: json['justificacion'],
    );
  }

  // Método para convertir una instancia de Solicitud a JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'p_venta': pVenta,
      'categoria_solicitud': categoriaSolicitud,
      'tiempo_requerido': tiempoRequerido,
      'unidad_tiempo': unidadTiempo,
      'hora': hora,
      'fecha_permiso': fechaPermiso.toIso8601String(),
      'fecha_solicitud': fechaSolicitud.toIso8601String(),
      'justificacion': justificacion,
    };
  }

  // Método toString() para mostrar la instancia como texto
  @override
  String toString() {
    return 'Solicitud(userId: $userId, pVenta: $pVenta, categoriaSolicitud: $categoriaSolicitud, tiempoRequerido: $tiempoRequerido, unidadTiempo: $unidadTiempo, hora: $hora, fechaPermiso: $fechaPermiso, fechaSolicitud: $fechaSolicitud, justificacion: $justificacion)';
  }
}
