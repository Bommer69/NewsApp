import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/app_colors.dart';

/// Widget hiển thị placeholder khi ảnh không load được
class ImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final IconData icon;
  final String? text;
  final BoxFit fit;

  const ImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.icon = Icons.image_not_supported,
    this.text,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceDark,
            AppColors.surfaceDark.withOpacity(0.8),
            AppColors.backgroundDark,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: (width != null && height != null)
                  ? (width! < height! ? width! * 0.3 : height! * 0.3).clamp(24.0, 48.0)
                  : 48,
              color: AppColors.textMuted.withOpacity(0.6),
            ),
            if (text != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.6),
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget helper để tạo CachedNetworkImage với placeholder đẹp
class NewsImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const NewsImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = imageUrl.isEmpty
        ? ImagePlaceholder(
            width: width,
            height: height,
            icon: Icons.image,
            text: 'Không có hình ảnh',
            fit: fit,
          )
        : CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: fit,
            placeholder: (context, url) => Container(
              width: width,
              height: height,
              color: AppColors.surfaceDark,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
            errorWidget: (context, url, error) {
              // Log error để debug (chỉ trong debug mode)
              if (kDebugMode) {
                debugPrint('Image load error: $url - $error');
              }
              return ImagePlaceholder(
                width: width,
                height: height,
                icon: Icons.broken_image,
                text: 'Không thể tải hình ảnh',
                fit: fit,
              );
            },
          );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

