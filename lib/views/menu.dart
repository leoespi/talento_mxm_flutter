import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/views/incapacidades_page.dart'; 
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:get/get.dart';
import 'package:talento_mxm_flutter/views/login_page.dart';
import 'package:talento_mxm_flutter/views/perfil.dart';

class MenuPage extends StatelessWidget {
  final AuthenticationController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        
        actions: [
          IconButton (
            icon: Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -5.0), // Ajusta el valor verticalmente según sea necesario
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF3366FF), // Cambia aquí el color a azul rey
            borderRadius: BorderRadius.circular(15.0),
          
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomMenuItem(
                  icon: Icons.article,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyForm()),
                    );
                  },
                  color: Colors.white, // Cambia aquí el color del icono
                  iconSize: 30, // Cambia aquí el tamaño del icono
                ),
                _buildBottomMenuItem(
                  icon: Icons.quiz,
                  onPressed: () {
                    // Agrega aquí la lógica para la otra opción del menú
                  },
                  color: Colors.white, // Cambia aquí el color del icono
                  iconSize: 30, // Cambia aquí el tamaño del icono
                ),
                _buildBottomMenuItem(
                  icon: Icons.person,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          userId: '',
                        ),
                      ),
                    );
                  },
                  color: Colors.white, // Cambia aquí el color del icono
                  iconSize: 30, // Cambia aquí el tamaño del icono
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {
    required Color color,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomMenuItem({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required double iconSize, // Añade el tamaño del icono
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: iconSize), // Aplica el tamaño del icono
      onPressed: onPressed,
    );
  }
}
