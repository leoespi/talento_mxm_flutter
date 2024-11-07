import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/io_client.dart';
import 'package:talento_mxm_flutter/views/menu.dart'; // Importa menu.dart aquí

class ReferidosController extends GetxController {
  final box = GetStorage();
  final String url = 'http://10.0.2.2:8000/api/';
  
  //url prueba Celular por cable (SOLO SE USA PARA CARGAR EL PROYECTO EN EL CELULAR POR CABLE)
  //final String url = 'http://192.168.1.148:8000/api/';

  /// Crea un nuevo referido
  /// 
  /// Parámetros:
  /// - [documento]: Archivo del documento asociado al referido.
  /// - [context]: Contexto de la aplicación para mostrar diálogos.
  Future<void> createReferido({
    required File documento,
    required BuildContext context,
  }) async {
    try {
      int? userId = box.read('user_id');
      String? token = box.read('token');

      // Validar que userId y token no sean nulos
      if (userId == null || token == null) {
        print('Error: user_id or token is null');
        return;
      }

      // Configuración del cliente HTTP
      var client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      var ioClient = IOClient(client);

      // Creación de la solicitud multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}referidos'),
      );

      // Agregar encabezados de autorización
      request.headers['Authorization'] = 'Bearer $token';

      // Agregar campos del formulario
      request.fields['user_id'] = '$userId';

      // Añadir documento al request
      request.files.add(await http.MultipartFile.fromPath(
        'documento',
        documento.path,
        filename: documento.path.split('/').last,
      ));

      // Enviar la solicitud
      var response = await ioClient.send(request);

      // Manejar la respuesta
      if (response.statusCode == 201) {
        _showSuccessDialog(context); // Mostrar diálogo de éxito
      } else {
        print('Error al crear el referido. Código de estado: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error: $e'); // Manejo de errores
    }
  }

  /// Muestra un diálogo de éxito al crear el referido
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Creación Exitosa'),
          content: Text('El referido se creó exitosamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Get.offAll(() => MenuPage()); // Redirecciona al menú usando Get.offAll
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  /// Cierra sesión del usuario
  void logout() {
    // Lógica para cerrar sesión
    // Esto dependerá de cómo has implementado la lógica de cierre de sesión en tu aplicación
  }
}
