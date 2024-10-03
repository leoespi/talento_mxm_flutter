import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talento_mxm_flutter/services/user_service.dart';
import 'package:talento_mxm_flutter/views/login_page.dart'; // Importa la página de login

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
        Get.snackbar('Éxito', 'PIN enviado a tu correo');
        setState(() {
          _isPinSent = true;
        });
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
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
        Get.snackbar('Éxito', 'Contraseña restablecida exitosamente');
        Get.offAll(LoginPage()); // Redirigir a la página de inicio de sesión
      } else {
        Get.snackbar('Error', 'No se pudo restablecer la contraseña. Verifica tus datos.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Restablecer Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            if (_isPinSent) ...[
              TextField(
                controller: _pinController,
                decoration: InputDecoration(labelText: 'PIN'),
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(labelText: 'Nueva Contraseña'),
                obscureText: true,
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : (_isPinSent ? _resetPassword : _requestPin),
              child: _isLoading 
                ? CircularProgressIndicator() 
                : Text(_isPinSent ? 'Restablecer Contraseña' : 'Enviar PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
