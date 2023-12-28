import 'package:flutter/material.dart';
import 'package:popular_movies/api/movie_manager.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/ui/movie_list/movie_grid_layout.dart';

class MovieList extends StatefulWidget {
  MovieListBean? movieListBean;

  MovieList({Key? key, this.movieListBean}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  Future<MovieListResponseBean>? movieListResponseBean;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MovieManager movieManager = new MovieManager();

//    MovieListBean movieListBean = new MovieListBean();
    movieListResponseBean =
        movieManager.getMovieArrayList(widget.movieListBean!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieListResponseBean>(
      future: movieListResponseBean,
      builder: (context, snapshotMovieListResponseBean) {
        if (snapshotMovieListResponseBean.hasData) {
          List<MovieGridLayout> stubMovieGridLayout;

          stubMovieGridLayout = List.generate(
              snapshotMovieListResponseBean.data!.movieList!.length, (index) {
            return MovieGridLayout(
                snapshotMovieListResponseBean.data!.movieList![index]);
          });

          bool isLargeScreen;

          if (MediaQuery.of(context).size.width > 600) {
            isLargeScreen = true;
          } else {
            isLargeScreen = false;
          }

          return OrientationBuilder(
            builder: (context, orientation) {
              return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12.0,
                  children: stubMovieGridLayout);
            },
          );
        } else if (snapshotMovieListResponseBean.hasError) {
          return Center(child: Text("${snapshotMovieListResponseBean.error}"));
        }
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0,)
        );

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
