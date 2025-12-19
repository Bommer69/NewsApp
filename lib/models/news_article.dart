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

