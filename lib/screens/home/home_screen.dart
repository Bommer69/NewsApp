import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_constants.dart';
import '../../data/mock_data.dart';
import '../../models/category.dart';
import '../../models/news_article.dart';
import '../../services/auth_service.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/liquid_background.dart';
import '../../widgets/news_card.dart';
import '../../widgets/glass_container.dart';

/// Màn hình trang chủ hiển thị bảng tin
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategoryId = 'latest';
  late List<NewsArticle> _displayedArticles;
  late List<NewsArticle> _featuredArticles;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles() {
    _displayedArticles = MockData.articles;
    _featuredArticles = MockData.featuredArticles;
  }

  void _onCategorySelected(NewsCategory category) {
    setState(() {
      _selectedCategoryId = category.id;
      if (category.id == 'latest' || category.id == 'all') {
        _displayedArticles = MockData.articles;
      } else {
        _displayedArticles = MockData.getArticlesByCategory(category.name);
      }
    });
  }

  void _onArticleTap(NewsArticle article) {
    // TODO: Navigate to detail screen
    Navigator.pushNamed(context, '/detail', arguments: article);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Content
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Date display
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tin tức hôm nay',
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getFormattedDate(),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to search với tất cả tin tức
                                Navigator.pushNamed(context, '/search');
                              },
                              child: const Text('Xem tất cả'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Category chips
                    SliverToBoxAdapter(
                      child: CategoryChipList(
                        categories: NewsCategories.allCategories,
                        selectedCategoryId: _selectedCategoryId,
                        onCategorySelected: _onCategorySelected,
                      ),
                    ),
                    
                    const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    
                    // Featured carousel
                    if (_featuredArticles.isNotEmpty)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 220,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: _featuredArticles.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              return FeaturedNewsCard(
                                article: _featuredArticles[index],
                                onTap: () => _onArticleTap(_featuredArticles[index]),
                              );
                            },
                          ),
                        ),
                      ),
                    
                    // Section title
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Dành cho bạn',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // News list
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: NewsCard(
                                article: _displayedArticles[index],
                                onTap: () => _onArticleTap(_displayedArticles[index]),
                              ),
                            );
                          },
                          childCount: _displayedArticles.length,
                        ),
                      ),
                    ),
                    
                    // Bottom padding for navigation bar
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        return GlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User info
              Row(
                children: [
                  // Avatar with online indicator
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (authService.userName ?? 'U')[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (authService.isLoggedIn)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.backgroundDark,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  
                  // Greeting
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Xin chào,',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        authService.userName ?? 'Khách',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          
              // Action buttons
              Row(
                children: [
                  _buildIconButton(Icons.search, () {
                    Navigator.pushNamed(context, '/search');
                  }),
                  const SizedBox(width: 8),
                  _buildIconButton(
                    Icons.notifications,
                    () {
                      _showNotificationsDialog();
                    },
                    showBadge: true,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNotificationItem(
              'Tin mới',
              'Bài viết về AI mới được đăng',
              '5 phút trước',
              Icons.article,
            ),
            const Divider(color: AppColors.glassBorder),
            _buildNotificationItem(
              'Cập nhật',
              'Ứng dụng có phiên bản mới',
              '1 giờ trước',
              Icons.system_update,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {bool showBadge = false}) {
    return GlassButton(
      onPressed: onTap,
      padding: const EdgeInsets.all(10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: 20, color: Colors.white),
          if (showBadge)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final weekdays = ['Chủ nhật', 'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy'];
    return '${weekdays[now.weekday % 7]}, ${now.day} Tháng ${now.month}';
  }
}

