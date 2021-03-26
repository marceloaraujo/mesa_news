import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('token');
    print('TOKEN >>> $token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mesa News'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('GET TOKEN'),
          onPressed: () {
            _getToken();
          },
        ),
      ),
    );
  }
}