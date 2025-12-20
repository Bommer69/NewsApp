import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../config/app_constants.dart';
import '../../models/news_article.dart';
import '../../models/category.dart';
import '../../providers/news_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/liquid_background.dart';
import '../../widgets/news_card.dart';
import '../../widgets/glass_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategoryId = 'latest';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().loadHome();
    });
  }

  void _onCategorySelected(NewsCategory category) {
    setState(() {
      _selectedCategoryId = category.id;
    });

    final news = context.read<NewsProvider>();
    if (category.id == 'latest' || category.id == 'all') {
      news.loadHome();
    } else {
      news.loadByCategory(category.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final news = context.watch<NewsProvider>();
    final articles = news.articles;
    final featured = news.articles.take(5).toList();


    return Scaffold(
      body: LiquidBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              CategoryChipList(
                categories: NewsCategories.allCategories,
                selectedCategoryId: _selectedCategoryId,
                onCategorySelected: _onCategorySelected,
              ),
              if (news.isLoading) const LinearProgressIndicator(),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: articles.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return NewsCard(
                      article: articles[index],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: articles[index],
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
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        return GlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tin tức hôm nay',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
