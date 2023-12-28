import 'package:flutter/material.dart';
import 'package:popular_movies/config/global_config.dart';
import 'package:popular_movies/feedback.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/ui/movie_list/movie_list_main.dart';
import 'package:popular_movies/feedback.dart';

class AppMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          DrawerHeader(
           /* decoration: BoxDecoration(
              color: Colors.redAccent.shade400,
            ),*/
            child: Text("Menu",
              style: (TextStyle(fontSize: 35)),),
          ),
          ListTile(
            title: Text("Most Popular"),
            onTap: () {
              MovieListBean movieListBean = new MovieListBean();
              movieListBean.sortBy=GlobalConfig.popularityDesc;
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => MovieListMain(movieListBean),
              ));
            },
          ),
          ListTile(
            title: Text("Highest Rated"),
            onTap: () {
              MovieListBean movieListBean = new MovieListBean();
              movieListBean.sortBy=GlobalConfig.ratingsDesc;
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => MovieListMain(movieListBean),
              ));
            },
          ),
          ListTile(
            title: Text("Favourites"),
            onTap: () {
              MovieListBean movieListBean = new MovieListBean();
              movieListBean.sortBy=GlobalConfig.favourites;
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => MovieListMain(movieListBean),
              ));
            },
          ),
          ListTile(
            title: Text("Feedback"),
            onTap: () {
              MovieListBean movieListBean = new MovieListBean();
              movieListBean.sortBy=GlobalConfig.popularityDesc;
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => FeedbackPop(),
              ));
            },
          ),
          ListTile(
            title: Text("Privacy Policy"),
            onTap: () {
              MovieListBean movieListBean = new MovieListBean();
              child: Text("COMMING SOON",
              textScaleFactor: 2,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
              );
            },
          ),
        ],
      ),
    );
  }
}
