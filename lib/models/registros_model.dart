class Cesantia {
  final int id;
  final int userId;
  final String tipoCesantiaReportada;
  final String estado;
  final String? justificacion;
  final DateTime createdAt;
  final List<String> imagenes;

  Cesantia({
    required this.id,
    required this.userId,
    required this.tipoCesantiaReportada,
    required this.estado,
    this.justificacion,
    required this.createdAt,
    required this.imagenes,
  });

  factory Cesantia.fromJson(Map<String, dynamic> json) {
    // Extraer las imágenes de la lista
    List<String> images = [];
    if (json['images']  != null && json['images'].length > 0) {
      images = List<String>.from(json['images'].map((image) => image['image_path']).toList());
    }

    return Cesantia(
      id: json['id'],
      userId: json['user_id'],
      tipoCesantiaReportada: json['tipo_cesantia_reportada'] ?? 'Sin tipo',
      estado: json['estado'] ?? 'Sin estado',
      justificacion: json['justificacion'],
      createdAt: DateTime.parse(json['created_at']),
      imagenes: images,
    );
  }
}
class Incapacidad {
  final int id;
  final int userId;
  final String tipoIncapacidadReportada;
  final int diasIncapacidad;
  final DateTime fechaInicioIncapacidad;
  final String? aplicaCobro;
  final String entidadAfiliada;
  final List<String> imagenes;
  final List<String> documentos; // Agregar esta línea

  Incapacidad({
    required this.id,
    required this.userId,
    required this.tipoIncapacidadReportada,
    required this.diasIncapacidad,
    required this.fechaInicioIncapacidad,
    this.aplicaCobro,
    required this.entidadAfiliada,
    required this.imagenes,
    required this.documentos, // Agregar esta línea
  });

  factory Incapacidad.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['images'] != null && json['images'].isNotEmpty) {
      images = List<String>.from(json['images'].map((image) => image['image_path'] as String).toList());
    }

    List<String> docs = [];
    if (json['documentos'] != null && json['documentos'].isNotEmpty) {
      docs = List<String>.from(json['documentos'].map((doc) {
        String fullPath = doc['documentos'] as String;
        return fullPath.split('/').last; // Solo extraer el nombre del documento
      }).toList());
    }

    return Incapacidad(
      id: json['id'],
      userId: json['user_id'],
      tipoIncapacidadReportada: json['tipo_incapacidad_reportada'] ?? 'Sin tipo',
      diasIncapacidad: json['dias_incapacidad'],
      fechaInicioIncapacidad: DateTime.parse(json['fecha_inicio_incapacidad']),
      aplicaCobro: json['aplica_cobro'],
      entidadAfiliada: json['entidad_afiliada'] ?? 'Sin entidad',
      imagenes: images,
      documentos: docs, // Agregar esta línea
    );
  }
}
