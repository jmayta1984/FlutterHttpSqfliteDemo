import 'package:flutter/material.dart';
import 'package:flutter_networking_persistence/ui/movie_list.dart';

void main() {
  runApp(MyMovies());
}

class MyMovies extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MovieList();
  }
}
