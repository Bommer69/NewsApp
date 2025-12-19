import 'package:flutter/material.dart';
import '../config/app_colors.dart';

/// Model cho danh mục tin tức
class NewsCategory {
  final String id;
  final String name;
  final String nameEn;
  final IconData icon;
  final Color color;
  final String? imageUrl;

  const NewsCategory({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.icon,
    required this.color,
    this.imageUrl,
  });
}

/// Danh sách các danh mục có sẵn
class NewsCategories {
  static const NewsCategory all = NewsCategory(
    id: 'all',
    name: 'Tất cả',
    nameEn: 'All',
    icon: Icons.local_fire_department,
    color: AppColors.primary,
  );
  
  static const NewsCategory latest = NewsCategory(
    id: 'latest',
    name: 'Mới nhất',
    nameEn: 'Latest',
    icon: Icons.local_fire_department,
    color: AppColors.primary,
  );

  static const NewsCategory world = NewsCategory(
    id: 'world',
    name: 'Thế giới',
    nameEn: 'World',
    icon: Icons.public,
    color: Color(0xFF3B82F6),
  );

  static const NewsCategory technology = NewsCategory(
    id: 'technology',
    name: 'Công nghệ',
    nameEn: 'Technology',
    icon: Icons.memory,
    color: AppColors.categoryTech,
  );

  static const NewsCategory business = NewsCategory(
    id: 'business',
    name: 'Kinh doanh',
    nameEn: 'Business',
    icon: Icons.trending_up,
    color: AppColors.categoryBusiness,
  );

  static const NewsCategory sports = NewsCategory(
    id: 'sports',
    name: 'Thể thao',
    nameEn: 'Sports',
    icon: Icons.sports_soccer,
    color: AppColors.categorySports,
  );

  static const NewsCategory lifestyle = NewsCategory(
    id: 'lifestyle',
    name: 'Đời sống',
    nameEn: 'Lifestyle',
    icon: Icons.style,
    color: AppColors.categoryLifestyle,
  );

  static const NewsCategory science = NewsCategory(
    id: 'science',
    name: 'Khoa học',
    nameEn: 'Science',
    icon: Icons.science,
    color: AppColors.categoryScience,
  );

  static const NewsCategory economy = NewsCategory(
    id: 'economy',
    name: 'Kinh tế',
    nameEn: 'Economy',
    icon: Icons.monetization_on,
    color: AppColors.categoryBusiness,
  );

  static const List<NewsCategory> allCategories = [
    latest,
    world,
    technology,
    business,
    sports,
    lifestyle,
    science,
  ];

  static NewsCategory? getCategoryById(String id) {
    try {
      return allCategories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }
}

