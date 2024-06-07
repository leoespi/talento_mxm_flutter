import 'package:flutter/material.dart';

import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:get/get.dart';
import 'package:talento_mxm_flutter/views/perfil.dart';
import 'package:talento_mxm_flutter/views/incapacidades_page.dart'; 
class MenuPage extends StatelessWidget {
  final AuthenticationController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      



      
      // Barra de navegación
            bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomMenuItem(
                  icon: Icons.article,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 250),
                        transitionsBuilder: (context, animation, _, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        pageBuilder: (context, _, __) => MyForm(),
                      ),
                    );
                  },
                  color: Colors.blue,
                  label: 'Incapacidad',
                ),
                _buildBottomMenuItem(
                  icon: Icons.home,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 250),
                        transitionsBuilder: (context, animation, _, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        pageBuilder: (context, _, __) => MenuPage(),
                      ),
                    );
                  },
                  color: Colors.green,
                  label: 'Inicio',
                ),
                _buildBottomMenuItem(
                  icon: Icons.person,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 250),
                        transitionsBuilder: (context, animation, _, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        pageBuilder: (context, _, __) => ProfileScreen(userId: ''),
                      ),
                    );
                  },
                  color: Colors.orange,
                  label: 'Perfil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


Widget _buildBottomMenuItem({required IconData icon, required VoidCallback onPressed, required Color color, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: color,
          iconSize: 30.0,
        ),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

