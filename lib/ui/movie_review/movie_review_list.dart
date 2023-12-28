import 'package:flutter/material.dart';
import 'package:popular_movies/api/movie_manager.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/model/movie_detail_bean.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieReviewList extends StatefulWidget {
  MovieDetailBean _movieDetailBean;

  MovieDetailBean get movieDetailBean => _movieDetailBean;

  set movieDetailBean(MovieDetailBean value) {
    _movieDetailBean = value;
  }

  MovieReviewList(this._movieDetailBean);

  @override
  _MovieReviewListState createState() => _MovieReviewListState();
}

class _MovieReviewListState extends State<MovieReviewList> {
  Future<MovieReviewListResponseBean>? movieReviewListResponseBean;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MovieManager movieManager = new MovieManager();
    movieReviewListResponseBean =
        movieManager.getMovieReviewList(widget.movieDetailBean);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Popular Movies"),
      ),
      body: FutureBuilder<MovieReviewListResponseBean>(
        future: movieReviewListResponseBean,
        builder: (context, snapshotMovieListResponseBean) {
          if (snapshotMovieListResponseBean.hasData) {
            return ListView(
              children: List.generate(
                  snapshotMovieListResponseBean.data!.movieReviewList!.length,
                  (index) {
                return InkWell(
                  onTap: () async {
                    String url = snapshotMovieListResponseBean
                        .data!.movieReviewList![index].reviewURL!;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(snapshotMovieListResponseBean
                          .data!.movieReviewList![index].content!),
                      subtitle: Text(snapshotMovieListResponseBean
                          .data!.movieReviewList![index].author!),
                    ),
                  ),
                );

//                return Card(
//                  child: ListTile(
//                    title: Text(snapshotMovieListResponseBean.data.movieReviewList[index].content),
//                    subtitle: Text(snapshotMovieListResponseBean.data.movieReviewList[index].author),
//                  ),
//                );
              }),
            );
          } else if (snapshotMovieListResponseBean.hasError) {
            return Center(
                child: Text("${snapshotMovieListResponseBean.error}"));
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
