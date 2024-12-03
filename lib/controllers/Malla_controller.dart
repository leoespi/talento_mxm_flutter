import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/io_client.dart';
import 'package:talento_mxm_flutter/views/menu.dart'; // Importa menu.dart aquí


class MallaController extends GetxController {
  final box = GetStorage();
  final String url = 'http://10.0.2.2:8000/api/'; // Cambia la URL según tu servidor

Future<void> createMalla({
  required String? proceso,
  required String? pVenta,
  required File? documento,
  required BuildContext context,
}) async {
  // Validar que los campos obligatorios no sean nulos
  if (proceso == null || pVenta == null || documento == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Por favor complete todos los campos obligatorios.')),
    );
    return;
  }

  try {
    // Recuperamos el userId como String desde GetStorage
    dynamic userId = box.read('user_id');
    String? token = box.read('token');

    // Verificamos si userId es de tipo int y lo convertimos a String
    if (userId is int) {
      userId = userId.toString();  // Convertimos a String
    }

    // Verificamos si userId o token son nulos
    if (userId == null || token == null) {
      print('Error: Token or user_id is null');
      return;  // Si no hay token o userId, no continuamos con la solicitud
    }

    // Crear solicitud multipart para la creación de la malla
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${url}malla'),
    );

    // Agregar el user_id como String
    request.fields['user_id'] = userId;

    // Agregar encabezado de autorización
    request.headers['Authorization'] = 'Bearer $token';

    // Agregar campos del formulario
    request.fields.addAll({
      'proceso': proceso!,
      'p_venta': pVenta!,
    });

    // Añadir archivo (documento) al request
    request.files.add(await http.MultipartFile.fromPath(
      'documento',
      documento.path,
      filename: documento.path.split('/').last, // Usamos el nombre del archivo
    ));

    // Configuración del cliente HTTP
    var client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    var ioClient = IOClient(client);

    // Enviar la solicitud
    var response = await ioClient.send(request);

    // Manejar la respuesta
    String responseBody = await response.stream.bytesToString();
    if (response.statusCode == 201) {
      _showSuccessDialog(context);  // Mostrar diálogo de éxito
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $responseBody')),
      );
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ocurrió un error al intentar crear la malla.')),
    );
  }
}


  // Mostrar diálogo de éxito
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Creación Exitosa'),
          content: Text('La malla se creó exitosamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                 Get.offAll(() => MenuPage()); 
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
