import 'package:flutter/foundation.dart';
import '../models/news_article.dart';
import '../services/gnews_service.dart';

class NewsProvider extends ChangeNotifier {
  final GNewsService _service = GNewsService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<NewsArticle> _articles = [];
  List<NewsArticle> get articles => _articles;

  List<NewsArticle> _searchResults = [];
  List<NewsArticle> get searchResults => _searchResults;

  /// HOME = lấy tin mới nhất (dùng search với query chung nếu service bạn chưa có topHeadlines)
  Future<void> loadHome() async {
    _setLoading(true);
    _error = null;
    try {
      // Query "news" để lấy feed chung (an toàn, không phụ thuộc method topHeadlines)
      final raw = await _service.search('news');

      _articles = raw
          .map((e) => NewsArticle.fromGNewsJson(
                e,
                category: 'latest',
                isFeatured: false,
                isHot: false,
                viewCount: 0,
              ))
          .toList();
    } catch (e) {
      _error = e.toString();
      _articles = [];
    } finally {
      _setLoading(false);
    }
  }

  /// Load theo category (dựa theo categoryId bạn đang dùng trong UI)
  Future<void> loadByCategory(String categoryId) async {
    _setLoading(true);
    _error = null;

    try {
      // map categoryId -> keyword search
      final keyword = _categoryToQuery(categoryId);
      final raw = await _service.search(keyword);

      _articles = raw
          .map((e) => NewsArticle.fromGNewsJson(
                e,
                category: categoryId,
                isFeatured: false,
                isHot: false,
                viewCount: 0,
              ))
          .toList();
    } catch (e) {
      _error = e.toString();
      _articles = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> search(String query) async {
    _setLoading(true);
    _error = null;

    try {
      final raw = await _service.search(query);
      _searchResults = raw
          .map((e) => NewsArticle.fromGNewsJson(
                e,
                category: 'search',
                viewCount: 0,
              ))
          .toList();
    } catch (e) {
      _error = e.toString();
      _searchResults = [];
    } finally {
      _setLoading(false);
    }
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  /// Tin liên quan từ cache
  List<NewsArticle> getRelatedArticles(NewsArticle article, {int limit = 2}) {
    final related = _articles
        .where((a) =>
            a.id != article.id &&
            (a.category == article.category ||
                a.tags.any((t) => article.tags.contains(t))))
        .take(limit)
        .toList();

    if (related.isNotEmpty) return related;
    return _articles.where((a) => a.id != article.id).take(limit).toList();
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  String _categoryToQuery(String categoryId) {
    switch (categoryId) {
      case 'world':
        return 'world';
      case 'technology':
        return 'technology';
      case 'business':
        return 'business';
      case 'sports':
        return 'sports';
      case 'lifestyle':
        return 'lifestyle';
      case 'science':
        return 'science';
      case 'latest':
      default:
        return 'latest';
    }
  }
}
