import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class MovieCatalog extends StatefulWidget {
  const MovieCatalog({super.key});

  @override
  _MovieCatalogState createState() => _MovieCatalogState();
}

class _MovieCatalogState extends State<MovieCatalog> {
  List movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.example.com/movies'));
      if (response.statusCode == 200) {
        setState(() {
          movies = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      setState(() {
        movies = _getSampleMovies();
      });
    }
  }

  List _getSampleMovies() {
    return [
      {
        'title': 'Inception',
        'genre': 'Science Fiction',
        'rating': '8.8',
        'poster_url': 'assets/images/inception.jpg',
      },
      {
        'title': 'The Dark Knight',
        'genre': 'Action',
        'rating': '9.0',
        'poster_url': 'assets/images/batman.jpg',
      },
      {
        'title': 'Interstellar',
        'genre': 'Adventure',
        'rating': '8.6',
        'poster_url': 'assets/images/interstellar.jpg',
      },
      {
        'title': 'The Matrix',
        'genre': 'Action',
        'rating': '8.7',
        'poster_url': 'assets/images/matirx.jpg',
      },
      {
        'title': 'Pulp Fiction',
        'genre': 'Crime',
        'rating': '8.9',
        'poster_url': 'assets/images/pulp.jpg',
      },
    ];
  }

  void deleteMovie(int index) {
    setState(() {
      movies.removeAt(index);
    });
  }

  void editMovie(int index) async {
    final updatedMovie = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        final titleController =
            TextEditingController(text: movies[index]['title']);
        final genreController =
            TextEditingController(text: movies[index]['genre']);
        final ratingController =
            TextEditingController(text: movies[index]['rating']);

        return AlertDialog(
          title: const Text("Edit Movie"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: genreController,
                decoration: const InputDecoration(labelText: "Genre"),
              ),
              TextField(
                controller: ratingController,
                decoration: const InputDecoration(labelText: "Rating"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'title': titleController.text,
                  'genre': genreController.text,
                  'rating': ratingController.text,
                });
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    if (updatedMovie != null) {
      setState(() {
        movies[index] = {
          'title': updatedMovie['title']!,
          'genre': updatedMovie['genre']!,
          'rating': updatedMovie['rating']!,
          'poster_url': movies[index]['poster_url'],
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[200],
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Card(
            color: Colors.white,
            elevation: 4,
            margin:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  movie['poster_url'],
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                movie['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.deepPurple,
                ),
              ),
              subtitle: Text(
                "Genre: ${movie['genre']}\nRating: ${movie['rating']}",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => editMovie(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteMovie(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
