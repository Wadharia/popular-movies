import 'package:flutter/material.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/ui/movie_details/movie_details.dart';
import 'package:popular_movies/ui/movie_list/movie_list_600.dart';
import 'package:popular_movies/ui/movie_poster.dart';

class MovieGridLayout extends StatefulWidget {
  MovieDetailBean _movieDetailBean = new MovieDetailBean();

  MovieDetailBean get movieDetailBean => _movieDetailBean;

  set movieDetailBean(MovieDetailBean value) {
    _movieDetailBean = value;
  }

  MovieGridLayout(this._movieDetailBean);

  @override
  _MovieGridLayoutState createState() => _MovieGridLayoutState();
}

class _MovieGridLayoutState extends State<MovieGridLayout> {

  Future<String>? offlineImagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // CommonUtils commonUtils = new CommonUtils();
    // if(widget.movieDetailBean.isOffline!=null && widget.movieDetailBean.isOffline) {
    //   print(widget.movieDetailBean.moviePosterFile);
    //   offlineImagePath = commonUtils.getOfflineImagePath(widget.movieDetailBean.moviePosterFile);
    // }


  }


  @override
  Widget build(BuildContext context) {

    // MoviePoster moviePoster = new MoviePoster(widget.movieDetailBean);

    return Semantics(
      label: widget.movieDetailBean.title,
      child: InkWell(
          // When the user taps the button, show a snackbar.
          onTap: () {

            if(MediaQuery.of(context).size.width > 600){

              setState(() {
                MovieListTab.of(context).movieDetailBean = widget.movieDetailBean;
              });

            }
            else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetails(widget.movieDetailBean),
                  ));
            }
          },
          child: MoviePoster(widget.movieDetailBean,"list"),

      ),
    );
  }
}
