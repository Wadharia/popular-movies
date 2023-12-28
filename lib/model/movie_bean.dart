import 'package:intl/intl.dart';
import 'package:popular_movies/config/global_config.dart';
import 'package:popular_movies/model/movie_detail_bean.dart';

class MovieDetailBean {

  String? movieID;
  String? moviePosterUrl;
  String? title;
  String? releaseDate;
  String? voteAverage;
  String? overview;
  String? detailPosterUrl;
  String? shareTrailerUrl;
  String? moviePosterFile;
  String? detailPosterFile;
  List<MovieTrailerBean>? movieTrailers;
  bool? isOffline = false;




  MovieDetailBean(
      {this.movieID,
      this.moviePosterUrl,
      this.title,
      this.releaseDate,
      this.voteAverage,
      this.overview,
      this.detailPosterUrl,
      this.moviePosterFile,
      this.detailPosterFile,
      this.isOffline});

  factory MovieDetailBean.fromJSON(Map<String, dynamic> json) {
    String releaseDateStub;
    String moviePosterUrlStub;
    String detailPosterUrlStub;

    try {
      releaseDateStub = DateFormat("MMM dd,yyyy")
          .format(DateTime.parse(json["release_date"]));
    } catch (e) {
      releaseDateStub = "Release Date Not Available";
    }

    try {
      moviePosterUrlStub = "${GlobalConfig.posterUrl}${json["poster_path"]}";
    } catch (e) {
      moviePosterUrlStub = "";
    }

    try {
      detailPosterUrlStub =
          "${GlobalConfig.posterUrl}${json["backdrop_path"]}";
    } catch (e) {
      detailPosterUrlStub = "";
    }

    return MovieDetailBean(
        movieID: json["id"].toString(),
        title: json["title"],
        releaseDate: releaseDateStub,
        voteAverage:
            json["vote_average"].toString() ?? "Average Vote Not Available",
        overview: json["overview"],
        moviePosterUrl: moviePosterUrlStub,
        detailPosterUrl: detailPosterUrlStub,
        moviePosterFile: moviePosterUrlStub.length > 0 ? json["poster_path"] :"",
        detailPosterFile: detailPosterUrlStub.length > 0 ? json["backdrop_path"]:"",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieID': movieID,
      'moviePosterUrl': moviePosterUrl,
      'title': title,
      'releaseDate': releaseDate,
      'voteAverage': voteAverage,
      'overview': overview,
      'detailPosterUrl': detailPosterUrl,
      'moviePosterFile' : moviePosterFile,
      'detailPosterFile' : detailPosterFile,
    };
  }
}

class MovieListBean {
  String _sortBy = GlobalConfig.popularityDesc;

  String get sortBy => _sortBy;

  set sortBy(String value) {
    _sortBy = value;
  }
}

class MovieListResponseBean {
  List<MovieDetailBean>? movieList;

  MovieListResponseBean({this.movieList});

  factory MovieListResponseBean.fromJSON(Map<String, dynamic> json) {
    List<MovieDetailBean> stubMovieList;
    List<dynamic> movieArray = json["results"];

    return MovieListResponseBean(
        movieList: List.generate(movieArray.length,
            (index) => MovieDetailBean.fromJSON(movieArray[index])));
  }
}
