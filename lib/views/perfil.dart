
import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/services/user_service.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:talento_mxm_flutter/utils/screen_size.dart';
import 'package:get_storage/get_storage.dart';

import 'package:talento_mxm_flutter/views/incapacidades_page.dart'; 
import 'package:talento_mxm_flutter/views/menu.dart';

class UserData {
  final String name;
  final String cedula;
  final String email;

  UserData({
    required this.name,
    required this.cedula,
    required this.email,
  });
}

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthenticationController _authController = AuthenticationController();
  var storage = GetStorage();
  String token = '';
  late Future<UserData> userData;
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isLoaded) return;
    isLoaded = true;
    token = storage.read('token');
    userData = UserService.obtenerUsuarios(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Transform.translate(
  offset: Offset(0.0, 50.0), // Ajusta el desplazamiento vertical según sea necesario
  child: FutureBuilder<UserData>(
    future: userData,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        final usuario = snapshot.data;
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 30.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar (
                      radius: 50.0,
                      backgroundImage: AssetImage('assets/profile_placeholder.png'), // Asegúrate de tener una imagen en assets con este nombre
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      usuario?.name ?? '',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      usuario?.email ?? '',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Información del usuario:',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Cambio de color del texto
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Nombre: ${usuario?.name}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Cédula: ${usuario?.cedula}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          'Correo Electrónico: ${usuario?.email}',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    },
  ),
),


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
                      transitionDuration: Duration(milliseconds: 250), // Duración de la animación
                      transitionsBuilder: (context, animation, _, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0.0), // Comienza desde la derecha
                            end: Offset.zero, // Hacia la posición inicial
                          ).animate(animation),
                          child: child,
                        );
                      },
                      pageBuilder: (context, _, __) => MyForm(), // Página siguiente
                    ),
                  );
                  },
                  color: Colors.blue,
                  label: 'Incapacidad', // Nombre del primer botón
                ),
                 _buildBottomMenuItem(
                  icon: Icons.home,
                  onPressed: () {
                    Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 250), // Duración de la animación
                      transitionsBuilder: (context, animation, _, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0.0), // Comienza desde la derecha
                            end: Offset.zero, // Hacia la posición inicial
                          ).animate(animation),
                          child: child,
                        );
                      },
                      pageBuilder: (context, _, __) => MenuPage(), // Página siguiente
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
                      transitionDuration: Duration(milliseconds: 250), // Duración de la animación
                      transitionsBuilder: (context, animation, _, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0.0), // Comienza desde la derecha
                            end: Offset.zero, // Hacia la posición inicial
                          ).animate(animation),
                          child: child,
                        );
                      },
                      pageBuilder: (context, _, __) =>ProfileScreen(
                                            userId: '' ), // Página siguiente
                    ),
                  );
                  },
                  color: Colors.orange,
                  label: 'Perfil', // Nombre del segundo botón
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
   Widget _buildBottomMenuItem({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required String label,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


