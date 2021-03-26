import 'package:flutter/material.dart';
import 'package:mesa_news/screens/login/InitialPage.dart';
import 'package:mesa_news/screens/news/NewsPage.dart';
import 'package:mesa_news/utils/ColorUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
      home: SplashScreen(),
      theme: ThemeData(
        primaryColor: ColorUtils.getColorFromHex('#010A53')
      ),
    )
  );
}

class SplashScreen extends StatelessWidget {

  Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') == null ? '' : prefs.getString('token');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getToken(),
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              width: double.infinity,
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator()
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.hasError) {
              return InitialPage();
            } else {
              String token = snapshot.data;
              if(token != '') {
                return NewsPage();
              } else {
                return InitialPage();
              }
            }
        }
      }
    );
  }
}
