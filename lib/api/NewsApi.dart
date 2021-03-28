import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:mesa_news/entities/News.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsApi {

  final String BASE_URL = 'https://mesa-news-api.herokuapp.com';

  Future<List<News>> getHighlights() async{
    /**
     * /v1/client/news/highlights
     */
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    http.Response response = await http.get(
      '$BASE_URL/v1/client/news/highlights',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }
    );

    var dadosJson = json.decode(response.body);
    List<News> newsList = [];
    for(var news in dadosJson['data']) {
      newsList.add(News.fromJson(news));
    }
    return newsList;
  }

}