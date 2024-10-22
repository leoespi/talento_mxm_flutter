import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:talento_mxm_flutter/views/login_page.dart';
import './widgets/input_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  void _register() async {
    if (_nameController.text.trim().isEmpty ||
        _cedulaController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Campos Requeridos',
        'Por favor, completa todos los campos.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await _authenticationController.register(
      name: _nameController.text.trim(),
      cedula: int.parse(_cedulaController.text.trim()),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.1), // Espacio adicional
              Text(
                'Registrarse',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40), // Espacio entre el título y los inputs
              InputWidget(
                hintText: 'Nombre Completo',
                obscureText: false,
                controller: _nameController,
              ),
              SizedBox(height: 20),
              InputWidget(
                hintText: 'Cédula',
                obscureText: false,
                controller: _cedulaController,
              ),
              SizedBox(height: 20),
              InputWidget(
                hintText: 'Correo Electrónico',
                obscureText: false,
                controller: _emailController,
              ),
              SizedBox(height: 20),
              InputWidget(
                hintText: 'Contraseña',
                obscureText: true,
                controller: _passwordController,
              ),
              SizedBox(height: 100),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  backgroundColor: const Color.fromARGB(255, 5, 13, 121),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 15,
                  ),
                ),
                onPressed: _register,
                child: Obx(() {
                  return _authenticationController.isLoading.value
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Registrarse',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        );
                }),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.to(LoginPage());
                },
                child: Text(
                  '¿Ya tienes cuenta? Inicia sesión',
                  style: GoogleFonts.roboto(
                    color: const Color.fromARGB(255, 5, 13, 121),
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '© 2024 Mas Por Menos. Todos los derechos reservados.',
                style: GoogleFonts.roboto(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
