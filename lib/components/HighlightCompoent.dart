import 'package:flutter/material.dart';
import 'package:mesa_news/entities/News.dart';
import 'package:mesa_news/screens/news-detail/NewsDetail.dart';
import 'package:uuid/uuid.dart';

class HighlightComponent extends StatefulWidget {

  News _news;

  HighlightComponent(this._news);

  @override
  _HighlightComponentState createState() => _HighlightComponentState();
}

class _HighlightComponentState extends State<HighlightComponent> {
  
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => NewsDetail(widget._news)));
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
                              onTap: (){},
                              child: Icon(
                                Icons.bookmark_border
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