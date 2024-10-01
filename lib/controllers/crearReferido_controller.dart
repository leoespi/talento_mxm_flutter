import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/io_client.dart';
import 'package:talento_mxm_flutter/views/menu.dart'; // Importa menu.dart aquí


class ReferidosController extends GetxController {
  final box = GetStorage();
  final url = 'http://10.0.2.2:8000/api/';

  Future<void> createReferido({
 
    required File documento,
    required BuildContext context,
  }) async {
    try {
      int? userId = box.read('user_id');
      String? token = box.read('token');

      if (userId == null || token == null) {
        print('Error: user_id or token is null');
        return;
      }

      var client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      var ioClient = IOClient(client);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}referidos'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields.addAll({
        'user_id': '$userId',
        
      });

      request.files.add(await http.MultipartFile.fromPath(
        'documento',
        documento.path,
        filename: documento.path.split('/').last,
      ));

      var response = await ioClient.send(request);

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Creación Exitosa'),
              content: Text('El referido se creó exitosamente.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.offAll(() => MenuPage()); // Redirecciona al menú usando Get.offAll
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else {
        print('Error al crear el referido. Código de estado: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void logout() {
    // Lógica para cerrar sesión
    // Esto dependerá de cómo has implementado la lógica de cierre de sesión en tu aplicación
  }
}
  