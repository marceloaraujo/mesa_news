import 'package:flutter/material.dart';
import 'package:mesa_news/api/NewsApi.dart';
import 'package:mesa_news/components/HighlightCompoent.dart';
import 'package:mesa_news/components/NewsComponent.dart';
import 'package:mesa_news/entities/News.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  int currentPage = 1;
  List<News> newsList = [];

  ScrollController scrollController;
  bool _isLoading = false;

  _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('token');
    print('TOKEN >>> $token');
  }

  _scrollListener() async {
    if(!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      currentPage++;
      _getData();
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
    scrollController = new ScrollController();
    scrollController.addListener(_scrollListener);
  }

  _getData() async {
    List<News> aux = await NewsApi().getNews(currentPage);
    setState(() {
      newsList.addAll(aux);
    });
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: _isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Mesa News'),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Destaques',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              Flexible(
                child: Container(
                  height: 130,
                  child: FutureBuilder<List<News>>(
                    future: NewsApi().getHighlights(),
                    builder: (_, snapshot) {
                      switch(snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if(snapshot.hasError) {
                            print(snapshot.error);
                            return Center(
                              child: Text('Não foi possível carregar os destaques'),
                            );
                          } else {
                            List<News> newsList = snapshot.data;
                            return PageView.builder(
                              itemCount: newsList.length,
                              itemBuilder: (_, index) {
                                return HighlightComponent(newsList[index]);
                              }
                            );
                          }
                      }
                    },
                  )
                )
              ),

              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Text(
                  'Últimas notícias',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

              Flexible(
                child: Container(
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    addRepaintBoundaries: true,
                    itemCount: newsList.length,
                    itemBuilder: (_, index) {
                      News news = newsList[index];
                      if(index == newsList.length - 1) {
                        return _buildProgressIndicator();
                      } else {
                        return NewsComponent(news);
                      }
                    }
                  )
                ),
              )
              

            ],

          ),
        ),
      ),
    );
  }
}