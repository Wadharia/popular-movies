import 'package:flutter/material.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/ui/menu/app_menu.dart';
import 'package:popular_movies/ui/movie_details/movie_details_body.dart';
import 'package:popular_movies/util/common_utils.dart';

import 'movie_list.dart';

class MovieListTab extends StatefulWidget {
  MovieListBean _movieListBean = new MovieListBean();

  MovieListBean get movieListBean => _movieListBean;

  set movieListBean(MovieListBean value) {
    _movieListBean = value;
  }

  MovieListTab(this._movieListBean);

  static _MovieListTabState of(BuildContext context) {
    _MovieListTabState? navigator =
        context.findAncestorStateOfType<_MovieListTabState>();

    return navigator!;
  }

  @override
  _MovieListTabState createState() => _MovieListTabState();
}

class _MovieListTabState extends State<MovieListTab> {
  late MovieDetailBean _movieDetailBean;

  MovieDetailBean get movieDetailBean => _movieDetailBean;

  set movieDetailBean(MovieDetailBean value) {
    setState(() {
      _movieDetailBean = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    CommonUtils commonUtils = new CommonUtils();


    if (movieDetailBean != null) {
      return Scaffold(
        appBar: commonUtils.getAppBar(movieDetailBean: movieDetailBean,context: context),
        drawer: AppMenu(),
        body: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: MovieList(movieListBean: widget.movieListBean),
            ),
            Expanded(
              flex: 3,
              child: MovieDetailsBody(movieDetailBean),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
          appBar: commonUtils.getAppBar(context: context),
          drawer: AppMenu(),
          body: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: MovieList(movieListBean: widget.movieListBean),
              )
            ],
          ));
    }
  }
}
