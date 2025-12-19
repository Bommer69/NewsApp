import 'package:flutter/material.dart';
import '../config/app_colors.dart';

/// Background với hiệu ứng liquid/blob gradient
class LiquidBackground extends StatelessWidget {
  final Widget child;
  
  const LiquidBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(
          color: AppColors.backgroundDark,
        ),
        
        // Liquid blobs
        Positioned(
          top: -100,
          left: -100,
          child: _LiquidBlob(
            size: 500,
            colors: AppColors.liquidGradient1,
            animationDelay: 0,
          ),
        ),
        Positioned(
          bottom: 100,
          right: -50,
          child: _LiquidBlob(
            size: 400,
            colors: AppColors.liquidGradient2,
            animationDelay: 2,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: 100,
          child: _LiquidBlob(
            size: 300,
            colors: AppColors.liquidGradient3,
            animationDelay: 4,
          ),
        ),
        
        // Content
        child,
      ],
    );
  }
}

class _LiquidBlob extends StatefulWidget {
  final double size;
  final List<Color> colors;
  final int animationDelay;

  const _LiquidBlob({
    required this.size,
    required this.colors,
    required this.animationDelay,
  });

  @override
  State<_LiquidBlob> createState() => _LiquidBlobState();
}

class _LiquidBlobState extends State<_LiquidBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Delay start based on animationDelay
    Future.delayed(Duration(seconds: widget.animationDelay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            30 * _animation.value,
            -50 * _animation.value,
          ),
          child: Transform.scale(
            scale: 0.9 + (0.2 * _animation.value),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: widget.colors,
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

