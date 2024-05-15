import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './widgets/input_widget.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:get/get.dart';


class LoginPage extends StatefulWidget { 
  const LoginPage ({super.key});

  @override
  State <LoginPage> createState() => _LoginPageState();
}

 
 class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationController _authenticationController =
  Get.put(AuthenticationController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            const Text("INICIO DE SESION"),
            const SizedBox(
              height: 30,
              ),
               InputWidget(
                hintText: 'Email',
                obscureText: false,
                controller: _usernameController,
              ),const SizedBox(height: 20,),
               InputWidget(
                hintText: 'Password',
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(
                height: 30,
              ),
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 37, 28, 170),
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
                          color: Color.fromARGB(255, 122, 122, 122),
                        )
                      : Text(
                          'Login',
                          style: GoogleFonts.poppins(
                          
                          ),
                        );
                }),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const ()); //pagina de registro 
                },
                child: Text(
                  'Register',
                  style: GoogleFonts.poppins(
                   
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              )
              

              ],
            
        ),

      ),
    );

  
 }
 
 }