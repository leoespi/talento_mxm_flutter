import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:talento_mxm_flutter/views/register_page.dart';
import 'package:talento_mxm_flutter/views/ResetPasswordPage.dart';
import './widgets/input_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key); // Añadido 'super' al constructor

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para la entrada de usuario
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controlador de autenticación
  final AuthenticationController _authenticationController = Get.put(AuthenticationController());

  // Método para manejar el inicio de sesión
  void _login() async {
    // Validar campos de entrada
    if (_cedulaController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Campos Requeridos',
        'Por favor, completa todos los campos.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return; // Termina el método si los campos están vacíos
    }

    // Llama al método de inicio de sesión
    await _authenticationController.login(
      cedula: int.parse(_cedulaController.text.trim()),
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size; // Tamaño de la pantalla

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0), // Espaciado general
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.1), // Espacio adicional
              
              // Logo de la aplicación
              Container(
                width: 200,
                height: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/MXMLOGO.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 100), // Espacio entre la imagen y el texto

              // Campo de entrada para cédula
              InputWidget(
                hintText: 'Cédula',
                obscureText: false,
                controller: _cedulaController,
              ),
              SizedBox(height: 20), // Espaciado entre campos

              // Campo de entrada para contraseña
              InputWidget(
                hintText: 'Contraseña',
                obscureText: true,
                controller: _passwordController,
              ),
              SizedBox(height: 30), // Espacio antes del botón

              // Botón de inicio de sesión
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  backgroundColor: const Color.fromARGB(255, 5, 13, 121),
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
                onPressed: _login,
                child: Obx(() {
                  return _authenticationController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white) // Indicador de carga
                      : Text(
                          'Iniciar Sesión',
                          style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                        );
                }),
              ),
              SizedBox(height: 20), // Espaciado entre el botón y el texto

              // Enlace a la página de registro
              TextButton(
                onPressed: () {
                  Get.to(RegisterPage());
                },
                child: Text(
                  '¿No tienes cuenta? Regístrate',
                  style: GoogleFonts.roboto(
                    color: const Color.fromARGB(255, 5, 13, 121),
                    fontSize: 16,
                  ),
                ),
              ),

              // Enlace a la página de recuperación de contraseña
              TextButton(
                onPressed: () {
                  Get.to(ResetPasswordPage());
                },
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: GoogleFonts.roboto(
                    color: const Color.fromARGB(255, 5, 13, 121),
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 40), // Espaciado antes del texto de derechos

              // Información de derechos de autor
              Text(
                '© 2024 Mas Por Menos. Todos los derechos reservados.',
                style: GoogleFonts.roboto(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
