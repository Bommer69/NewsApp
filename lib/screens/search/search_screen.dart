import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_constants.dart';
import '../../data/mock_data.dart';
import '../../models/news_article.dart';
import '../../models/category.dart';
import '../../widgets/liquid_background.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/news_card.dart';
import '../../widgets/category_chip.dart';
import '../detail/detail_screen.dart';

/// Màn hình tìm kiếm
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<NewsArticle> _searchResults = [];
  String _selectedCategoryId = 'all';
  bool _isSearching = false;

  // Trending topics
  final List<Map<String, dynamic>> _trendingTopics = [
    {
      'title': 'AI Revolution',
      'category': 'Tech',
      'categoryColor': AppColors.categoryTech,
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBHVCwRpGKV6Bzs_Y8FBZx4WW6-lZ5KGZnphNmpfocpspOafvp4-MuWIKhENG2sMmoLptFOMtMcYnqX_lJfzkU6mmwKPP-S08_igVlA0vzvljeerq7Xfvrp8elYNwUCd2n6D7jH-5fA5jLASvtD4y-cLdaXMyxVcmCB4BUx-n7hNspsm4WwW2WcMUYlg5TA5PhK-mM5ZhfucKSEE8mOu7Q0wGwacTVpJvHX2z18E9nehXe2c2yACL6VXe1LHN6hx2YS90LoqfhlzA4P',
    },
    {
      'title': 'Crypto Market',
      'category': 'Finance',
      'categoryColor': AppColors.categoryBusiness,
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAhKR_GXbyARg7YiVo_YwCyCWC6JaIf3aP9Mjs_UcxR8Kan3Y4RExssms4k1EecfO5RhEFPCflaExQ-jGt46RiNCIr8XuRQMo0_4_b43Npk5OTaNLmmnbRCANevfjNv1piV4VDugrRDA8ruSJh1kmLS1RVRiXRdIhvTWKopfu_wo2F2N5YxFaG37bCDaPPX8b1f6DYN9a5-gOI7cjz0YE_1gcNc2H6jc2WUA1PZOzyGY1kmzYVIjqqqWbu5rWr_0pWVGQhYJdiO-hmv',
    },
    {
      'title': 'Marathon 2024',
      'category': 'Sports',
      'categoryColor': AppColors.categorySports,
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCgiiNHYLdKjBuT_PnQDdJHFt5_S_8sgcNse3H6wAtRiGy2Y1kjcjAZ5C49sdEoGfyfBnxpIGMDoBrUqyzJil0n3Bcu2lvqn2wKLWzMJGQ98ybPSY1-XEdRF0-3VAH1-iQY9LUkdZvRvtXVbVgCxdKbUo0CT-Q4e1uqJE-gO5v1BgHBD-ZsZOwSIzvxJa-jEBWOgQ2EZ7v_oJR7DM-im-lB7U8EYnYZ2bhtYqqwescGlZqG_4n4Ci55due7WSI5-5jOl9tmAGqLoxFD',
    },
    {
      'title': 'Fashion Week',
      'category': 'Lifestyle',
      'categoryColor': AppColors.categoryLifestyle,
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD_LBtm3d-PSukdkeD8Am0vcXnvoleme2PVW8LlIznofzUfECr8h6cTUgqkzLJQyjSTwmqqG99GVmPUiRZ1x9zd1Sirak3sfyYLVnVJ0IxQx5fa311f5JsTOvJkeRiecjakJUFgG1U0z74FlvXzXoSPY2gq3d27oc54E0gwrFrJlSQNUS6ExBNYEEEy7VDSuZLgL_nzF8zhCa5ESdgqjCb4hqYfuAwNZojIrkVaEGcF9g9TSSBYyWXUA3WiPek9K0X2e47lk3H5OwPS',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchResults = MockData.articles;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _searchResults = MockData.articles;
      } else {
        _searchResults = MockData.searchArticles(query);
      }
    });
  }

  void _onCategorySelected(NewsCategory category) {
    setState(() {
      _selectedCategoryId = category.id;
      if (category.id == 'all') {
        _searchResults = MockData.articles;
      } else {
        _searchResults = MockData.getArticlesByCategory(category.name);
      }
    });
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
              
              // Search bar
              _buildSearchBar(),
              
              // Category chips
              const SizedBox(height: 16),
              CategoryChipList(
                categories: [NewsCategories.all, ...NewsCategories.allCategories],
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: _onCategorySelected,
              ),
              
              // Content
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Trending topics section (only show when not searching)
                    if (!_isSearching) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Chủ đề xu hướng',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  _showAllTrendingTopics();
                                },
                                child: const Text('Xem thêm'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildTrendingTopicsGrid(),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                          child: Text(
                            'Tin mới nhất',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                    ],
                    
                    // Search results or latest news
                    if (_isSearching && _searchResults.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: AppColors.textMuted.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Không tìm thấy kết quả',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: NewsCard(
                                  article: _searchResults[index],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          article: _searchResults[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            childCount: _searchResults.length,
                          ),
                        ),
                      ),
                    
                    // Bottom padding
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GlassButton(
            onPressed: () => Navigator.pop(context),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Text(
            'Tìm kiếm',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              color: AppColors.textMuted,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm chủ đề, bài viết...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: _performSearch,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic, color: AppColors.textMuted),
              onPressed: () {
                // TODO: Implement voice search
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingTopicsGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final topic = _trendingTopics[index];
            return _buildTrendingTopicCard(
              title: topic['title'],
              category: topic['category'],
              categoryColor: topic['categoryColor'],
              imageUrl: topic['imageUrl'],
            );
          },
          childCount: _trendingTopics.length,
        ),
      ),
    );
  }

  Widget _buildTrendingTopicCard({
    required String title,
    required String category,
    required Color categoryColor,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        _searchController.text = title;
        _performSearch(title);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            border: Border.all(
              color: AppColors.glassBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: AppColors.surfaceDark);
                },
              ),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        color: categoryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  void _showAllTrendingTopics() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chủ đề xu hướng',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _trendingTopics.length * 2, // More topics
                  itemBuilder: (context, index) {
                    final topic = _trendingTopics[index % _trendingTopics.length];
                    return _buildTrendingTopicCard(
                      title: topic['title'] as String,
                      category: topic['category'] as String,
                      categoryColor: topic['color'] as Color,
                      imageUrl: topic['image'] as String,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

