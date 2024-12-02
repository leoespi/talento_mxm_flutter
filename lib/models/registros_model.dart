class Cesantia {
  final int id;
  final int userId;
  final String tipoCesantiaReportada;
  final String estado;
  final String? justificacion;
  final DateTime createdAt;
  final List<String> imagenes;
  final List<String> documentos; // Agregar esta línea


  Cesantia({
    required this.id,
    required this.userId,
    required this.tipoCesantiaReportada,
    required this.estado,
    this.justificacion,
    required this.createdAt,
    required this.imagenes,
    required this.documentos, // Agregar esta línea

  });

  factory Cesantia.fromJson(Map<String, dynamic> json) {
    // Extraer las imágenes de la lista
    List<String> images = [];
    if (json['images']  != null && json['images'].length > 0) {
      images = List<String>.from(json['images'].map((image) => image['image_path']).toList());
    }

     List<String> docs = [];
    if (json['documentos'] != null && json['documentos'].isNotEmpty) {
      docs = List<String>.from(json['documentos'].map((doc) {
        String fullPath = doc['documentos'] as String;
        return fullPath.split('/').last; // Solo extraer el nombre del documento
      }).toList());
    }

    return Cesantia(
      id: json['id'],
      userId: json['user_id'],
      tipoCesantiaReportada: json['tipo_cesantia_reportada'] ?? 'Sin tipo',
      estado: json['estado'] ?? 'Sin estado',
      justificacion: json['justificacion'],
      createdAt: DateTime.parse(json['created_at']),
      imagenes: images,
      documentos: docs,
    );
  }
}
class Incapacidad {
  final int id;
  final int userId;
  final String tipoIncapacidadReportada;
  final int diasIncapacidad;
  final DateTime fechaInicioIncapacidad;
  final bool? aplicaCobro;
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
      pVenta: json['p_venta']?.toString() ?? '',  // Convertir a String si es necesario
      categoriaSolicitud: json['categoria_solicitud']?.toString() ?? '',  // Convertir a String si es necesario
      tiempoRequerido: json['tiempo_requerido']?.toString() ?? '',  // Convertir a String si es necesario
      unidadTiempo: json['unidad_tiempo']?.toString() ?? '',  // Convertir a String si es necesario
      hora: json['hora']?.toString() ?? '',  // Convertir a String si es necesario
      fechaPermiso: DateTime.parse(json['fecha_permiso']),
      fechaSolicitud: DateTime.parse(json['fecha_solicitud']),
      justificacion: json['justificacion'] ?? '',  // Asignar un valor por defecto si es null
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
}


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



