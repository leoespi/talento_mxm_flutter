import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:talento_mxm_flutter/views/login_page.dart';
import './widgets/input_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage ({super.key});

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, -60),
                child: Text(
                  'Registrarse',
                  style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 3, 0, 168),
                    fontSize: size * 0.080,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InputWidget(
                hintText: 'Nombre',
                obscureText: false,
                controller: _nameController,
              ),
              const SizedBox(
                height: 30,
              ),
              InputWidget(
                hintText: 'Cedula',
                obscureText: false,
                controller: _cedulaController,
              ),
              const SizedBox(
                height: 30,
              ),
              InputWidget(
                hintText: 'Correo Electronico',
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              InputWidget(
                hintText: 'Contraseña',
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 3, 0, 168),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                   onPressed: () async {
                  await _authenticationController.register(
                    name: _nameController.text.trim(),
                    // Convertir la cédula a un número antes de enviarla al controlador de autenticación
                    cedula: int.parse(_cedulaController.text.trim()), // <- Comentario agregado
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );
                },
                child: Obx(() {
                  return _authenticationController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Transform.translate(
                          offset: Offset(0, 0),
                          child: Text(
                            'Registrarse',
                            style: GoogleFonts.poppins(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: size * 0.040,
                            ),
                          ),
                        );
                }),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.to(LoginPage());
                },
                child: Text(
                  'Volver',
                  style: GoogleFonts.poppins(
                    fontSize: size * 0.040,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
