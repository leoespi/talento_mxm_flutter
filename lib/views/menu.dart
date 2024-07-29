import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/controllers/publicacion_controller.dart';
import 'package:talento_mxm_flutter/models/publicacion_model.dart';

import 'package:talento_mxm_flutter/controllers/authentication.dart';
import 'package:talento_mxm_flutter/views/login_page.dart';
import 'package:talento_mxm_flutter/views/menu.dart';
import 'package:talento_mxm_flutter/views/perfil.dart';
import 'package:talento_mxm_flutter/views/cesantias_page.dart';
import 'package:talento_mxm_flutter/views/CrearReferidos_page.dart';
import 'package:talento_mxm_flutter/views/incapacidades_page.dart';

import 'package:flutter/material.dart';
import 'package:talento_mxm_flutter/controllers/publicacion_controller.dart';
import 'package:talento_mxm_flutter/models/publicacion_model.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class MenuPage extends StatefulWidget {
  @override

  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _isExpanded = false;
  final AuthenticationController _authController = AuthenticationController();

  List<Publicacion> feeds = [];
  bool isLoading = false;
  int _offset = 0;
  int _limit = 10; // Número de feeds por carga

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    cargarFeeds();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      cargarFeeds();
    }
  }

  Future<void> cargarFeeds() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<Publicacion> nuevosFeeds = await FeedController.obtenerFeeds(_offset, _limit);

      if (nuevosFeeds.isEmpty) {
        // No hay más feeds disponibles
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No hay más publicaciones para cargar')),
        );
      } else {
        setState(() {
          feeds.addAll(nuevosFeeds);
          _offset += _limit;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error al cargar los feeds: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los feeds: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
        title: Text(''),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: feeds.length + 1,
              itemBuilder: (context, index) {
                if (index < feeds.length) {
                  var feed = feeds[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetallePublicacion(feed: feed),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Usuario: ${feed.userNombre}',
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              '${feed.contenido}',
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(height: 8.0),
                            if (feed.videoLink != null && feed.videoLink!.isNotEmpty)
                              Container(
                                width: double.infinity,
                                height: 200,
                                child: YoutubePlayer(
                                  controller: YoutubePlayerController(
                                    initialVideoId: _extractVideoId(feed.videoLink!),
                                    flags: YoutubePlayerFlags(
                                      autoPlay: false,
                                      mute: false,
                                    ),
                                  ),
                                ),
                              ),
                            if (feed.imagenes.isNotEmpty)
                              Stack(
                                children: [
                                  Hero(
                                    tag: 'imageHero-${feed.id}-${feed.imagenes[0]}',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        'http://10.0.2.2:8000${feed.imagenes[0]}',
                                        height: 200.0,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          }
                                        },
                                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                          print('Error cargando imagen: $error');
                                          return Icon(Icons.error);
                                        },
                                      ),
                                    ),
                                  ),
                                  if (feed.imagenes.length > 1)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '+${feed.imagenes.length - 1}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'ID: ${feed.id}',
                                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container(); // No mostrar nada extra cuando no hay más feeds
                }
              },
            ),
          ),
        ],
      ),
      // ... (código existente)
    );
  }

  String _extractVideoId(String url) {
    RegExp regExp = RegExp(r'^(?:https?:\/\/)?(?:www\.)?youtu\.be\/([a-zA-Z0-9_-]{11})|(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})');
    Match? match = regExp.firstMatch(url);
    return match?.group(1) ?? match?.group(2) ?? '';
  }
}

  Widget _buildBottomMenuItem({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required String label,
  }) {
    return Flexible(
      child: Column(
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
      ),
    );
  }
class DetallePublicacion extends StatelessWidget {
  final Publicacion feed;

  DetallePublicacion({required this.feed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Publicación'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: feed.imagenes.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Image.network(
                    'http://10.0.2.2:8000${feed.imagenes[index]}',
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      print('Error cargando imagen: $error');
                      return Icon(Icons.error);
                    },
                  ),
                );
              },
            ),
          ),
          if (feed.videoLink != null && feed.videoLink!.isNotEmpty)
            Container(
              width: double.infinity,
              height: 200,
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: _extractVideoId(feed.videoLink!),
                  flags: YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _extractVideoId(String url) {
    RegExp regExp = RegExp(r'^(?:https?:\/\/)?(?:www\.)?youtu\.be\/([a-zA-Z0-9_-]{11})|(?:https?:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})');
    Match? match = regExp.firstMatch(url);
    return match?.group(1) ?? match?.group(2) ?? '';
  }
}


