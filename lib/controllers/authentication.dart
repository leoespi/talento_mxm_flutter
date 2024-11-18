import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:talento_mxm_flutter/views/login_page.dart'; // Importa la página de inicio de sesión
import 'package:talento_mxm_flutter/views/menu.dart';

class AuthenticationController extends GetxController {
  // Observables para manejar el estado de carga y el token
  final isLoading = false.obs;
  final token = ''.obs;
  final box = GetStorage(); // Almacenamiento local
  final String url = 'http://10.0.2.2:8000/api/'; // URL de la API


  //url prueba Celular por cable (SOLO SE USA PARA CARGAR EL PROYECTO EN EL CELULAR POR CABLE)
 //final String url = 'http://192.168.1.148:8000/api/';


  /// Registra un nuevo usuario
  Future<void> register({
    required String name,
    required int cedula,
    required String email,
    required String p_venta,
    required String cargo,
    required String password,
  }) async {
    try {
      isLoading.value = true; // Indica que la carga ha comenzado
      var data = {
        'name': name,
        'cedula': cedula.toString(),
        'email': email,
        'p_venta': p_venta,
        'cargo': cargo,
        'password': password,
      };

      // Realiza la solicitud POST para registrar el usuario
      var response = await http.post(
        Uri.parse('${url}register'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 201) {
        isLoading.value = false; // Indica que la carga ha terminado
        Get.off(() => LoginPage()); // Redirige a la página de inicio de sesión
        Get.snackbar(
          'Registro exitoso',
          'Tu cuenta ha sido creada. Espera la activación por parte del administrador.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        isLoading.value = false; // Indica que la carga ha terminado
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body)); // Imprime el error en la consola
      }
    } catch (e) {
      isLoading.value = false; // Indica que la carga ha terminado
      print(e.toString()); // Imprime la excepción en la consola
    }
  }

  /// Inicia sesión de un usuario
  Future<void> login({
    required int cedula,
    required String password,
  }) async {
    try {
      isLoading.value = true; // Indica que la carga ha comenzado
      var data = {
        'cedula': cedula.toString(),
        'password': password,
      };

      // Realiza la solicitud POST para iniciar sesión
      var response = await http.post(
        Uri.parse('${url}login'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false; // Indica que la carga ha terminado
        token.value = json.decode(response.body)['token']; // Guarda el token
        box.write('token', token.value); // Almacena el token localmente
        Get.offAll(() => MenuPage()); // Redirige a la página principal o menú 
        box.write('user_id', json.decode(response.body)['user']['id']); // Almacena el ID del usuario
      } else {
        isLoading.value = false; // Indica que la carga ha terminado
        Get.snackbar(
          'Error',
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body)); // Imprime el error en la consola
      }
    } catch (e) {
      isLoading.value = false; // Indica que la carga ha terminado
      print(e.toString()); // Imprime la excepción en la consola
    }
  }

  /// Cierra sesión del usuario
  Future<void> logout() async {
    box.remove('token'); // Elimina el token del almacenamiento local
    Get.offAll(() => LoginPage()); // Redirige a la página de inicio de sesión
  }
}
