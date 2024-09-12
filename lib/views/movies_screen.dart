import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/movies_service.dart';
import '../services/favorites_service.dart';
import 'favorites_screen.dart';
import 'about_screen.dart';
import '../widgets/movie_details.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MoviesScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _searchResults = [];
  List<dynamic> _movies = [];
  List<dynamic> _series = [];
  List<dynamic> _cartoons = [];
  List<dynamic> _latestReleases = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllContent();
  }

  Future<void> _fetchAllContent() async {
    final omdbProvider = Provider.of<OmdbProvider>(context, listen: false);
    final movies = await omdbProvider.fetchByType('movie');
    final series = await omdbProvider.fetchByType('series');
    final cartoons = await omdbProvider.fetchByType('cartoon');
    final latestReleases = await omdbProvider.fetchLatestReleases();

    setState(() {
      _movies = movies.take(20).toList();
      _series = series.take(20).toList();
      _cartoons = cartoons.take(20).toList();
      _latestReleases = latestReleases.take(20).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteMovies = favoritesProvider.favoriteMovies;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: _buildHeader(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isNotEmpty
              ? ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (ctx, index) {
                    final item = _searchResults[index];
                    return ListTile(
                      title: Text(item['Title']),
                      subtitle: Text(item['Year']),
                      onTap: () => _showMovieDetails(item),
                    );
                  },
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      favoriteMovies.isNotEmpty
                          ? _buildSection('Favoris', favoriteMovies)
                          : const SizedBox.shrink(),
                      _buildSection('Films', _movies),
                      _buildSection('Séries', _series),
                      _buildSection('Dessins animés', _cartoons),
                      _buildSection('Dernières sorties', _latestReleases),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (!_isSearching)
          const Expanded(
            child: Text(
              'Pour Vous',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        if (_isSearching)
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Rechercher...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (value) {
                final omdbProvider =
                    Provider.of<OmdbProvider>(context, listen: false);
                omdbProvider.fetchByType(value).then((movies) {
                  setState(() {
                    _searchResults = movies;
                  });
                });
              },
            ),
          ),
        if (!_isSearching)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        if (!_isSearching)
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.black87,
                builder: (BuildContext context) {
                  return SafeArea(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading:
                            const Icon(Icons.favorite, color: Colors.white),
                        title: const Text('Favoris',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FavoritesScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.info, color: Colors.white),
                        title: const Text('A propos de nous',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AboutScreen()),
                          );
                        },
                      ),
                    ],
                  ));
                },
              );
            },
          ),
        if (_isSearching)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchResults.clear();
                _searchController.clear();
              });
            },
          ),
      ],
    );
  }

  Widget _buildSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 158,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () => _showMovieDetails(item),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: item['Poster'] != null && item['Poster'] != 'N/A'
                            ? Image.network(
                                item['Poster'],
                                width: 100,
                                height: 150,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.movie,
                                size: 100, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showMovieDetails(dynamic movie) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return MovieDetailsSheet(
            movie: movie); // Utilisez le widget externe ici
      },
    );
  }
}
