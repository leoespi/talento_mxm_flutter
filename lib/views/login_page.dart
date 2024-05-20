import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talento_mxm_flutter/views/register_page.dart';
import './widgets/input_widget.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:get/get.dart';

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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Center(
                    child: Transform.translate(
                      offset: Offset(0, 100),
                      child: Container(
                        width: 200,
                        height: 130,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://storage.googleapis.com/mxm-2022/personalizacion/123399420963f51c1d9a4412.043673570.631880001677007901.png'),
                            fit: BoxFit.fill,
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
                          const SizedBox(height: 30),
                          InputWidget(
                            hintText: 'Cédula',
                            obscureText: false,
                            controller: _cedulaController,
                          ),
                          const SizedBox(height: 20),
                          InputWidget(
                            hintText: 'Contraseña',
                            obscureText: true,
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ), backgroundColor: Color(0xFF3366FF),
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
                                  ? const CircularProgressIndicator(
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
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Get.to(RegisterPage());
                            },
                            child: Text(
                              'Registrarse',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
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
        ],
      ),
    );
  }
}
