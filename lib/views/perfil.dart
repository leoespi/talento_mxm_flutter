import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/services/user_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:talento_mxm_flutter/views/bottom_menu.dart';

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

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserData> userData;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    String token = storage.read('token') ?? ''; // Asegúrate de manejar el token adecuadamente
    userData = UserService.obtenerUsuarios(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
        title: Text(''),
        
        
      ),
      drawer: SideMenu(),
      body: FutureBuilder<UserData>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No se encontraron datos.'));
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
