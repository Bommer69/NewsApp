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

class DetailScreen extends StatefulWidget {
  final NewsArticle article;

  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late List<NewsArticle> _relatedArticles;

  @override
  void initState() {
    super.initState();
    _relatedArticles = widget.article.relatedArticles ?? [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_relatedArticles.isEmpty) {
        final news = context.read<NewsProvider>();
        final related = news.articles
            .where((a) =>
                a.id != widget.article.id &&
                (a.category == widget.article.category ||
                    a.tags.any(widget.article.tags.contains)))
            .take(2)
            .toList();
        setState(() {
          _relatedArticles = related;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: NewsImage(
                imageUrl: widget.article.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.article.title,
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 16),
                  Text(widget.article.content),
                  const SizedBox(height: 32),
                  if (_relatedArticles.isNotEmpty)
                    Text('Tin liên quan',
                        style:
                            Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
