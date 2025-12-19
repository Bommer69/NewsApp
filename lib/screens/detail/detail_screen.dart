import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../config/app_colors.dart';
import '../../config/app_constants.dart';
import '../../models/news_article.dart';
import '../../data/mock_data.dart';
import '../../services/bookmark_service.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/video_player_widget.dart';

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
  late List<NewsArticle> _relatedArticles;
  bool _isLiked = false;
  bool _isFollowing = false;
  double _textScale = 1.0;

  @override
  void initState() {
    super.initState();
    _relatedArticles = MockData.getRelatedArticles(widget.article, limit: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            slivers: [
              // Hero image
              _buildHeroImage(),
              
              // Content
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -40),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category chip
                          _buildCategoryChip(),
                          const SizedBox(height: 16),
                          
                          // Title
                          Text(
                            widget.article.title,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: 28,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Author & meta
                          _buildAuthorSection(),
                          
                          const SizedBox(height: 24),
                          const Divider(color: AppColors.glassBorder, height: 1),
                          const SizedBox(height: 24),
                          
                          // Content
                          _buildContent(),
                          
                          // Video player (if available)
                          if (widget.article.videoUrl != null)
                            _buildVideoPlayer(),
                          
                          const SizedBox(height: 32),
                          
                          // Related articles
                          if (_relatedArticles.isNotEmpty)
                            _buildRelatedArticles(),
                          
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Glass navigation bar at top
          _buildTopNavigationBar(),
          
          // Floating action bar at bottom
          _buildFloatingActionBar(),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: widget.article.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.surfaceDark,
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surfaceDark,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
            // Gradient overlay
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
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigationBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: AppColors.glassBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlassButton(
                      onPressed: () => Navigator.pop(context),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
                    ),
                    Row(
                      children: [
                        GlassButton(
                          onPressed: () {
                            _showTextSizeDialog();
                          },
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.text_fields, size: 24, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        GlassButton(
                          onPressed: () {
                            _showMoreOptionsDialog();
                          },
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.more_vert, size: 24, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppConstants.radiusRound),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Text(
        widget.article.category,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAuthorSection() {
    return Row(
      children: [
        // Avatar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusRound),
          child: CachedNetworkImage(
            imageUrl: widget.article.authorAvatar,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 40,
              height: 40,
              color: AppColors.surfaceDark,
            ),
            errorWidget: (context, url, error) => Container(
              width: 40,
              height: 40,
              color: AppColors.surfaceDark,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Author info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.article.author,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${widget.article.timeAgo} • ${widget.article.readTimeMinutes} phút đọc',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        // Follow button
        TextButton(
          onPressed: () {
            setState(() {
              _isFollowing = !_isFollowing;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isFollowing 
                      ? 'Đã theo dõi ${widget.article.author}'
                      : 'Đã hủy theo dõi ${widget.article.author}',
                ),
                duration: const Duration(seconds: 2),
                backgroundColor: AppColors.surfaceDark,
              ),
            );
          },
          child: Text(_isFollowing ? 'Đang theo dõi' : 'Theo dõi'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.article.content.split('\n\n').map((paragraph) {
        // Check if it's a quote
        if (paragraph.trim().startsWith('"')) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.glassBg,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              border: const Border(
                left: BorderSide(
                  color: AppColors.primary,
                  width: 4,
                ),
              ),
            ),
            child: Text(
              paragraph,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textPrimary.withOpacity(0.9),
                fontSize: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16) * _textScale,
              ),
            ),
          );
        }
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            paragraph,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16) * _textScale,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: VideoPlayerWidget(
        videoUrl: widget.article.videoUrl ?? '',
        thumbnailUrl: widget.article.imageUrl,
      ),
    );
  }

  Widget _buildRelatedArticles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tin liên quan',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _relatedArticles.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final article = _relatedArticles[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(article: article),
                    ),
                  );
                },
                child: SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: CachedNetworkImage(
                            imageUrl: article.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.category,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        article.title,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildFloatingActionBar() {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: Center(
        child: Consumer<BookmarkService>(
          builder: (context, bookmarkService, _) {
            final isBookmarked = bookmarkService.isBookmarked(widget.article.id);
            
            return ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusRound),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                    border: Border.all(
                      color: AppColors.glassBorder,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(
                        icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? AppColors.primary : null,
                        onTap: () {
                          bookmarkService.toggleBookmark(widget.article);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isBookmarked ? 'Đã bỏ lưu' : 'Đã lưu bài viết',
                              ),
                              duration: const Duration(seconds: 1),
                              backgroundColor: AppColors.surfaceDark,
                            ),
                          );
                        },
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: AppColors.glassBorder,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      _buildActionButton(
                        icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? AppColors.error : null,
                        onTap: () {
                          setState(() {
                            _isLiked = !_isLiked;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isLiked ? 'Đã thích bài viết' : 'Đã bỏ thích',
                              ),
                              duration: const Duration(seconds: 1),
                              backgroundColor: AppColors.surfaceDark,
                            ),
                          );
                        },
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: AppColors.glassBorder,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      _buildActionButton(
                        icon: Icons.share,
                        onTap: () {
                          // TODO: Implement share functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Chức năng chia sẻ đang phát triển'),
                              duration: Duration(seconds: 1),
                              backgroundColor: AppColors.surfaceDark,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        color: color ?? AppColors.textSecondary,
        size: 26,
      ),
    );
  }

  void _showTextSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text(
          'Cỡ chữ bài viết',
          style: TextStyle(color: Colors.white),
        ),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Điều chỉnh kích thước chữ để đọc thoải mái hơn',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('A', style: TextStyle(color: Colors.white, fontSize: 14)),
                    Expanded(
                      child: Slider(
                        value: _textScale,
                        min: 0.8,
                        max: 1.5,
                        divisions: 7,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.glassBorder,
                        onChanged: (value) {
                          setState(() {
                            _textScale = value;
                          });
                          setDialogState(() {});
                        },
                      ),
                    ),
                    const Text('A', style: TextStyle(color: Colors.white, fontSize: 24)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Cỡ chữ: ${(_textScale * 100).toInt()}%',
                  style: const TextStyle(color: AppColors.primary, fontSize: 14),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _textScale = 1.0;
              });
              Navigator.pop(context);
            },
            child: const Text('Đặt lại'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Xong'),
          ),
        ],
      ),
    );
  }

  void _showMoreOptionsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.glassBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.report, color: AppColors.error),
                title: const Text('Báo cáo bài viết', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.block, color: AppColors.warning),
                title: const Text('Chặn tác giả', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã chặn ${widget.article.author}'),
                      backgroundColor: AppColors.warning,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.link, color: AppColors.primary),
                title: const Text('Sao chép liên kết', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã sao chép liên kết'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.open_in_browser, color: AppColors.info),
                title: const Text('Mở trong trình duyệt', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đang mở trong trình duyệt...'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportDialog() {
    String? selectedReason;
    final reasons = [
      'Thông tin sai lệch',
      'Nội dung không phù hợp',
      'Spam hoặc quảng cáo',
      'Bạo lực hoặc nguy hiểm',
      'Khác',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          title: const Text(
            'Báo cáo bài viết',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn lý do báo cáo:',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ...reasons.map((reason) => RadioListTile<String>(
                title: Text(reason, style: const TextStyle(color: Colors.white)),
                value: reason,
                groupValue: selectedReason,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  setDialogState(() {
                    selectedReason = value;
                  });
                },
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: selectedReason == null
                  ? null
                  : () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cảm ơn bạn đã báo cáo. Chúng tôi sẽ xem xét.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
              child: const Text('Gửi'),
            ),
          ],
        ),
      ),
    );
  }
}

