import 'package:popular_movies/config/global_config.dart';

class MovieTrailerBean {
  String? movieID;
  String? trailerName;
  String? trailerURL;

  MovieTrailerBean({this.trailerName, this.trailerURL});


  factory MovieTrailerBean.fromJSON(Map<String, dynamic> json) {
    return MovieTrailerBean(
      trailerName: json["name"],
      trailerURL: GlobalConfig.youtubeUrl+json["key"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movieID': movieID,
      'trailerName': trailerName,
      'trailerURL': trailerURL
    };
  }

}



class MovieTrailerListResponseBean {
  List<MovieTrailerBean>? movieTrailerList;

  MovieTrailerListResponseBean({this.movieTrailerList});

  factory MovieTrailerListResponseBean.fromJSON(Map<String, dynamic> json) {
    List<dynamic> movieTrailerArray = json["results"];

    return MovieTrailerListResponseBean(
        movieTrailerList: List.generate(movieTrailerArray.length,
            (index) => MovieTrailerBean.fromJSON(movieTrailerArray[index])));
  }
}



class MovieReviewBean {
  String? author;
  String? content;
  String? reviewURL;


  MovieReviewBean({this.author, this.content, this.reviewURL});

  factory MovieReviewBean.fromJSON(Map<String, dynamic> json) {
    return MovieReviewBean(
      author: json["author"],
      content: json["content"],
      reviewURL: json["url"]
    );
  }

}



class MovieReviewListResponseBean {
  List<MovieReviewBean>? movieReviewList;


  MovieReviewListResponseBean({this.movieReviewList});


  factory MovieReviewListResponseBean.fromJSON(Map<String, dynamic> json) {
    List<dynamic> movieReviewArray = json["results"];

    return MovieReviewListResponseBean(
        movieReviewList: List.generate(movieReviewArray.length,
                (index) => MovieReviewBean.fromJSON(movieReviewArray[index])));
  }
}
