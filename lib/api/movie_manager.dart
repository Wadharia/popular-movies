import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:popular_movies/config/global_config.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:http/http.dart' as http;
import 'package:popular_movies/model/movie_db_helper.dart';
import 'package:popular_movies/model/movie_detail_bean.dart';

class MovieManager {
  ///Fetches the movie list
  Future<MovieListResponseBean> getMovieArrayList(
      MovieListBean movieListBean) async {
    //yes this works in dart
    if (movieListBean.sortBy == GlobalConfig.favourites) {
      MovieDBHelper movieDBHelper = new MovieDBHelper();

      return MovieListResponseBean(
          movieList: await movieDBHelper.getFavouriteMovieList());
    }

    String url = GlobalConfig.apiUrl;
    String param =
        "?api_key=${GlobalConfig.apiKey}&sort_by=${movieListBean.sortBy}";

    http.Response response = await http.get(Uri.parse(url + param));

    if (response.statusCode == 200) {
      print("input url:- ${url}${param}");
      print("response ${response.body}");

      Map<String, dynamic> jsonObj = json.decode(response.body);

      return MovieListResponseBean.fromJSON(jsonObj);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load movie list');
    }
  }

  Future<MovieTrailerListResponseBean> getMovieTrailerList(
      MovieDetailBean movieDetailBean,
      [bool isFavourite = false]) async {
    if (isFavourite) {
      MovieDBHelper movieDBHelper = new MovieDBHelper();

      return MovieTrailerListResponseBean(
          movieTrailerList:
              await movieDBHelper.getStoredTrailerDetails(movieDetailBean));
    }

    String url =
        GlobalConfig.movieDetailsUrl + "${movieDetailBean.movieID}/videos";
    String param = "?api_key=${GlobalConfig.apiKey}";

    http.Response response = await http.get(Uri.parse(url + param));

    print("input url:- ${url}${param}");

    if (response.statusCode == 200) {
//      print("input url:- ${url}${param}");
      print("response ${response.body}");

      Map<String, dynamic> jsonObj = json.decode(response.body);

      return MovieTrailerListResponseBean.fromJSON(jsonObj);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load trailer list');
    }
  }

  Future<MovieReviewListResponseBean> getMovieReviewList(
      MovieDetailBean movieDetailBean) async {
    String url =
        GlobalConfig.movieDetailsUrl + "${movieDetailBean.movieID}/reviews";
    String param = "?api_key=${GlobalConfig.apiKey}";

    http.Response response = await http.get(Uri.parse(url + param));

    print("input url:- ${url}${param}");

    if (response.statusCode == 200) {
//      print("input url:- ${url}${param}");
      print("response ${response.body}");

      Map<String, dynamic> jsonObj = json.decode(response.body);

      return MovieReviewListResponseBean.fromJSON(jsonObj);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Review list');
    }
  }

  Future<void> saveMoviePosters(MovieDetailBean movieDetailBean) async {
    var client = new http.Client();
    String url;
    try {
      url = movieDetailBean.moviePosterUrl!;
      http.Response response = await client.get(Uri.parse(url));

      var documentDirectory = await getApplicationDocumentsDirectory();

      if (response.statusCode == 200) {
        String filePath = documentDirectory.path.toString() +
            movieDetailBean.moviePosterFile!;

        File filePoster = new File(filePath);

        filePoster.writeAsBytesSync(response.bodyBytes);
      }

      url = movieDetailBean.detailPosterUrl!;
      http.Response response2 = await client.get(Uri.parse(url));

      if (response2.statusCode == 200) {
        String filePath2 = documentDirectory.path.toString() +
            movieDetailBean.detailPosterFile!;

        File fileDetail = new File(filePath2);

        fileDetail.writeAsBytesSync(response2.bodyBytes);
      }
    } catch (e) {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("hbs exception:- $e");
      throw Exception('Failed to save posters');
    } finally {
      client.close();
    }
  }

  Future<void> deleteMoviePosters(MovieDetailBean movieDetailBean) async {
    try {
      var documentDirectory = await getApplicationDocumentsDirectory();
      String filePath =
          documentDirectory.path.toString() + movieDetailBean.moviePosterFile!;

      File filePoster = new File(filePath);
      filePoster.delete();

      String filePath2 =
          documentDirectory.path.toString() + movieDetailBean.detailPosterFile!;

      File fileDetail = new File(filePath2);

      fileDetail.delete();
    } catch (e) {
      print("hbs exception:- $e");
      throw Exception('Failed to delete posters');
    }
  }
}
