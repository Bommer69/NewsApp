import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../config/app_colors.dart';
import '../../config/app_constants.dart';
import '../../models/news_article.dart';
import '../../providers/news_provider.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/video_player_widget.dart';
import '../../widgets/image_placeholder.dart';

/// Màn hình chi tiết bài báo
class DetailScreen extends StatefulWidget {
  final NewsArticle article;

  const DetailScreen({
    super.key,
    required this.article,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<NewsArticle> _relatedArticles = [];
  bool _isLiked = false;
  bool _isFollowing = false;
  double _textScale = 1.0;

  @override
  void initState() {
    super.initState();

    /// Lấy tin liên quan từ cache của NewsProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final news = context.read<NewsProvider>();
      setState(() {
        _relatedArticles =
            news.getRelatedArticles(widget.article, limit: 2);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeroImage(),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -40),
                  child: _buildContentContainer(),
                ),
              ),
            ],
          ),
          _buildTopNavigationBar(),
          _buildFloatingActionBar(),
        ],
      ),
    );
  }

  // ================= HERO IMAGE =================

  Widget _buildHeroImage() {
    return SliverAppBar(
      expandedHeight: 320,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            NewsImage(
              imageUrl: widget.article.imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark.withOpacity(0.3),
                    AppColors.backgroundDark.withOpacity(0.1),
                    AppColors.backgroundDark,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CONTENT =================

  Widget _buildContentContainer() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryChip(),
          const SizedBox(height: 16),
          Text(
            widget.article.title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 28,
                  height: 1.2,
                ),
          ),
          const SizedBox(height: 24),
          _buildAuthorSection(),
          const SizedBox(height: 24),
          const Divider(color: AppColors.glassBorder),
          const SizedBox(height: 24),
          _buildArticleContent(),
          if (widget.article.videoUrl != null) _buildVideoPlayer(),
          const SizedBox(height: 32),
          if (_relatedArticles.isNotEmpty) _buildRelatedArticles(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppConstants.radiusRound),
      ),
      child: Text(
        widget.article.category,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAuthorSection() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.surfaceDark,
          radius: 24,
          backgroundImage: widget.article.authorAvatar.isNotEmpty
              ? CachedNetworkImageProvider(widget.article.authorAvatar)
              : null,
          child: widget.article.authorAvatar.isEmpty
              ? Text(
                  widget.article.author.isNotEmpty
                      ? widget.article.author[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.article.author,
                  style: Theme.of(context).textTheme.titleMedium),
              Text(
                '${widget.article.timeAgo} • ${widget.article.readTimeMinutes} phút đọc',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() => _isFollowing = !_isFollowing);
          },
          child: Text(_isFollowing ? 'Đang theo dõi' : 'Theo dõi'),
        ),
      ],
    );
  }

  Widget _buildArticleContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.article.content.split('\n\n').map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            p,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize:
                      (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16) *
                          _textScale,
                ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVideoPlayer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: VideoPlayerWidget(
        videoUrl: widget.article.videoUrl!,
        thumbnailUrl: widget.article.imageUrl,
      ),
    );
  }

  // ================= RELATED =================

  Widget _buildRelatedArticles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tin liên quan',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _relatedArticles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final a = _relatedArticles[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(article: a),
                    ),
                  );
                },
                child: SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NewsImage(
                        imageUrl: a.imageUrl,
                        height: 120,
                        width: 200,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        a.category,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        a.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ================= TOP BAR =================

 Widget _buildTopNavigationBar() {
  return Positioned(
    top: 5,
    left: 8,
    child: SafeArea(
      child: GlassButton(
        onPressed: () => Navigator.pop(context),
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    ),
  );
}




  // ================= FLOATING ACTION =================

  Widget _buildFloatingActionBar() {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: Consumer<BookmarkService>(
        builder: (context, bookmark, _) {
          final isBookmarked =
              bookmark.isBookmarked(widget.article.id);

          return Center(
            child: GlassContainer(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: AppColors.primary,
                    ),
                    onPressed: () =>
                        bookmark.toggleBookmark(widget.article),
                  ),
                  IconButton(
                    icon: Icon(
                      _isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: AppColors.error,
                    ),
                    onPressed: () =>
                        setState(() => _isLiked = !_isLiked),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share,
                        color: AppColors.textSecondary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
