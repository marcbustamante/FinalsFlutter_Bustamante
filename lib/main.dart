import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'movie_catalog.dart';

void main() {
  runApp(MovieCatalogApp());
}

class MovieCatalogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Catalog',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/movies': (context) => MovieCatalog(),
      },
    );
  }
}
