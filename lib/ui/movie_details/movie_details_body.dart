import 'package:flutter/material.dart';
import 'package:popular_movies/api/movie_manager.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/model/movie_db_helper.dart';
import 'package:popular_movies/model/movie_detail_bean.dart';
import 'package:popular_movies/ui/movie_poster.dart';
import 'package:popular_movies/ui/movie_review/movie_review_list.dart';
import 'package:popular_movies/util/common_utils.dart';

import 'movie_trailer_layout.dart';

class MovieDetailsBody extends StatefulWidget {
  MovieDetailBean _movieDetailBean = new MovieDetailBean();

  MovieDetailBean get movieDetailBean => _movieDetailBean;

  set movieDetailBean(MovieDetailBean value) {
    _movieDetailBean = value;
  }

  MovieDetailsBody(this._movieDetailBean);

  @override
  _MovieDetailsBodyState createState() => _MovieDetailsBodyState();
}

class _MovieDetailsBodyState extends State<MovieDetailsBody> {
  Future<MovieTrailerListResponseBean>? movieTrailerList;
  bool? _isFavourite = false;
  Future<String>? offlineImagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    MovieDBHelper movieDBHelper = new MovieDBHelper();
    movieDBHelper.getStoredMovieDetails(widget.movieDetailBean).then((value) {
      if (value.length > 0) {
        _isFavourite = true;
      } else {
        _isFavourite = false;
      }

      CommonUtils commonUtils = new CommonUtils();
      if (widget.movieDetailBean.isOffline != null &&
          widget.movieDetailBean.isOffline!) {
        offlineImagePath = commonUtils
            .getOfflineImagePath(widget.movieDetailBean.detailPosterFile!);
      }

      setState(() {
        MovieManager movieManager = new MovieManager();
        movieTrailerList = movieManager.getMovieTrailerList(
            widget.movieDetailBean, _isFavourite!);
      });
    });

    /*MovieManager movieManager = new MovieManager();
    movieTrailerList = movieManager.getMovieTrailerList(widget.movieDetailBean);*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: MediaQuery.of(context).orientation == Orientation.portrait
                ? 1
                : 3,
            child: Container(
              color: Colors.purple.shade100,
              child: Center(
                child: Text(
                  widget.movieDetailBean.title!,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 600 ? 32 : 24,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 20,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 240,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
                              child:
                                  MoviePoster(widget.movieDetailBean, "Details"),
                            )),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                widget.movieDetailBean.releaseDate!,
                                style: TextStyle(
                                  fontSize: 28,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MovieReviewList(
                                              widget.movieDetailBean),
                                        ));
                                  },
                                  child: Center(
                                    child: Row(
//                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.star),
                                        Text(
                                            "${widget.movieDetailBean.voteAverage}/10",
                                            style: TextStyle(fontSize: 18)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal.shade300,
                                  ),
                                  onPressed: _isFavourite!
                                      ? unMarkAsFavourite
                                      : markAsFavourite,
                                  child: Center(
                                    child: _isFavourite!
                                        ? const Text('Unmark As Favourite',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16))
                                        : const Text('Mark As Favourite',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: Text(widget.movieDetailBean.overview!,
                          style: TextStyle(
                            fontSize: 20,
                          ))),
                  Flexible(
                    flex: 9,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Trailers Here",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            //Future Builder Here
                            FutureBuilder<MovieTrailerListResponseBean>(
                              future: movieTrailerList,
                              builder: (context, snapshotMovieTrailerList) {
                                if (snapshotMovieTrailerList.hasData) {
                                  List<MovieTrailerLayout>
                                      stubMovieTrailerLayout;

                                  if (snapshotMovieTrailerList
                                          .data!.movieTrailerList!.length >
                                      0) {
                                    widget.movieDetailBean.shareTrailerUrl =
                                        snapshotMovieTrailerList.data
                                            ?.movieTrailerList![0].trailerURL;
                                  }

                                  widget.movieDetailBean.movieTrailers =
                                      snapshotMovieTrailerList
                                          .data!.movieTrailerList;

                                  stubMovieTrailerLayout = List.generate(
                                      snapshotMovieTrailerList.data!
                                          .movieTrailerList!.length, (index) {
                                    return MovieTrailerLayout(
                                        snapshotMovieTrailerList
                                            .data!.movieTrailerList![index]);
                                  });
                                  return Column(
                                      children: stubMovieTrailerLayout);
                                } else if (snapshotMovieTrailerList.hasError) {
                                  return Center(
                                      child: Text(
                                          "${snapshotMovieTrailerList.error}"));
                                }

                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void markAsFavourite() async {
    MovieDBHelper movieDBHelper = new MovieDBHelper()
      ..insertMovieDetail(widget.movieDetailBean).then((value) {
        setState(() {
          _isFavourite = true;
          CommonUtils commonUtils = new CommonUtils();

          new MovieManager().saveMoviePosters(widget.movieDetailBean);

          commonUtils.showSnackBar(context, "Movie marked as favourite");
        });
      });
  }

  void unMarkAsFavourite() async {
    MovieDBHelper movieDBHelper = new MovieDBHelper()
      ..deleteMovieDetail(widget.movieDetailBean).then((value) {
        setState(() {
          _isFavourite = false;
          CommonUtils commonUtils = new CommonUtils();

          new MovieManager().deleteMoviePosters(widget.movieDetailBean);

          commonUtils.showSnackBar(context, "Movie removed from favourites");
        });
      });
  }
}
