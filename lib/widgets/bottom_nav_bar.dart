import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_constants.dart';

/// Bottom navigation bar với hiệu ứng glass
class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark.withOpacity(0.65),
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: 'Trang chủ',
                  index: 0,
                  isSelected: currentIndex == 0,
                ),
                _buildNavItem(
                  icon: Icons.explore,
                  label: 'Khám phá',
                  index: 1,
                  isSelected: currentIndex == 1,
                ),
                _buildNavItem(
                  icon: Icons.bookmark,
                  label: 'Đã lưu',
                  index: 2,
                  isSelected: currentIndex == 2,
                ),
                _buildNavItem(
                  icon: Icons.person,
                  label: 'Hồ sơ',
                  index: 3,
                  isSelected: currentIndex == 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: AppConstants.animationDuration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Indicator dot
              AnimatedContainer(
                duration: AppConstants.animationDuration,
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
              
              // Icon
              AnimatedContainer(
                duration: AppConstants.animationDuration,
                child: Icon(
                  icon,
                  size: isSelected ? 28 : 24,
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                ),
              ),
              
              // Label (optional - can be removed for cleaner look)
              // const SizedBox(height: 2),
              // Text(
              //   label,
              //   style: TextStyle(
              //     fontSize: 10,
              //     color: isSelected ? AppColors.primary : AppColors.textMuted,
              //     fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

