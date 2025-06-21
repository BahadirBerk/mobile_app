import 'package:flutter/material.dart';
import '../../../services/daily_quote_service.dart';

class DailyQuoteWidget extends StatefulWidget {
  const DailyQuoteWidget({super.key});

  @override
  State<DailyQuoteWidget> createState() => _DailyQuoteWidgetState();
}

class _DailyQuoteWidgetState extends State<DailyQuoteWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _quoteAnimationController;
  late AnimationController _explanationAnimationController;
  late AnimationController _heightAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _quoteFadeAnimation;
  late Animation<Offset> _explanationSlideAnimation;
  late Animation<double> _explanationFadeAnimation;
  late Animation<double> _heightAnimation;
  
  bool _isExpanded = false;
  bool _showQuote = false;
  bool _showMeaning = false;
  
  final DailyQuoteService _quoteService = DailyQuoteService.instance;
  DailyQuote? _currentQuote;

  @override
  void initState() {
    super.initState();
    _loadQuote();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _quoteAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _explanationAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    
    _heightAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _quoteFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _quoteAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _explanationSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _explanationAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _explanationFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _explanationAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _heightAnimation = Tween<double>(
      begin: 180.0,
      end: 280.0,
    ).animate(CurvedAnimation(
      parent: _heightAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  Future<void> _loadQuote() async {
    final quote = await _quoteService.getDailyQuote();
    if (mounted) {
      setState(() {
        _currentQuote = quote;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _quoteAnimationController.dispose();
    _explanationAnimationController.dispose();
    _heightAnimationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_isExpanded) {
      setState(() {
        _isExpanded = true;
        _showQuote = true;
      });
      
      _animationController.forward();
      _quoteAnimationController.forward();
      
      // Counter'ı artır
      _quoteService.incrementCounter();
      
      // 3 saniye sonra açıklamayı göster ve yüksekliği artır
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showMeaning = true;
          });
          _explanationAnimationController.forward();
          _heightAnimationController.forward();
        }
      });
    } else {
      setState(() {
        _isExpanded = false;
        _showQuote = false;
        _showMeaning = false;
      });
      
      _animationController.reverse();
      _quoteAnimationController.reverse();
      _explanationAnimationController.reverse();
      _heightAnimationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuote == null) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E8B57),
              Color(0xFF20B2AA),
              Color(0xFF48CAE4),
            ],
          ),
          borderRadius: BorderRadius.circular(60),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        _animationController,
        _heightAnimationController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: GestureDetector(
              onTap: _handleTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                width: _isExpanded ? 300 : 120,
                height: _isExpanded 
                    ? (_showMeaning ? _heightAnimation.value : 180)
                    : 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2E8B57),
                      Color(0xFF20B2AA),
                      Color(0xFF48CAE4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(_isExpanded ? 20 : 60),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: _isExpanded ? _buildExpandedContent() : _buildCollapsedContent(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCollapsedContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: Colors.white,
            size: 36,
          ),
          const SizedBox(height: 8),
          Text(
            '${_quoteService.dailyCounter}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Gün',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Günlük counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${_quoteService.dailyCounter}. Gün',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _handleTap,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Latin quote with enhanced animation
          if (_showQuote)
            FadeTransition(
              opacity: _quoteFadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  _currentQuote!.latin,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          
          const SizedBox(height: 12),
          
          // Türkçe açıklama with slide-down animation
          if (_showMeaning)
            SlideTransition(
              position: _explanationSlideAnimation,
              child: FadeTransition(
                opacity: _explanationFadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _currentQuote!.aciklama,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 