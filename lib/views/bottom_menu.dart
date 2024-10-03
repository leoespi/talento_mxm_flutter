import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/views/menu.dart';
import 'package:talento_mxm_flutter/views/CrearReferidos_page.dart';
import 'package:talento_mxm_flutter/views/cesantias_page.dart';
import 'package:talento_mxm_flutter/views/incapacidades_page.dart';
import 'package:talento_mxm_flutter/views/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:talento_mxm_flutter/views/perfil.dart';
import 'package:talento_mxm_flutter/controllers/authentication.dart';

class SideMenu extends StatelessWidget {
  final AuthenticationController _authController = AuthenticationController();

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  // Función para cerrar sesión
  void logout(BuildContext context) {
    _authController.logout(); // Lógica para cerrar sesión
    // Navegar a la pantalla de inicio de sesión
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 5, 13, 121),
            ),
            child: Text(
              'Menú',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Inicio',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MenuPage()),
              );
            },
          ),
          _createDrawerItem(
            icon: Icons.article,
            text: 'Incapacidad',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyForm()),
              );
            },
          ),
          _createDrawerItem(
            icon: Icons.document_scanner,
            text: 'Cesantías',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyCesantiaspage()),
              );
            },
          ),
          _createDrawerItem(
            icon: Icons.document_scanner,
            text: 'Referidos',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CrearReferidoScreen()),
              );
            },
          ),
          _createDrawerItem(
            icon: Icons.web,
            text: 'Autogestión',
            onTap: () {
              _launchURL('http://supermercadosmxmag.siesacloud.com:8933/AuthAG/LoginFormAG?IdCia=1&NroConexion=1');
            },
          ),
          _createDrawerItem(
            icon: Icons.person,
            text: 'Perfil',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(userId: '')),
              );
            },
          ),
          _createDrawerItem(
            icon: Icons.logout,
            text: 'Cerrar Sesión',
            onTap: () {
              logout(context); // Llama a la función de cierre de sesión
            },
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
