import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/services/user_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:talento_mxm_flutter/views/login_page.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';

import 'package:talento_mxm_flutter/views/bottom_menu.dart';
import 'package:url_launcher/url_launcher.dart';



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
  

  const ProfileScreen({Key? key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthenticationController _authController = AuthenticationController();
  late Future<UserData> userData;
  var storage = GetStorage();
    bool _isExpanded = false;

  

  @override
  void initState() {
    super.initState();
    String token = storage.read('token');
    userData = UserService.obtenerUsuarios(token);
  }

   // Función para cerrar sesión
  void logout() {
    _authController.logout(); // Lógica para cerrar sesión
    // Navegar a la pantalla de inicio de sesión, por ejemplo:
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Reemplazar LoginPage con tu página de inicio de sesión
    );
  }

  Future<void> _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'No se pudo abrir la URL: $url';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(''),
        actions: [
          IconButton(
                               
           onPressed: logout,
           icon: Icon(Icons.logout),
           color: Colors.white,
          ),

        ],
      ),
       drawer: SideMenu(),
      body: FutureBuilder<UserData>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final usuario = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 80.0,
                      backgroundImage: AssetImage('assets/profile_placeholder.png'),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    usuario.name,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 5, 13, 121),
                    ),
                  ),
                 
                  SizedBox(height: 20.0),
                  Divider(color: Colors.grey[400]),
                  SizedBox(height: 20.0),
                  Text(
                    'Información Personal',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 5, 13, 121),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ListTile(
                    leading: Icon(Icons.person, color: const Color.fromARGB(255, 5, 13, 121)),
                    title: Text('Nombre'),
                    subtitle: Text(usuario.name),
                  ),
                  ListTile(
                    leading: Icon(Icons.perm_identity, color: const Color.fromARGB(255, 5, 13, 121)),
                    title: Text('Cédula'),
                    subtitle: Text(usuario.cedula),
                  ),
                  ListTile(
                    leading: Icon(Icons.email, color: const Color.fromARGB(255, 5, 13, 121)),
                    title: Text('Correo Electrónico'),
                    subtitle: Text(usuario.email),
                  ),
                ],
              ),
            );
            
          }
        },
      ),
     
      
    );
  }
}
