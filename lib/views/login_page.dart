import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talento_mxm_flutter/views/register_page.dart';
import './widgets/input_widget.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
            children: [
              // Agrega la imagen en la parte superior
              Center(
                child: Transform.translate(
                  offset: Offset(0, 100),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://storage.googleapis.com/mxm-2022/personalizacion/123399420963f51c1d9a4412.043673570.631880001677007901.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(""),
                      const SizedBox(
                        height: 30,
                      ),
                      InputWidget(
                        hintText: 'Cedula',
                        obscureText: false,
                        controller: _usernameController,
                      ),
                      const SizedBox(
                        height: 35,
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
                          await _authenticationController.login(
                            username: _usernameController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                        },
                        child: Obx(() {
                          return _authenticationController.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                )
                              : Text(
                                  'Iniciar Sesion',
                                  style: GoogleFonts.poppins(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: size * 0.040,
                                  ),
                                );
                        }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                         print("Botón Registrarse presionado"); // Agrega esta línea para debug
                        Get.to(RegisterPage());
                        },
                        child: Text(
                          'Registrarse',
                          style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: size * 0.040,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
