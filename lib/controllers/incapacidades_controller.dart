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
  /// - [context]: Contexto de la aplicación para mostrar diálogos.


  Future<void> createIncapacidad({
    required String tipoincapacidadreportada,
    required int diasIncapacidad,
    required DateTime fechaInicioIncapacidad,
    required String entidadAfiliada,
    required List<File> images,
    required List<File> documents,
    required List<String> imagePaths,
    required List<String> documentPaths,
    required BuildContext context,
  }) async {
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

      // Agregar encabezados de autorización
      request.headers['Authorization'] = 'Bearer $token';

      // Agregar campos del formulario
      request.fields.addAll({
        'user_id': '$userId',
        'tipoincapacidadreportada': tipoincapacidadreportada,
        'diasIncapacidad': '$diasIncapacidad',
        'fechaInicioIncapacidad': '${fechaInicioIncapacidad.toIso8601String()}',
        'entidadAfiliada': entidadAfiliada,
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
      if (response.statusCode == 201) {
        _showSuccessDialog(context); // Mostrar diálogo de éxito
      } else {
        print('Error al crear la incapacidad. Código de estado: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error: $e'); // Manejo de errores
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
