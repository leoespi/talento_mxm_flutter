import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/io_client.dart';

class IncapacidadesController extends GetxController {
  final box = GetStorage();
  final String url = 'http://10.0.2.2:8000/api/';

  //url prueba Celular por cable (SOLO SE USA PARA CARGAR EL PROYECTO EN EL CELULAR POR CABLE)
  //final String url = 'http://192.168.1.148:8000/api/';
  
  
  /// Crea una incapacidad reportada
  /// 
  /// Parámetros:
  /// - [tipoincapacidadreportada]: Tipo de incapacidad reportada.
  /// - [diasIncapacidad]: Número de días de incapacidad.
  /// - [fechaInicioIncapacidad]: Fecha de inicio de la incapacidad.
  /// - [entidadAfiliada]: Entidad afiliada del usuario.
  /// - [images]: Lista de imágenes asociadas.
  /// - [documents]: Lista de documentos asociados.
  /// - [imagePaths]: Rutas de las imágenes.
  /// - [documentPaths]: Rutas de los documentos.
  /// - [categoriaCodigo]: codigo de la categoria (incapacidad)
  /// - [context]: Contexto de la aplicación para mostrar diálogos.

Future<void> createIncapacidad({
  required String? tipoincapacidadreportada,
  required int? diasIncapacidad,
  required DateTime? fechaInicioIncapacidad,
  required String? entidadAfiliada,
  required List<File> images,
  required List<File> documents,
  required List<String> imagePaths,
  required List<String> documentPaths,
  required String? categoriaCodigo,  // Nuevo parámetro para el código de categoría
  required BuildContext context,
}) async {
  // Validar que ningún campo obligatorio sea nulo
  if (tipoincapacidadreportada == null ||
      diasIncapacidad == null ||
      fechaInicioIncapacidad == null ||
      entidadAfiliada == null ||
      categoriaCodigo == null) {
    // Si alguno de los campos es nulo, mostrar un mensaje y detener la ejecución
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor complete todos los campos obligatorios.')),
    );
    return; // Detener la ejecución de la función
  }

  try {
    int? userId = box.read('user_id');
    String? token = box.read('token');

    if (userId == null) {
      print('Error: user_id is null');
      return; // Salir si no hay user_id
    }

    // Configuración del cliente HTTP
    var client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    var ioClient = IOClient(client);

    // Creación de la solicitud multipart
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${url}incapacidades'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'user_id': '$userId',
      'tipoincapacidadreportada': tipoincapacidadreportada,
      'diasIncapacidad': '$diasIncapacidad',
      'fechaInicioIncapacidad': '${fechaInicioIncapacidad.toIso8601String()}',
      'entidadAfiliada': entidadAfiliada,
      'categoria_codigo': categoriaCodigo ?? '', // Asignamos una cadena vacía si es null
    });

    // Añadir imágenes al request
    for (int i = 0; i < images.length; i++) {
      var imagePath = imagePaths[i];
      request.files.add(await http.MultipartFile.fromPath('images[$i]', imagePath));
    }

    // Añadir documentos al request
    for (int i = 0; i < documents.length; i++) {
      var documentPath = documentPaths[i];
      request.files.add(await http.MultipartFile.fromPath('documentos[]', documentPath));
    }

    // Enviar la solicitud
    var response = await ioClient.send(request);

    // Manejar la respuesta
    String responseBody = await response.stream.bytesToString();
    if (response.statusCode == 201) {
      // Solo mostramos el diálogo de éxito si no hay errores
      _showSuccessDialog(context); // Mostrar diálogo de éxito
    } else {
      // Si la respuesta contiene un mensaje de error, mostramos el mensaje de error
      if (responseBody.contains("Este código de categoría no existe")) {
        // Si el error es específico para el código de categoría
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Este código de categoría no existe. Solicítalo con tu EPS.')),
        );
      } else {
        // Para otros errores del backend
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $responseBody')),
        );
      }
    }
  } catch (e) {
    // En caso de cualquier error durante la ejecución de la solicitud
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ocurrió un error al intentar crear la incapacidad.')),
    );
  }
}

  /// Muestra un diálogo de éxito al crear la incapacidad
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Creación Exitosa'),
          content: Text('La incapacidad se creó exitosamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

}