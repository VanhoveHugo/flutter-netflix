import 'package:flutter/material.dart';
import 'package:netflix/widgets/movie_details.dart';
import 'package:provider/provider.dart';
import 'package:netflix/services/favorites_service.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteMovies = favoritesProvider.favoriteMovies;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        backgroundColor: Colors.black,
      ),
      body: favoriteMovies.isEmpty
          ? const Center(
              child: Text(
                'Aucun film favori',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              padding: const EdgeInsets.all(16.0),
              itemCount: favoriteMovies.length,
              itemBuilder: (ctx, index) {
                final movie = favoriteMovies[index];
                return GestureDetector(
                  onTap: () => _showMovieDetails(movie, context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: movie['Poster'] != null && movie['Poster'] != 'N/A'
                        ? Image.network(
                            movie['Poster'],
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey,
                            child: const Icon(Icons.movie,
                                size: 100, color: Colors.white),
                          ),
                  ),
                );
              },
            ),
    );
  }

  void _showMovieDetails(dynamic movie, dynamic context) {
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
