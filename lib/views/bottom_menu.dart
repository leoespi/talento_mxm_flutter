import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/views/menu.dart';
import 'package:talento_mxm_flutter/views/CrearReferidos_page.dart';
import 'package:talento_mxm_flutter/views/cesantias_page.dart';
import 'package:talento_mxm_flutter/views/incapacidades_page.dart';
import 'package:talento_mxm_flutter/views/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:talento_mxm_flutter/views/perfil.dart';

class SideMenu extends StatelessWidget {
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
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
