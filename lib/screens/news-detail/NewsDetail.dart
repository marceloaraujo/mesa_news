import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mesa_news/entities/News.dart';
import 'package:mesa_news/utils/BookmarkUtils.dart';
import 'package:mesa_news/utils/ColorUtils.dart';
import 'package:mesa_news/utils/UpdateListener.dart';
import 'package:share/share.dart';

class NewsDetail extends StatefulWidget {

  News _news;
  UpdateListener _listener;

  NewsDetail(this._news, this._listener);

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {

  BookmarkUtils bu;

  String formatDate(DateTime publishedAt) {
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(publishedAt);
    return formattedDate;
  }

  _shareNews() {
    Share.share('${widget._news.getTitle()} \n\n ${widget._news.getUrl()}');
  }

  toggleBookmark() {
    setState(() {
      if(!bu.checkIsInBookmark(widget._news)) {
        bu.addBookmark(widget._news);
      } else {
        bu.removeBookmark(widget._news);
      }
    });
    widget._listener.update();
  }

  @override
  void initState() {
    super.initState();
    bu = BookmarkUtils();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._news.getTitle()),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            Hero(
              tag: widget._news.getUuid(),
              child: Image.network(
                widget._news.getImageUrl()
              )
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  GestureDetector(
                    onTap: toggleBookmark,
                    child: Icon(
                      bu.checkIsInBookmark(widget._news) ? Icons.bookmark : Icons.bookmark_border,
                      size: 40,
                    ),
                  ),

                  Text(
                    formatDate(widget._news.getPublishedAt())
                  ),

                ],
              )
            ),

            Text(
              widget._news.getTitle(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Expanded(
                child: Text(
                  widget._news.getDescription()
                ),
              )
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _shareNews,
        backgroundColor: ColorUtils.getColorFromHex('#010A53'),
        child: Icon(
          Icons.share
        ),
      ),
    );
  }
}