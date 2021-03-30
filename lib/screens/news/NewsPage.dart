import 'package:flutter/material.dart';
import 'package:mesa_news/api/NewsApi.dart';
import 'package:mesa_news/components/HighlightCompoent.dart';
import 'package:mesa_news/components/NewsComponent.dart';
import 'package:mesa_news/entities/News.dart';
import 'package:mesa_news/screens/filter/FilterPage.dart';
import 'package:mesa_news/utils/BookmarkUtils.dart';
import 'package:mesa_news/utils/UpdateListener.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> implements UpdateListener {

  int currentPage = 1;
  List<News> newsList = [];

  ScrollController scrollController;
  bool _isLoading = false;

  bool _showBookmark = false;

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
    if(!_showBookmark) {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        currentPage++;
        _getData();
      }
    }
  }

  int _calculateDate(DateTime publishedAt) {
    final now = DateTime.now();
    final diff = now.difference(publishedAt).inDays;
    return diff;
  }

  _applyFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isShowBookmark = prefs.getBool('show_bookmark') ?? false;
    int dateFilter = prefs.getInt('date_filter') ?? 0;
    setState(() {
      _showBookmark = isShowBookmark;
      if(_showBookmark) {
        newsList = [];
        List<News> aux = BookmarkUtils().getBookmarkList();
        /**
         * 0 - Todas as noticias
         * 1 - Notícias semanais
         */
        if(dateFilter == 1) {
          aux.forEach((news) {
            if(_calculateDate(news.getPublishedAt()) <= 7) {
              newsList.add(news);
            }
          });
        } else {
          newsList.addAll(BookmarkUtils().getBookmarkList());
        }
      } else {
        newsList = [];
        currentPage = 1;
        _getData();
      }
    });
  }

  @override
  void update() {
    _applyFilters();
  }

  @override
  void initState() {
    // _getData();
    _applyFilters();
    super.initState();
    scrollController = new ScrollController();
    scrollController.addListener(_scrollListener);
  }

  _getData() async {
    List<News> aux = await NewsApi().getNews(currentPage);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int dateFilter = prefs.getInt('date_filter') ?? 0;
    setState(() {
      if(dateFilter == 1) {
        aux.forEach((news) {
          if(_calculateDate(news.getPublishedAt()) <= 7) {
            newsList.add(news);
          }
        });
      } else {
        newsList.addAll(aux);
      }
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

  _openFilter() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => FilterPage(this)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Mesa News'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list), 
            onPressed: _openFilter
          ),
        ],
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
                      int length = _showBookmark ? newsList.length : newsList.length - 1;
                      if(index == length) {
                        if(!_showBookmark) {
                          return _buildProgressIndicator();
                        } else {
                          return Container();
                        }
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