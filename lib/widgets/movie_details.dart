import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/favorites_service.dart';
import '../services/movies_service.dart';

class MovieDetailsSheet extends StatefulWidget {
  final dynamic movie; // Données du film

  const MovieDetailsSheet({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsSheetState createState() => _MovieDetailsSheetState();
}

class _MovieDetailsSheetState extends State<MovieDetailsSheet> {
  dynamic movieDetails; // Stockera les détails du film
  bool isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails(); // Appel de la fonction pour récupérer les détails du film
  }

  // Fonction pour récupérer les détails du film
  Future<void> _fetchMovieDetails() async {
    final fetchedDetails = await Provider.of<OmdbProvider>(context, listen: false)
        .fetchDetails(widget.movie['imdbID']);
    setState(() {
      movieDetails = fetchedDetails;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = Provider.of<FavoritesProvider>(context, listen: true)
        .isFavorite(widget.movie);

    return isLoading
        ? Center(
            child:
                CircularProgressIndicator()) // Affiche un indicateur de chargement si les détails sont en cours de chargement
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        movieDetails['Title'] ?? 'Titre non disponible',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Provider.of<FavoritesProvider>(context, listen: false)
                            .toggleFavorite(widget.movie);
                      },
                    ),
                  ],
                ),
                Text(
                  movieDetails['Runtime'] ?? 'Durée non disponible',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  movieDetails['Year'] ?? 'Année non disponible',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                movieDetails['Poster'] != null &&
                        movieDetails['Poster'] != 'N/A'
                    ? Image.network(movieDetails['Poster'])
                    : Container(),
                const SizedBox(height: 20),
                Text(
                  movieDetails['Plot'] ?? 'Résumé non disponible',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
  }
}
