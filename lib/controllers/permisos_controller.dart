import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class PermisosController extends GetxController {
  final String apiUrl = 'http://10.0.2.2:8000/api/permisos'; // Asegúrate de que esta URL sea la correcta
  final box = GetStorage();  // Usamos GetStorage para obtener el token y el user_id

  Future<void> createPermiso({
    required String pventa,
    required String categoriasolicitud,
    required int tiempo,
    required String unidad,
    required String hora,
    required DateTime fechapermiso,
    required DateTime fechasolicitud,
    required String justificacion,
    
    required BuildContext context,
  }) async {
    try {
      // Recuperar token y user_id desde GetStorage (almacenamiento seguro)
      String? token = box.read('token'); // Asegúrate de que el token esté guardado
      int? userId = box.read('user_id'); // Recuperar el user_id del almacenamiento

      // Verificar que ambos existan
      if (token == null || userId == null) {
        print('Token o user_id no encontrado');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontró el token o el user_id.')),
        );
        return; // Detener la ejecución si no hay token o user_id
      }

      // Crear el cuerpo de la solicitud
      Map<String, dynamic> permisoData = {
        'user_id': userId, // Añadir el user_id a la solicitud
        'p_venta': pventa,
        'categoria_solicitud': categoriasolicitud,
        'tiempo_requerido': tiempo,
        'unidad_tiempo': unidad,
        'hora': hora,
        'fecha_permiso': fechapermiso.toIso8601String(),
        'fecha_solicitud': fechasolicitud.toIso8601String(),
        'justificacion': justificacion,
      };


      // Realizar la solicitud POST
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Agregar el token en la cabecera
        },
        body: json.encode(permisoData),
      );

      print('Respuesta: ${response.statusCode}');
     

      // Comprobar si la solicitud fue exitosa
      if (response.statusCode == 201) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permiso creado exitosamente')),
        );
      } else {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el permiso')),
        );
      }
    } catch (e) {
      // Manejar excepciones de red u otros errores
      print('Error en la solicitud: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
