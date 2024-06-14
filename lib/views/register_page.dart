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
          // Fondo color sólido
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
          ),

          //Inputs para el Registro
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size * 0.1),
                    Text(
                      'Registrarse',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: size * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
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
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ), backgroundColor: Color.fromARGB(255, 5, 13, 121),
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
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Registrarse',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: size * 0.04,
                                ),
                              );
                      }),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.to(LoginPage());
                      },
                      child: Text(
                        'Volver',
                        style: GoogleFonts.poppins(
                          fontSize: size * 0.04,
                          color: Colors.black,
                        ),
                      ),
                    )
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
