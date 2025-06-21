import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';

class ParallaxBackground extends StatefulWidget {
  final bool isDarkMode;
  final Widget child;

  const ParallaxBackground({
    super.key,
    required this.isDarkMode,
    required this.child,
  });

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground>
    with TickerProviderStateMixin {
  late AnimationController _cloudController;
  late AnimationController _starController;
  late AnimationController _sunController;
  late AnimationController _moonController;
  late AnimationController _transitionController;

  late Animation<double> _cloudAnimation;
  late Animation<double> _starAnimation;
  late Animation<double> _sunAnimation;
  late Animation<double> _moonAnimation;
  late Animation<double> _transitionAnimation;

  @override
  void initState() {
    super.initState();
    
    _cloudController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
    
    _starController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _sunController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    
    _moonController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();
    
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _cloudAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cloudController,
      curve: Curves.linear,
    ));
    
    _starAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _starController,
      curve: Curves.linear,
    ));
    
    _sunAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sunController,
      curve: Curves.linear,
    ));
    
    _moonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _moonController,
      curve: Curves.linear,
    ));
    
    _transitionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(ParallaxBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      _transitionController.forward().then((_) {
        _transitionController.reset();
      });
    }
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _starController.dispose();
    _sunController.dispose();
    _moonController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Parallax Background
        AnimatedBuilder(
          animation: Listenable.merge([
            _cloudAnimation,
            _starAnimation,
            _sunAnimation,
            _moonAnimation,
            _transitionAnimation,
          ]),
          builder: (context, child) {
            return CustomPaint(
              painter: ParallaxPainter(
                isDarkMode: widget.isDarkMode,
                cloudProgress: _cloudAnimation.value,
                starProgress: _starAnimation.value,
                sunProgress: _sunAnimation.value,
                moonProgress: _moonAnimation.value,
                transitionProgress: _transitionAnimation.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class ParallaxPainter extends CustomPainter {
  final bool isDarkMode;
  final double cloudProgress;
  final double starProgress;
  final double sunProgress;
  final double moonProgress;
  final double transitionProgress;

  ParallaxPainter({
    required this.isDarkMode,
    required this.cloudProgress,
    required this.starProgress,
    required this.sunProgress,
    required this.moonProgress,
    required this.transitionProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Background gradient
    final backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDarkMode
          ? [
              const Color(0xFF0F0F23),
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
            ]
          : [
              const Color(0xFF87CEEB),
              const Color(0xFF98D8E8),
              const Color(0xFFF4F2F8),
            ],
    );
    
    paint.shader = backgroundGradient.createShader(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    if (isDarkMode) {
      _drawNightElements(canvas, size, paint);
    } else {
      _drawDayElements(canvas, size, paint);
    }
  }

  void _drawDayElements(Canvas canvas, Size size, Paint paint) {
    // Sun
    final sunRadius = 40.0;
    final sunX = size.width * 0.8 + (sunProgress * 100);
    final sunY = size.height * 0.15;
    
    // Sun glow
    paint.color = const Color(0xFFFFD93D).withOpacity(0.3);
    canvas.drawCircle(
      Offset(sunX, sunY),
      sunRadius + 20,
      paint,
    );
    
    // Sun core
    paint.color = const Color(0xFFFFD93D);
    canvas.drawCircle(
      Offset(sunX, sunY),
      sunRadius,
      paint,
    );

    // Clouds (3 layers with different speeds)
    _drawClouds(canvas, size, paint, 0.3, 0.1); // Far clouds
    _drawClouds(canvas, size, paint, 0.6, 0.2); // Medium clouds
    _drawClouds(canvas, size, paint, 0.9, 0.3); // Near clouds
  }

  void _drawNightElements(Canvas canvas, Size size, Paint paint) {
    // Moon
    final moonRadius = 35.0;
    final moonX = size.width * 0.8 + (moonProgress * 80);
    final moonY = size.height * 0.15;
    
    // Moon glow
    paint.color = const Color(0xFFF8F9FA).withOpacity(0.2);
    canvas.drawCircle(
      Offset(moonX, moonY),
      moonRadius + 15,
      paint,
    );
    
    // Moon
    paint.color = const Color(0xFFF8F9FA);
    canvas.drawCircle(
      Offset(moonX, moonY),
      moonRadius,
      paint,
    );

    // Stars (3 layers with different speeds)
    _drawStars(canvas, size, paint, 0.2, 0.05); // Far stars
    _drawStars(canvas, size, paint, 0.5, 0.1);  // Medium stars
    _drawStars(canvas, size, paint, 0.8, 0.15); // Near stars
  }

  void _drawClouds(Canvas canvas, Size size, Paint paint, double yPosition, double speed) {
    paint.color = Colors.white.withOpacity(0.7);
    
    for (int i = 0; i < 5; i++) {
      final cloudX = (i * 200 + cloudProgress * speed * 1000) % (size.width + 200) - 100;
      final cloudY = size.height * yPosition + (i * 20);
      
      _drawCloud(canvas, Offset(cloudX, cloudY), paint);
    }
  }

  void _drawCloud(Canvas canvas, Offset center, Paint paint) {
    final cloudRadius = 25.0;
    
    // Main cloud body
    canvas.drawCircle(center, cloudRadius, paint);
    canvas.drawCircle(Offset(center.dx - 20, center.dy), cloudRadius * 0.8, paint);
    canvas.drawCircle(Offset(center.dx + 20, center.dy), cloudRadius * 0.8, paint);
    canvas.drawCircle(Offset(center.dx, center.dy - 15), cloudRadius * 0.7, paint);
  }

  void _drawStars(Canvas canvas, Size size, Paint paint, double yPosition, double speed) {
    paint.color = Colors.white.withOpacity(0.8);
    
    for (int i = 0; i < 20; i++) {
      final starX = (i * 50 + starProgress * speed * 1000) % (size.width + 50) - 25;
      final starY = size.height * yPosition + (i * 30);
      
      // Twinkling effect
      final twinkle = (starProgress + i * 0.1) % 1.0;
      final opacity = 0.3 + 0.7 * (0.5 + 0.5 * sin(twinkle * 2 * pi));
      
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(Offset(starX, starY), 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(ParallaxPainter oldDelegate) {
    return oldDelegate.isDarkMode != isDarkMode ||
           oldDelegate.cloudProgress != cloudProgress ||
           oldDelegate.starProgress != starProgress ||
           oldDelegate.sunProgress != sunProgress ||
           oldDelegate.moonProgress != moonProgress ||
           oldDelegate.transitionProgress != transitionProgress;
  }
} 