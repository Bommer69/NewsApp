import 'package:flutter/foundation.dart';
import '../models/news_article.dart';

/// Service quản lý bookmark articles
class BookmarkService extends ChangeNotifier {
  final List<String> _bookmarkedIds = [];
  final List<NewsArticle> _bookmarkedArticles = [];

  List<NewsArticle> get bookmarkedArticles => _bookmarkedArticles;

  bool isBookmarked(String articleId) {
    return _bookmarkedIds.contains(articleId);
  }

  void toggleBookmark(NewsArticle article) {
    if (isBookmarked(article.id)) {
      _bookmarkedIds.remove(article.id);
      _bookmarkedArticles.removeWhere((a) => a.id == article.id);
    } else {
      _bookmarkedIds.add(article.id);
      _bookmarkedArticles.add(article);
    }
    notifyListeners();
  }

  Future<void> loadBookmarks() async {
    // TODO: Load from local storage
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> saveBookmarks() async {
    // TODO: Save to local storage
    await Future.delayed(const Duration(milliseconds: 500));
  }
}


