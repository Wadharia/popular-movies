import 'package:flutter/material.dart';
import 'package:popular_movies/model/movie_detail_bean.dart';
import 'package:url_launcher/url_launcher.dart';


class MovieTrailerLayout extends StatefulWidget {
  MovieTrailerBean _movieTrailerBean;


  MovieTrailerBean get movieTrailerBean => _movieTrailerBean;

  set movieTrailerBean(MovieTrailerBean value) {
    _movieTrailerBean = value;
  }


  MovieTrailerLayout(this._movieTrailerBean);

  @override
  _MovieTrailerLayoutState createState() => _MovieTrailerLayoutState();
}

class _MovieTrailerLayoutState extends State<MovieTrailerLayout> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
            //Open youtube Link

          String? url = widget.movieTrailerBean.trailerURL;
          if (await canLaunchUrl(Uri.parse(url!))) {
          await launchUrl(Uri.parse(url));
          } else {
          throw 'Could not launch $url';
          }

        },
        child: Container(
          height: 56,
          child: Card(
//          color: Colors.blueAccent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Icon(Icons.play_circle_outline)),
              Expanded(
                    flex: 7,
                    child: Text(widget.movieTrailerBean.trailerName!,)),
              ],
            ),
          ),
        ),
    );
  }
}


