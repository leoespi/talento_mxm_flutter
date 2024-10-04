import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:talento_mxm_flutter/controllers/publicacion_controller.dart';
import 'package:talento_mxm_flutter/models/publicacion_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:talento_mxm_flutter/views/bottom_menu.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Publicacion> feeds = [];
  bool isLoading = false;
  int _offset = 0;
  int _limit = 5; // Número de feeds por carga

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
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<Publicacion> nuevosFeeds = await FeedController.obtenerFeeds(_offset, _limit);

      if (nuevosFeeds.isEmpty) {
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

  Future<void> _refreshFeeds() async {
    setState(() {
      feeds.clear();
      _offset = 0;
    });
    await cargarFeeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 13, 121),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(''),
      ),
      drawer: SideMenu(),
      body: RefreshIndicator(
        onRefresh: _refreshFeeds,
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
                            height: 200.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(feed.videoLink!)}/hqdefault.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        if (feed.imagenes.isNotEmpty)
                          Container(
                            height: 200.0,
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: feed.imagenes.length == 1 ? 1 : 2,
                                childAspectRatio: 1.0,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                              ),
                              itemCount: feed.imagenes.length,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, imgIndex) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: 'http://10.0.2.2:8000${feed.imagenes[imgIndex]}',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                  ),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 8.0),
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
    );
  }
}

class DetallePublicacion extends StatefulWidget {
  final Publicacion feed;

  DetallePublicacion({required this.feed});

  @override
  _DetallePublicacionState createState() => _DetallePublicacionState();
}

class _DetallePublicacionState extends State<DetallePublicacion> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    if (widget.feed.videoLink != null && widget.feed.videoLink!.isNotEmpty) {
      String videoId = YoutubePlayer.convertUrlToId(widget.feed.videoLink!)!;
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (widget.feed.videoLink != null && widget.feed.videoLink!.isNotEmpty) {
      _youtubeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feed = widget.feed;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '${feed.contenido}',
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  if (feed.videoLink != null && feed.videoLink!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(24.0),
                      ),
                      child: Container(
                        height: 300,
                        color: Colors.black,
                        child: YoutubePlayer(
                          controller: _youtubeController,
                          showVideoProgressIndicator: true,
                        ),
                      ),
                    ),
                  if (feed.imagenes.isNotEmpty)
                    Column(
                      children: feed.imagenes.map((imageUrl) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {}); // Intenta volver a cargar la imagen
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl: 'http://10.0.2.2:8000$imageUrl',
                                width: screenWidth - 22,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
