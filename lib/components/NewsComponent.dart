import 'package:flutter/material.dart';
import 'package:mesa_news/entities/News.dart';
import 'package:mesa_news/screens/news-detail/NewsDetail.dart';
import 'package:mesa_news/utils/BookmarkUtils.dart';
import 'package:mesa_news/utils/UpdateListener.dart';

class NewsComponent extends StatefulWidget {

  News _news;

  NewsComponent(this._news);

  @override
  _NewsComponentState createState() => _NewsComponentState();
}

class _NewsComponentState extends State<NewsComponent> implements UpdateListener {

  BookmarkUtils bu;

  _calculateDate(DateTime publishedAt) {
    final now = DateTime.now();
    final diff = now.difference(publishedAt).inHours;
    double days = 0;
    if(diff > 24) {
      days = diff / 24;
      return '${days.toInt()} dias atrás';
    }
    return '$diff horas atrás';
  }

  @override
  void update() {
    setState(() {
    });
  }

  toggleBookmark() {
    setState(() {
      if(!bu.checkIsInBookmark(widget._news)) {
        bu.addBookmark(widget._news);
      } else {
        bu.removeBookmark(widget._news);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bu = BookmarkUtils();
  }

  openNewsDetail() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => NewsDetail(widget._news, this)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openNewsDetail,
      child: Container(
        height: 270,
        child: Card(
          child: Column(
            children: [

                Hero(
                  tag: widget._news.getUuid(), 
                  child: Image.network(
                    widget._news.getImageUrl(),
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover
                  )
                ),

                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      GestureDetector(
                        onTap: toggleBookmark,
                        child: bu.checkIsInBookmark(widget._news) ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border),
                      ),

                      Text(
                        _calculateDate(widget._news.getPublishedAt())
                      )

                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    widget._news.getTitle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),

                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    widget._news.getDescription(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3
                  )
                )

            ],

          ),
        ),
      ),
    );
  }
}