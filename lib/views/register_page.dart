import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:talento_mxm_flutter/views/login_page.dart';
import './widgets/input_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key); // Añadido 'super' al constructor

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controladores para la entrada de usuario
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _p_ventaController = TextEditingController();
  final TextEditingController _cargoController = TextEditingController();


  // Controlador de autenticación
  final AuthenticationController _authenticationController = Get.put(AuthenticationController());

  // Método para manejar el registro
  void _register() async {
    // Validar campos de entrada
    if (_nameController.text.trim().isEmpty ||
        _cedulaController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty||
        _p_ventaController.text.trim().isEmpty||
        _cargoController.text.trim().isEmpty
        ) {
      Get.snackbar(
        'Campos Requeridos',
        'Por favor, completa todos los campos.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return; // Termina el método si los campos están vacíos
    }

    // Llama al método de registro
    await _authenticationController.register(
      name: _nameController.text.trim(),
      cedula: int.parse(_cedulaController.text.trim()),
      email: _emailController.text.trim(),
      p_venta: _p_ventaController.text.trim(),
      cargo:_cargoController.text.trim(),
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

              // Título de la página
              Text(
                'Registrarse',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40), // Espacio entre el título y los inputs

              // Campos de entrada
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
                hintText: 'Punto de Venta',
                obscureText: false,
                controller: _p_ventaController,
              ),
              
              SizedBox(height: 20),
              InputWidget(
                hintText: 'Cargo',
                obscureText: false,
                controller: _cargoController,
              ),
              
              SizedBox(height: 20),
              InputWidget(
                hintText: 'Contraseña',
                obscureText: true,
                controller: _passwordController,
              ),
              SizedBox(height: 100), // Espacio antes del botón

              // Botón de registro
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  backgroundColor: const Color.fromARGB(255, 5, 13, 121),
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
                onPressed: _register,
                child: Obx(() {
                  return _authenticationController.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white) // Indicador de carga
                      : Text(
                          'Registrarse',
                          style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                        );
                }),
              ),
              SizedBox(height: 20), // Espaciado entre el botón y el texto

              // Enlace a la página de inicio de sesión
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
