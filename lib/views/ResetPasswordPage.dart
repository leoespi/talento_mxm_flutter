import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talento_mxm_flutter/services/user_service.dart';
import 'package:talento_mxm_flutter/views/login_page.dart'; // Importa la página de login
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPinSent = false;

  Future<void> _requestPin() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final success = await UserService.requestResetPin(_emailController.text.trim());
      if (success) {
        Get.snackbar('Éxito', 'PIN enviado a tu correo', snackPosition: SnackPosition.TOP);
        setState(() {
          _isPinSent = true;
        });
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final success = await UserService.resetPasswordWithPin(
        _emailController.text.trim(),
        _pinController.text.trim(),
        _newPasswordController.text.trim(),
      );
      if (success) {
        Get.snackbar('Éxito', 'Contraseña restablecida exitosamente', snackPosition: SnackPosition.TOP);
        Get.offAll(LoginPage());
      } else {
        Get.snackbar('Error', 'No se pudo restablecer la contraseña. Verifica tus datos.', snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecer Contraseña', style: TextStyle(
      color: Colors.white, // Cambia el color aquí
    ),),
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ingrese su correo electrónico para recibir un PIN',
                  style: GoogleFonts.roboto(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_isPinSent) ...[
                  SizedBox(height: 20),
                  TextField(
                    controller: _pinController,
                    decoration: InputDecoration(
                      labelText: 'PIN',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Nueva Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : (_isPinSent ? _resetPassword : _requestPin),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    backgroundColor: const Color.fromARGB(255, 5, 13, 121),
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  ),
                  child: _isLoading 
                    ? CircularProgressIndicator(color: Colors.white) 
                    : Text(
                        _isPinSent ? 'Restablecer Contraseña' : 'Enviar PIN',
                        style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
