/// Model cho bài viết tin tức
class NewsArticle {
  final String id;
  final String title;
  final String content;
  final String excerpt;
  final String imageUrl;
  final String category;
  final String author;
  final String authorAvatar;
  final DateTime publishedAt;
  final int readTimeMinutes;
  final int viewCount;
  final bool isFeatured;
  final bool isHot;
  final String? videoUrl;
  final String? videoDuration;
  final List<String> tags;
  final List<NewsArticle>? relatedArticles;

  NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.imageUrl,
    required this.category,
    required this.author,
    required this.authorAvatar,
    required this.publishedAt,
    required this.readTimeMinutes,
    required this.viewCount,
    this.isFeatured = false,
    this.isHot = false,
    this.videoUrl,
    this.videoDuration,
    this.tags = const [],
    this.relatedArticles,
  });

  /// Parse từ GNews API JSON
  factory NewsArticle.fromGNewsJson(
    Map<String, dynamic> json, {
    required String category,
    bool isFeatured = false,
    bool isHot = false,
    int viewCount = 0,
    List<NewsArticle>? relatedArticles,
  }) {
    final title = (json['title'] ?? '').toString();
    final description = (json['description'] ?? '').toString();
    final content = (json['content'] ?? description).toString();

    // Validate và clean image URL
    String imageUrl = (json['image'] ?? '').toString().trim();
    
    // Kiểm tra URL hợp lệ
    if (imageUrl.isNotEmpty) {
      try {
        final uri = Uri.parse(imageUrl);
        // Chỉ chấp nhận http/https URLs
        if (uri.scheme != 'http' && uri.scheme != 'https') {
          imageUrl = '';
        }
      } catch (e) {
        // URL không hợp lệ, set về rỗng
        imageUrl = '';
      }
    }
    final url = (json['url'] ?? '').toString();
    final sourceName = (json['source']?['name'] ?? 'GNews').toString();

    final publishedAt =
        DateTime.tryParse((json['publishedAt'] ?? '').toString()) ??
            DateTime.now();

    final id = url.isNotEmpty ? url : title.hashCode.toString();

    final tags = title
        .split(RegExp(r'\s+'))
        .where((w) => w.length >= 4)
        .take(6)
        .toList();

    int readTime(String text) {
      final words =
          text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
      return (words / 200).ceil().clamp(1, 20);
    }

    return NewsArticle(
      id: id,
      title: title,
      content: content,
      excerpt: description.isNotEmpty
          ? description
          : (content.length > 140 ? content.substring(0, 140) : content),
      imageUrl: imageUrl,
      category: category,
      author: sourceName,
      authorAvatar: 'https://via.placeholder.com/150',
      publishedAt: publishedAt,
      readTimeMinutes: readTime(content),
      viewCount: viewCount,
      isFeatured: isFeatured,
      isHot: isHot,
      tags: tags,
      relatedArticles: relatedArticles,
    );
  }

  // Tính thời gian đã đăng (relative time)
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} năm trước';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} tháng trước';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}p trước';
    } else {
      return 'Vừa xong';
    }
  }

  // Format số lượt xem
  String get viewCountFormatted {
    if (viewCount >= 1000000) {
      return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    } else if (viewCount >= 1000) {
      return '${(viewCount / 1000).toStringAsFixed(1)}k';
    }
    return viewCount.toString();
  }

  // Copy with method
  NewsArticle copyWith({
    String? id,
    String? title,
    String? content,
    String? excerpt,
    String? imageUrl,
    String? category,
    String? author,
    String? authorAvatar,
    DateTime? publishedAt,
    int? readTimeMinutes,
    int? viewCount,
    bool? isFeatured,
    bool? isHot,
    String? videoUrl,
    String? videoDuration,
    List<String>? tags,
    List<NewsArticle>? relatedArticles,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      excerpt: excerpt ?? this.excerpt,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      author: author ?? this.author,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      publishedAt: publishedAt ?? this.publishedAt,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      viewCount: viewCount ?? this.viewCount,
      isFeatured: isFeatured ?? this.isFeatured,
      isHot: isHot ?? this.isHot,
      videoUrl: videoUrl ?? this.videoUrl,
      videoDuration: videoDuration ?? this.videoDuration,
      tags: tags ?? this.tags,
      relatedArticles: relatedArticles ?? this.relatedArticles,
    );
  }
}
