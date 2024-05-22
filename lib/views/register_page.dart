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

//Controladores para la pagina de Registro
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
      body: Stack(
        children: [
          // Fondo gradiente
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF3366FF),
                  Color(0xFF00CCFF),
                ],
              ),
            ),
          ),

          //Inputs para el Registro
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(0, -60),
                    child: Text(
                      'Registrarse',
                      style: GoogleFonts.poppins(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: size * 0.080,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  InputWidget(
                    hintText: 'Nombre Completo',
                    obscureText: false,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 30),
                  InputWidget(
                    hintText: 'Cedula',
                    obscureText: false,
                    controller: _cedulaController,
                  ),
                  const SizedBox(height: 30),
                  InputWidget(
                    hintText: 'Correo Electronico',
                    obscureText: false,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  InputWidget(
                    hintText: 'Contraseña',
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Color(0xFF3366FF),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    onPressed: () async {
                      await _authenticationController.register(
                        name: _nameController.text.trim(),
                        cedula: int.parse(_cedulaController.text.trim()),
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
                  const SizedBox(height: 20),
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
        ],
      ),
    );
  }
}
