import 'package:flutter/material.dart';
import 'package:popular_movies/config/global_config.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/ui/movie_list/movie_list_main.dart';
import 'package:popular_movies/util/common_utils.dart';

class SettingsMenu extends StatefulWidget {
  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  String? _defaultView;
  List<DropdownMenuItem<String>>? _settingsDropDownMenuItems;
  CommonUtils commonUtils = new CommonUtils();
  Future<String>? futureDefault;


  void setDefaultView(String value) {
    setState(() {
      _defaultView = value;
    });

    MovieListBean movieListBean = new MovieListBean()
    ..sortBy=value;
    commonUtils.setGlobalString(GlobalConfig.keyDefaultView, value);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MovieListMain(movieListBean),));

  }

  List<DropdownMenuItem<String>> getSettingsMenuItems() {
    List<DropdownMenuItem<String>> res = [];

    res.add(new DropdownMenuItem(
      child: Text("Most Popular"),
      value: GlobalConfig.popularityDesc,
    ));

    res.add(new DropdownMenuItem(
      child: Text("Highest Rated"),
      value: GlobalConfig.ratingsDesc,
    ));

    res.add(new DropdownMenuItem(
      child: Text("Favourites"),
      value: GlobalConfig.favourites,
    ));

    res.add(new DropdownMenuItem(
      child: Text("Privacy Policy"),
      value: GlobalConfig.ratingsDesc,
    ));

    res.add(new DropdownMenuItem(
      child: Text("Send Feedback"),
      value: GlobalConfig.ratingsDesc,
    ));
    return res;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_defaultView = GlobalConfig.popularity_desc;
    futureDefault = commonUtils.getGlobalString(GlobalConfig.keyDefaultView);

    _settingsDropDownMenuItems = getSettingsMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("Settings"),
        ),
      ),
      body: FutureBuilder<String>(
        future: futureDefault,
        builder: (context, snapshot) {
          _defaultView = GlobalConfig.popularityDesc;
          if(snapshot.hasData) {
            if(snapshot.data!.length>0) {
              _defaultView = snapshot.data;
            }
//            else {
//              _defaultView = GlobalConfig.popularity_desc;
//            }
          }
          return DropdownButton<String>(
            isExpanded: true,
            onChanged: (value) {
              setDefaultView(value!);
            },
            value: _defaultView,
            items: _settingsDropDownMenuItems,
          );
        },

      ),
    );
  }
}
