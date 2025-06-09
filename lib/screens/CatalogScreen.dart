import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  Future<List<dynamic>> _fetchMovies() async {
    final response = await http.get(
      Uri.parse('https://jritsqmet.github.io/web-api/peliculas3.json'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return jsonData['peliculas'];
    } else {
      throw Exception('Error al cargar películas');
    }
  }

  void _showMovieDetailsDialog(BuildContext context, Map<String, dynamic> movie) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(movie['titulo'] ?? 'Sin título'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 300, // limita ancho del diálogo
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    movie['imagen'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                  const SizedBox(height: 10),
                  Text('Género: ${(movie['genero'] as List<dynamic>).join(', ')}'),
                  const SizedBox(height: 5),
                  Text('Director: ${movie['director'] ?? 'Desconocido'}'),
                  const SizedBox(height: 5),
                  Text('Año: ${movie['anio'] ?? 'Desconocido'}'),
                  const SizedBox(height: 10),
                  Text(movie['descripcion'] ?? 'No hay descripción'),
                ],
              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catálogo de Películas"), automaticallyImplyLeading: false,),
      
      body: FutureBuilder<List<dynamic>>(
        future: _fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay películas disponibles"));
          } else {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    title: Text(
                      movie['titulo'] ?? 'Sin título',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      (movie['genero'] as List<dynamic>).join(', '),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    leading: Image.network(
                      movie['imagen'] ?? '',
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                    onTap: () => _showMovieDetailsDialog(context, movie),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
