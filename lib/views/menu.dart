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
      appBar: AppBar(
        title: Text('Menú'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildMenuItem(
              context,
              color: Colors.blue,
              icon: Icons.article,
              text: 'Incapacidades',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyForm()),
                );
              },
            ),
            _buildMenuItem(
              context,
              color: Colors.green,
              icon: Icons.quiz,
              text: 'Otra opción',
              onTap: () {
                // Agrega aquí la lógica para la otra opción del menú
              },
            ),
            _buildMenuItem(
              context,
              color: Colors.orange,
              icon: Icons.person,
              text: 'Perfil',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      userId: '',
                    ),
                  ),
                );
              },
            ),
          ],
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
}
