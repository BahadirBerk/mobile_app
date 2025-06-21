import 'package:flutter/material.dart';
import '../../../services/daily_quote_service.dart';

class DailyQuoteScreen extends StatefulWidget {
  const DailyQuoteScreen({super.key});

  @override
  State<DailyQuoteScreen> createState() => _DailyQuoteScreenState();
}

class _DailyQuoteScreenState extends State<DailyQuoteScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _quoteAnimationController;
  late AnimationController _meaningAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _quoteFadeAnimation;
  late Animation<double> _meaningFadeAnimation;
  
  bool _showQuote = false;
  bool _showMeaning = false;
  bool _canIncrement = true;
  
  final DailyQuoteService _quoteService = DailyQuoteService.instance;
  DailyQuote? _currentQuote;
  String _remainingTime = '';

  @override
  void initState() {
    super.initState();
    _loadQuote();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _quoteAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _meaningAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _quoteFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _quoteAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _meaningFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _meaningAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
    
    // 1 saniye sonra quote'u göster
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _showQuote = true);
        _quoteAnimationController.forward();
      }
    });
    
    // 3 saniye sonra anlamı göster
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showMeaning = true);
        _meaningAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _quoteAnimationController.dispose();
    _meaningAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadQuote() async {
    _currentQuote = await _quoteService.getDailyQuote();
    _remainingTime = _quoteService.getRemainingTimeFormatted();
    setState(() {});
  }

  Future<void> _handleTap() async {
    if (!_canIncrement) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('24 saat içinde sadece bir kez tıklayabilirsin. Kalan süre: $_remainingTime'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = await _quoteService.incrementCounter();
    if (success) {
      setState(() {
        _canIncrement = false;
        _remainingTime = _quoteService.getRemainingTimeFormatted();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Günlük motivasyonun kaydedildi!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2E8B57),
              Color(0xFF20B2AA),
              Color(0xFF48CAE4),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Close Button
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),

              // Main Content
              Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.7,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Daily Counter
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_quoteService.dailyCounter}. Gün',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Quote Icon
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.lightbulb,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Latin Quote
                              if (_showQuote && _currentQuote != null)
                                AnimatedBuilder(
                                  animation: _quoteAnimationController,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity: _quoteFadeAnimation.value,
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Text(
                                              _currentQuote!.latin,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              // Meaning
                              if (_showMeaning && _currentQuote != null)
                                AnimatedBuilder(
                                  animation: _meaningAnimationController,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity: _meaningFadeAnimation.value,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 20),
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          _currentQuote!.aciklama,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            height: 1.6,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              const SizedBox(height: 40),

                              // Action Button
                              if (_showMeaning)
                                AnimatedBuilder(
                                  animation: _meaningAnimationController,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity: _meaningFadeAnimation.value,
                                      child: Column(
                                        children: [
                                          ElevatedButton(
                                            onPressed: _handleTap,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _canIncrement 
                                                  ? Colors.white 
                                                  : Colors.white.withOpacity(0.5),
                                              foregroundColor: const Color(0xFF2E8B57),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 30,
                                                vertical: 15,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: Text(
                                              _canIncrement 
                                                  ? 'Motivasyonumu Kaydet' 
                                                  : 'Bugün Kaydedildi',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            _canIncrement 
                                                ? 'Bu butona tıklayarak günlük motivasyonunu kaydedebilirsin'
                                                : 'Yarın tekrar deneyebilirsin',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.8),
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
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
} 