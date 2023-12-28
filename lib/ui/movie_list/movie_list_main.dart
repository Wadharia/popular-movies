import 'package:flutter/material.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/ui/menu/app_menu.dart';
import 'package:popular_movies/ui/movie_list/movie_list_600.dart';
import 'package:popular_movies/util/common_utils.dart';

import 'movie_list.dart';

class MovieListMain extends StatefulWidget {
  MovieListBean _movieListBean;


  MovieListBean get movieListBean => _movieListBean;

  set movieListBean(MovieListBean value) {
    _movieListBean = value;
  }


  MovieListMain(this._movieListBean);

  @override
  _MovieListMainState createState() => _MovieListMainState();
}

class _MovieListMainState extends State<MovieListMain> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CommonUtils commonUtils = new CommonUtils();

    if(MediaQuery.of(context).size.width>600) {
      return MovieListTab(widget.movieListBean);
    }
    else {
      return Scaffold(
        appBar: commonUtils.getAppBar(context: context),
        drawer: AppMenu(),
        body: MovieList(movieListBean: widget.movieListBean),
      );
    }


  }
}
