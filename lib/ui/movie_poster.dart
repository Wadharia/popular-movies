import 'dart:io';

import 'package:flutter/material.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/util/common_utils.dart';

class MoviePoster extends StatefulWidget {
  MovieDetailBean movieDetailBean;
  String posterType;

  MoviePoster(this.movieDetailBean, this.posterType);

  @override
  _MoviePosterState createState() => _MoviePosterState();
}

class _MoviePosterState extends State<MoviePoster> {
  Future<String>? offlineImagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonUtils commonUtils = new CommonUtils();
    if (widget.movieDetailBean.isOffline != null &&
        widget.movieDetailBean.isOffline!) {
      // print(widget.movieDetailBean.moviePosterFile);

      offlineImagePath = commonUtils.getOfflineImagePath(
          widget.posterType == "list"
              ? widget.movieDetailBean.moviePosterFile!
              : widget.movieDetailBean.detailPosterFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (widget.movieDetailBean.isOffline != null &&
            widget.movieDetailBean.isOffline!)
        ? FutureBuilder<String>(
            future: offlineImagePath,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                return Image(
                  image: FileImage(File(snapshot.data!)),
                  fit: BoxFit.fill,
                );
              } else if (snapshot.hasError) {
                return Text("Unable to load moviePoster ${snapshot.error}");
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        : FadeInImage.assetNetwork(
            placeholder: 'assets/images/loading.gif',
            image: widget.posterType == "list"
                ? widget.movieDetailBean.moviePosterUrl!
                : widget.movieDetailBean.detailPosterUrl!,
            fit: BoxFit.fill,
            imageErrorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error);
            },
          );
  }
}
