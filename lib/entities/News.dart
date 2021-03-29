import 'package:uuid/uuid.dart';

class News {

  String _uuid;
  String _title;
  String _content;
  String _description;
  String _author;
  DateTime _publishedAt;
  bool _highlight;
  String _url;
  String _imageUrl;

  News(this._uuid, this._title, this._content, this._description, this._author, this._publishedAt, this._highlight, this._url, this._imageUrl);

  void setUuid(String uuid) {
    this._uuid = uuid;
  }

  String getUuid() {
    return _uuid;
  }

  void setTitle(String title) {
    this._title = title;
  }

  String getTitle() {
    return _title;
  }

  void setContent(String content) {
    this._content = content;
  }

  String getContent() {
    return _content;
  }

  String setDescription(String description) {
    this._description = description;
  }

  String getDescription() {
    return _description;
  }

  void setAuthor(String author) {
    this._author = author;
  }

  String getAuthor() {
    return _author;
  }

  void setPublishedAt(DateTime publishedAt) {
    this._publishedAt = publishedAt;
  }

  DateTime getPublishedAt() {
    return _publishedAt;
  }

  void setHighlight(bool highlight) {
    this._highlight = highlight;
  }

  bool isHighlight() {
    return _highlight;
  }

  void setUrl(String url) {
    this._url = url;
  }

  String getUrl() {
    return _url;
  }

  void setImageUrl(String imageUrl) {
    this._imageUrl = imageUrl;
  }

  String getImageUrl() {
    return _imageUrl;
  }

  factory News.fromJson(Map<String, dynamic> json) {
    DateTime publishedAt = DateTime.parse(json['published_at']);
    return News(
      Uuid().v4(),
      json['title'],
      json['content'],
      json['description'],
      json['author'],
      publishedAt,
      json['highlight'],
      json['url'],
      json['image_url']
    );
  }

}