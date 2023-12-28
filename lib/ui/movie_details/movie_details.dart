import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/util/common_utils.dart';

import 'movie_details_body.dart';

class MovieDetails extends StatefulWidget {
  MovieDetailBean _movieDetailBean = new MovieDetailBean();

  MovieDetailBean get movieDetailBean => _movieDetailBean;

  set movieDetailBean(MovieDetailBean value) {
    _movieDetailBean = value;
  }

  MovieDetails(this._movieDetailBean);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CommonUtils commonUtils = new CommonUtils();
    return Scaffold(
      appBar: commonUtils.getAppBar(
          movieDetailBean: widget.movieDetailBean, context: context),
      body: MovieDetailsBody(widget.movieDetailBean),
    );
  }
}
