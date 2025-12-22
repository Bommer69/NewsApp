import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../config/app_constants.dart';
import '../../models/news_article.dart';
import '../../models/category.dart';
import '../../providers/news_provider.dart';
import '../../widgets/liquid_background.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/news_card.dart';
import '../../widgets/category_chip.dart';
import '../detail/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategoryId = 'all';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final news = context.read<NewsProvider>();
      if (news.articles.isEmpty) {
        news.loadHome();
      }
    });
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    final news = context.read<NewsProvider>();

    if (query.trim().isEmpty) {
      news.clearSearch();
      if (_selectedCategoryId == 'all' || _selectedCategoryId == 'latest') {
        news.loadHome();
      } else {
        news.loadByCategory(_selectedCategoryId);
      }
    } else {
      news.search(query.trim());
    }
  }

  void _onCategorySelected(NewsCategory category) {
    setState(() {
      _selectedCategoryId = category.id;
      _isSearching = false;
      _searchController.clear();
    });

    final news = context.read<NewsProvider>();
    if (category.id == 'all' || category.id == 'latest') {
      news.loadHome();
    } else {
      news.loadByCategory(category.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final news = context.watch<NewsProvider>();
    final List<NewsArticle> listToShow =
        _isSearching ? news.searchResults : news.articles;

    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              const SizedBox(height: 16),
              CategoryChipList(
                categories: [NewsCategories.all, ...NewsCategories.allCategories],
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: _onCategorySelected,
              ),
              if (news.isLoading) const LinearProgressIndicator(),
              Expanded(
                child: listToShow.isEmpty
                    ? Center(
                        child: Text(
                          'Không có dữ liệu',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textMuted),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: listToShow.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final article = listToShow[index];
                          return NewsCard(
                            article: article,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailScreen(article: article),
                                ),
                              );
                            },
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GlassButton(
            onPressed: () => Navigator.pop(context),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.arrow_back,
                size: 24, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Text(
            'Tìm kiếm',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm bài viết...',
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
        ),
      ),
    );
  }
}
