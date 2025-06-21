import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/daily_quote_service.dart';
import '../../../theme/theme_provider.dart';

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
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _quoteFadeAnimation;
  late Animation<Offset> _explanationSlideAnimation;
  late Animation<double> _explanationFadeAnimation;
  
  bool _isExpanded = false;
  bool _showQuote = false;
  bool _showMeaning = false;
  
  final DailyQuoteService _quoteService = DailyQuoteService.instance;
  DailyQuote? _currentQuote;

  static const List<String> _randomWords = [
    'motus', 'impulsus', 'stimulus',
    'idea', 'notio', 'cogitatio',
    'sensus', 'significatio', 'ratio',
  ];
  late String _selectedWord;

  @override
  void initState() {
    super.initState();
    final shuffledList = List<String>.from(_randomWords)..shuffle();
    _selectedWord = shuffledList.first;
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _quoteAnimationController.dispose();
    _explanationAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadQuote() async {
    final quote = await _quoteService.getDailyQuote();
    if (mounted) {
      setState(() {
        _currentQuote = quote;
      });
    }
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
      
      // 3 saniye sonra açıklamayı göster
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showMeaning = true;
          });
          _explanationAnimationController.forward();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (_currentQuote == null) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: themeProvider.primaryGradient,
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
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              width: _isExpanded ? screenWidth - 32 : 120,
              height: _isExpanded ? 280 : 120,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: themeProvider.primaryGradient,
                borderRadius: BorderRadius.circular(_isExpanded ? 20 : 60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: themeProvider.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(_isExpanded ? 20 : 60),
                  onTap: _handleTap,
                  child: Container(
                    padding: EdgeInsets.all(_isExpanded ? 24 : 0),
                    child: _isExpanded
                        ? _buildExpandedContent(themeProvider)
                        : _buildCollapsedContent(themeProvider),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCollapsedContent(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            _selectedWord,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(ThemeProvider themeProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          // Quote
          if (_showQuote)
            AnimatedBuilder(
              animation: _quoteAnimationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _quoteFadeAnimation.value,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _currentQuote!.latin.replaceAll('"', ''),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
          // Explanation
          if (_showMeaning)
            AnimatedBuilder(
              animation: _explanationAnimationController,
              builder: (context, child) {
                return SlideTransition(
                  position: _explanationSlideAnimation,
                  child: FadeTransition(
                    opacity: _explanationFadeAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentQuote!.aciklama,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
} 