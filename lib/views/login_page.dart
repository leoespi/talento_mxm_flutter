import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:talento_mxm_flutter/views/register_page.dart';
import 'package:talento_mxm_flutter/views/ResetPasswordPage.dart'; // Asegúrate de importar la nueva página
import './widgets/input_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
        title: Text(''),
        actions: [],
      ),
      body: Stack(
        children: [
          // Fondo color sólido
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white, // Cambio de color de fondo
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size * 0.2),
                    Container(
                      width: 200,
                      height: 130,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/MXMLOGO.png'), // Ruta a la imagen local
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: size * 0.1),
                    InputWidget(
                      hintText: 'Cédula',
                      obscureText: false,
                      controller: _cedulaController,
                    ),
                    SizedBox(height: 20),
                    InputWidget(
                      hintText: 'Contraseña',
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Color.fromARGB(255, 5, 13, 121),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      onPressed: () async {
                        await _authenticationController.login(
                          cedula: int.parse(_cedulaController.text.trim()),
                          password: _passwordController.text.trim(),
                        );
                      },
                      child: Obx(() {
                        return _authenticationController.isLoading.value
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Iniciar Sesión',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: size * 0.040,
                                ),
                              );
                      }),
                    ),
                    SizedBox(height: 20),
                    // Botón para redirigir a la página de registro
                    TextButton(
                      onPressed: () {
                        Get.to(RegisterPage());
                      },
                      child: Text(
                        'Registrarse',
                        style: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 5, 13, 121),
                          fontSize: size * 0.040,
                        ),
                      ),
                    ),
                    // Botón para redirigir a la página de restablecimiento de contraseña
                    TextButton(
                      onPressed: () {
                        Get.to(ResetPasswordPage());
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 5, 13, 121),
                          fontSize: size * 0.040,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
