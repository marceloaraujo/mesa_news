import 'package:flutter/material.dart';
import 'package:mesa_news/entities/News.dart';
import 'package:mesa_news/screens/news-detail/NewsDetail.dart';
import 'package:mesa_news/utils/BookmarkUtils.dart';
import 'package:mesa_news/utils/UpdateListener.dart';
import 'package:uuid/uuid.dart';

class HighlightComponent extends StatefulWidget {

  News _news;

  HighlightComponent(this._news);

  @override
  _HighlightComponentState createState() => _HighlightComponentState();
}

class _HighlightComponentState extends State<HighlightComponent> implements UpdateListener {

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
  void update() {
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    bu = BookmarkUtils();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => NewsDetail(widget._news, this)));
      },
      child: Container(
        height: 130,
        child: Card(
          child: Row(
            children: [

              Hero(
                tag: widget._news.getUuid(),
                transitionOnUserGestures: true,
                child: Image.network(
                  widget._news.getImageUrl(),
                  height: 130,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Text(
                        widget._news.getTitle(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: toggleBookmark,
                              child: Icon(
                                bu.checkIsInBookmark(widget._news) ? Icons.bookmark : Icons.bookmark_border
                              ),
                            ),
                            Text(
                              _calculateDate(widget._news.getPublishedAt())
                            )
                          ],
                        ),
                      )

                    ],
                  ),
                )
              )

            ],
          ),
        )
      ),
    );
  }
}