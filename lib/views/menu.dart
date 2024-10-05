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
  final int _limit = 5; // Número de feeds por carga
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cargarFeeds();
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
      _cargarFeeds();
    }
  }

  Future<void> _cargarFeeds() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<Publicacion> nuevosFeeds = await FeedController.obtenerFeeds(_offset, _limit);
      if (nuevosFeeds.isEmpty) {
        _mostrarSnackBar('No hay más publicaciones para cargar');
      } else {
        setState(() {
          feeds.addAll(nuevosFeeds);
          _offset += _limit;
        });
      }
    } catch (e) {
      _mostrarSnackBar('Error al cargar los feeds: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _refreshFeeds() async {
    setState(() {
      feeds.clear();
      _offset = 0;
    });
    await _cargarFeeds();
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
      body: RefreshIndicator(
        onRefresh: _refreshFeeds,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: feeds.length + 1,
          itemBuilder: (context, index) {
            return index < feeds.length ? _buildFeedCard(feeds[index]) : _buildLoadingIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildFeedCard(Publicacion feed) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetallePublicacion(feed: feed)),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(' ${feed.userNombre}', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text('${feed.contenido}', style: TextStyle(fontSize: 14.0)),
              SizedBox(height: 8.0),
              if (feed.videoLink != null && feed.videoLink!.isNotEmpty)
                _buildVideoThumbnail(feed.videoLink!),
              if (feed.imagenes.isNotEmpty) _buildImageGrid(feed.imagenes),
              SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoThumbnail(String videoLink) {
    return Container(
      height: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: NetworkImage('https://img.youtube.com/vi/${YoutubePlayer.convertUrlToId(videoLink)}/hqdefault.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _mostrarImagen(BuildContext context, int index, List<String> imagenes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaImagen(
          imagenes: imagenes,
          inicial: index,
        ),
      ),
    );
  }

  Widget _buildImageGrid(List<String> imagenes) {
    return Container(
      height: 200.0,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: imagenes.length == 1 ? 1 : 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: imagenes.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, imgIndex) {
          return GestureDetector(
            onTap: () => _mostrarImagen(context, imgIndex, imagenes),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: 'http://10.0.2.2:8000${imagenes[imgIndex]}',
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error),
                      Text('Toca para intentar de nuevo'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return SizedBox.shrink(); // No mostrar nada extra cuando no hay más feeds
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
        flags: YoutubePlayerFlags(autoPlay: false, mute: false),
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

  void _mostrarImagen(BuildContext context, int index, List<String> imagenes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaImagen(
          imagenes: imagenes,
          inicial: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feed = widget.feed;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 5, 13, 121),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${feed.userNombre}', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 12.0),
              Text(feed.contenido, style: TextStyle(fontSize: 16.0), textAlign: TextAlign.justify),
              SizedBox(height: 16.0),
              if (feed.videoLink != null && feed.videoLink!.isNotEmpty) _buildYoutubePlayer(),
              SizedBox(height: 16.0),
              if (feed.imagenes.isNotEmpty) _buildImageSection(feed.imagenes),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYoutubePlayer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        height: 300,
        color: Colors.black,
        child: YoutubePlayer(
          controller: _youtubeController,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }

  Widget _buildImageSection(List<String> imagenes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Imágenes', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: imagenes.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, imgIndex) {
            return GestureDetector(
              onTap: () => _mostrarImagen(context, imgIndex, imagenes),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: CachedNetworkImage(
                  imageUrl: 'http://10.0.2.2:8000${imagenes[imgIndex]}',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error),
                        Text('Toca para intentar de nuevo'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class VistaImagen extends StatefulWidget {
  final List<String> imagenes;
  final int inicial;

  VistaImagen({required this.imagenes, required this.inicial});

  @override
  _VistaImagenState createState() => _VistaImagenState();
}

class _VistaImagenState extends State<VistaImagen> {
  late int currentImageIndex;

  @override
  void initState() {
    super.initState();
    currentImageIndex = widget.inicial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        itemCount: widget.imagenes.length,
        controller: PageController(initialPage: widget.inicial),
        onPageChanged: (index) {
          setState(() {
            currentImageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Intentar recargar la imagen al tocar
              setState(() {
                // Esto vuelve a construir el widget
              });
            },
            child: Center(
              child: CachedNetworkImage(
                imageUrl: 'http://10.0.2.2:8000${widget.imagenes[index]}',
                fit: BoxFit.contain,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error),
                      Text('Toca para intentar de nuevo'),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
