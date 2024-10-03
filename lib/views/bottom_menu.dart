import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/views/menu.dart';
import 'package:talento_mxm_flutter/views/CrearReferidos_page.dart';
import 'package:talento_mxm_flutter/views/cesantias_page.dart';
import 'package:talento_mxm_flutter/views/incapacidades_page.dart';
import 'package:talento_mxm_flutter/views/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:talento_mxm_flutter/views/perfil.dart';


class BottomMenu extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  BottomMenu({required this.isExpanded, required this.onExpandToggle});

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomMenuItem(
                  icon: Icons.article,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyForm()),
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
                      MaterialPageRoute(builder: (context) => MenuPage()),
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
                      MaterialPageRoute(builder: (context) => ProfileScreen(userId: '')),
                    );
                  },
                  color: Colors.orange,
                  label: 'Perfil',
                ),
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomMenuItem(
                    icon: Icons.document_scanner,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyCesantiaspage()),
                      );
                    },
                    color: Colors.red,
                    label: 'Cesantias',
                  ),
                  _buildBottomMenuItem(
                    icon: Icons.document_scanner,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CrearReferidoScreen()),
                      );
                    },
                    color: Color.fromARGB(255, 73, 54, 244),
                    label: 'Referidos',
                  ),
                  _buildBottomMenuItem(
                    icon: Icons.web,
                    onPressed: () {
                      _launchURL('http://supermercadosmxmag.siesacloud.com:8933/AuthAG/LoginFormAG?IdCia=1&NroConexion=1');
                    },
                    color: Colors.blue,
                    label: 'Autogestion',
                  ),
                ],
              ),
            ),
          InkWell(
            onTap: onExpandToggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomMenuItem({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: color,
          iconSize: 30,
        ),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
