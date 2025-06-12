import 'dart:convert';
import 'package:flutter/material.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<dynamic> _movies = [];
  List<dynamic> _filteredMovies = [];
  List<dynamic> _favorites = [];
  String _searchQuery = '';
  String _selectedGenre = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      final jsonString =
          await DefaultAssetBundle.of(context).loadString('assets/data.json');
      final jsonData = json.decode(jsonString);
      setState(() {
        _movies = jsonData['peliculas'];
        _filteredMovies = List.from(_movies);
      });
    } catch (e) {
      throw Exception('Error al leer el archivo local: $e');
    }
  }

  void _filterMovies() {
    setState(() {
      _filteredMovies = _movies.where((movie) {
        final title = (movie['titulo'] ?? '').toLowerCase();
        final matchesSearch = title.contains(_searchQuery.toLowerCase());
        final matchesGenre = _selectedGenre == 'Todos' ||
            (movie['genero'] as List).contains(_selectedGenre);
        return matchesSearch && matchesGenre;
      }).toList();
    });
  }

  void _toggleFavorite(Map<String, dynamic> movie) {
    setState(() {
      if (_favorites.contains(movie)) {
        _favorites.remove(movie);
      } else {
        _favorites.add(movie);
      }
    });
  }

  void _showMovieDetailsDialog(BuildContext context, Map<String, dynamic> movie) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(movie['titulo'] ?? 'Sin título'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  movie['enlaces']?['image'] ?? '',
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
                const SizedBox(height: 10),
                Text('Director: ${movie['detalles']?['director'] ?? 'Desconocido'}'),
                Text('Duración: ${movie['detalles']?['duracion'] ?? 'N/A'}'),
                Text('Año: ${movie['anio'] ?? 'Desconocido'}'),
                Text(movie['descripcion'] ?? 'No hay descripción'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  List<String> _getGenres() {
    final genres = _movies.expand((m) => m['genero'] as List).toSet().toList();
    genres.sort();
    return ['Todos', ...genres];
  }

  @override
  Widget build(BuildContext context) {
    final genres = _getGenres();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catálogo de Películas"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar película...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _filterMovies();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonFormField<String>(
              value: _selectedGenre,
              decoration: const InputDecoration(
                labelText: 'Filtrar por género',
                border: OutlineInputBorder(),
              ),
              items: genres.map((genre) {
                return DropdownMenuItem(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _selectedGenre = value;
                  _filterMovies();
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _filteredMovies.isEmpty
                ? const Center(child: Text("No se encontraron películas"))
                : ListView.builder(
                    itemCount: _filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = _filteredMovies[index];
                      final isFavorite = _favorites.contains(movie);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        child: ListTile(
                          leading: Image.network(
                            movie['enlaces']?['image'] ?? '',
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          ),
                          title: Text(movie['titulo'] ?? 'Sin título'),
                          subtitle: Text(
                            'Géneros: ${(movie['genero'] as List).join(', ')}\nValoración: ${movie['detalles']?['valoracion'] ?? 'N/A'}',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.star
                                  : Icons.star_border_outlined,
                              color: isFavorite ? Colors.amber : null,
                            ),
                            onPressed: () => _toggleFavorite(movie),
                          ),
                          onTap: () => _showMovieDetailsDialog(context, movie),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
