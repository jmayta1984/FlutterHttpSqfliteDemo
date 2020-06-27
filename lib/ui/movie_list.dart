import 'package:flutter/material.dart';
import 'package:flutter_networking_persistence/models/movie.dart';
import 'package:flutter_networking_persistence/util/db_helper.dart';
import 'package:flutter_networking_persistence/util/http_helper.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List movies;
  int moviesCount;
  int page;
  bool loading;
  HttpHelper helper;
  ScrollController _scrollController;

  Future initialize() async {
    loadMore();
  }

  @override
  void initState() {
    helper = HttpHelper();
    page = 1;
    loading = true;
    movies = List();
    initialize();
    initScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: ListView.builder(
          controller: _scrollController,
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) {
            return MovieRow(movies[index]);
          }),
    );
  }

  void loadMore() {
    helper.getUpcoming(page.toString()).then((value) {
      movies += value;

      setState(() {
        moviesCount = movies.length;
        movies = movies;
        page += 1;
      });

      if (movies.length % 20 > 0) {
        loading = false;
      }
    });
  }

  void initScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) &&
          loading) {
        loadMore();
      }
    });
  }
}

class MovieRow extends StatefulWidget {
  final Movie movie;
  MovieRow(this.movie);

  @override
  _MovieRowState createState() => _MovieRowState(movie);
}

class _MovieRowState extends State<MovieRow> {
  final Movie movie;
  _MovieRowState(this.movie);

  bool favorite;
  DbHelper dbHelper;

  @override
  void initState() {
    favorite = false;
    dbHelper = DbHelper();
    isFavorite();
    super.initState();
  }

  @override
  void setState(fn){
    if (mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        title: Text(widget.movie.title),
        subtitle: Text(widget.movie.originalTitle),
        trailing: IconButton(
          icon: Icon(Icons.favorite),
          color: favorite ? Colors.red : Colors.grey,
          onPressed: () {
            favorite
                ? dbHelper.deleteMovie(movie)
                : dbHelper.insertMovie(movie);
            setState(() {
              favorite = !favorite;
            });
          },
        ),
      ),
    );
  }

  Future isFavorite() async {
    await dbHelper.openDb();
    favorite = await dbHelper.isFavorite(movie);
    setState(() {
      favorite = favorite;
    });
  }
}
