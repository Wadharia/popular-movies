import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popular_movies/model/movie_bean.dart';
import 'package:popular_movies/ui/menu/settings_menu.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonUtils {
  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _showMyDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
//          title: Text('AlertDialog Title'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void shareMovieDetails(
      MovieDetailBean movieDetailBean, BuildContext context) {
    if (movieDetailBean.shareTrailerUrl != null) {
      Share.share(
          'Check out the movie trailer of ${movieDetailBean.title} ${movieDetailBean.shareTrailerUrl}',
          subject: '${movieDetailBean.title}');
    } else {
      _showMyDialog(context, "No Trailers Available");
    }
  }

  void showSettings(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsMenu(),
        ));
  }

  AppBar getAppBar({MovieDetailBean? movieDetailBean,required BuildContext context}) {
    if (movieDetailBean != null) {
      return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Popular Movies"),
            InkWell(
              onTap: () {
                shareMovieDetails(movieDetailBean, context);
              },
              child: Icon(Icons.share),
            ),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                showSettings(context);
              },
              itemBuilder: (context) {
                List<PopupMenuEntry<Object>> menuList = [];

                menuList.add(PopupMenuItem(
                  child: Text("Settings"),
                  value: "settings",
                ));
                return menuList;
              },
            ),
          ],
        ),
      );
    } else {
      return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Popular Movies"),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                showSettings(context);
              },
              itemBuilder: (context) {
                List<PopupMenuEntry<Object>> menuList = [];

                menuList.add(PopupMenuItem(
                  child: Text("Settings"),
                  value: "settings",
                ));
                return menuList;
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> setGlobalString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> getGlobalString(String key) async {
    String ret;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ret = prefs.getString(key) ?? "";
    return ret;
  }

  Future<String> getOfflineImagePath(String imagePath) async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    String filePoster = documentDirectory.path.toString() + imagePath;

    print(filePoster);
    return filePoster;
  }
}
