import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:talento_mxm_flutter/models/incapaacidades_model.dart';

class IncapacidadesController extends GetxController {
  final isLoading = false.obs;
  final box = GetStorage();
  
  //  URL de la API
  final String url = 'http://10.0.2.2:8000/api/ ';

  //// Función para crear una nueva incapacidad
  Future<void> createIncapacidad({
    required String tipoincapacidadreportada,
    required int diasIncapacidad,
    required DateTime fechaInicioIncapacidad,
    required String entidadAfiliada,
    required String imagePath, required List<File> images,
  }) async {
    try {
      int userId = box.read('user_id');// Obtiene el ID de usuario
      String token = box.read('token'); // Obtiene el token de acceso 

      // Crea una instancia del modelo de incapacidad con los datos proporcionados
      IncapacidadModel incapacidad = IncapacidadModel(
        userId: userId,
        tipoincapacidadreportada: tipoincapacidadreportada,
        diasIncapacidad: diasIncapacidad,
        fechaInicioIncapacidad: fechaInicioIncapacidad,
        entidadAfiliada: entidadAfiliada,
        image: basename(imagePath),
      );

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}incapacidades'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields.addAll(incapacidad.toJson().map((key, value) => MapEntry(key, value.toString())));


      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imagePath,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      var response = await request.send();

      // Leer la respuesta completa del servidor
      var responseBody = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      // Muestra un mensaje de éxito si la incapacidad se crea correctamente
      if (response.statusCode == 201) {
        Get.snackbar(
          'Éxito',
          'Incapacidad creada con éxito',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        // Muestra un mensaje de error si hay un problema al crear la incapacidad
        Get.snackbar(
          'Error',
          'Error al crear la incapacidad: $responseBody',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
