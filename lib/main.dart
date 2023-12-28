import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/ui/movie_list/movie_list_main.dart';
import 'package:popular_movies/util/common_utils.dart';

import 'config/global_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Future<String> defaultView=new CommonUtils().getGlobalString(GlobalConfig.keyDefaultView);;
  MovieListBean movieListBean = new MovieListBean();

  defaultView.then((value) {
    if(value.length>0){
      movieListBean.sortBy = value;
    }
    runApp(MyApp(movieListBean));
  });

}

class MyApp extends StatefulWidget {
  MovieListBean movieListBean = new MovieListBean();


  MyApp(this.movieListBean);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//  MovieListBean movieListBean = new MovieListBean();
//  Future<String> defaultView;
  static final _defaultLightColorScheme =
  ColorScheme.fromSwatch(primarySwatch: Colors.teal);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.teal, brightness: Brightness.dark);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'Popular Movies',
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        home: MovieListMain(widget.movieListBean),

      );
    });
  }
}

