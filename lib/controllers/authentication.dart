import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:talento_mxm_flutter/views/login_page.dart'; // Importa la página de inicio de sesión
import 'package:talento_mxm_flutter/views/menu.dart';
class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;
  final box = GetStorage();
  final String url = 'http://10.0.2.2:8000/api/'; // Ajusta la URL de tu API aquí

  // Función para registrar un nuevo usuario
  Future register({
    required String name,
    required int cedula,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'name': name,
        'cedula': cedula.toString(),
        'email': email,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${url}register'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        Get.off(() => LoginPage()); // Redirige al usuario a la página de inicio de sesión
        Get.snackbar(
          'Registro exitoso',
          'Por favor inicia sesión con tus nuevas credenciales',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  // Función para iniciar sesión
  Future login({
    required int cedula,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'cedula': cedula.toString(),
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${url}login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        Get.offAll(() => MenuPage()); // Redirige al usuario a la página principal o menú 
        box.write('user_id', json.decode(response.body)['user']['id']);
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body));
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
    }
  }

  // Función para cerrar sesión
  Future<void> logout() async {
    box.remove('token');
    Get.offAll(() => LoginPage());
  }
}
