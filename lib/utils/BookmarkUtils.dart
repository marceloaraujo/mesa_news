import 'package:mesa_news/entities/News.dart';

class BookmarkUtils {

  static final BookmarkUtils _instance = BookmarkUtils._internal();

  List<News> _bookmark = [];

  factory BookmarkUtils() {
    return _instance;
  }

  BookmarkUtils._internal();

  addBookmark(News n) {
    _bookmark.add(n);
  }

  removeBookmark(News n) {
    _bookmark.removeWhere((news) => news.getUuid() == n.getUuid());
  }

  checkIsInBookmark(News n) {
    if(_bookmark.contains(n)){
      return true;
    }
    return false;
  }

  List<News> getBookmarkList() {
    return _bookmark;
  }

}