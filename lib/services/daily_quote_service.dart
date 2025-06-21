import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuote {
  final String latin;
  final String aciklama;

  DailyQuote({
    required this.latin,
    required this.aciklama,
  });
}

class DailyQuoteService {
  static final DailyQuoteService _instance = DailyQuoteService._internal();
  factory DailyQuoteService() => _instance;
  DailyQuoteService._internal();

  static DailyQuoteService get instance => _instance;

  List<DailyQuote> _allQuotes = [];
  List<DailyQuote> _availableQuotes = [];
  DailyQuote? _currentQuote;
  
  int _dailyCounter = 0;
  DateTime? _lastUpdateDate;
  DateTime? _lastQuoteTime;

  // Günlük quote'u al
  Future<DailyQuote> getDailyQuote() async {
    await _loadQuotes();
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Eğer yeni bir günse, counter'ı sıfırla
    if (_lastUpdateDate == null || _lastUpdateDate!.isBefore(today)) {
      _dailyCounter = 0;
      _lastUpdateDate = today;
      _lastQuoteTime = null;
    }

    // Eğer henüz quote seçilmemişse veya 24 saat geçmişse
    if (_currentQuote == null || _shouldShowNewQuote()) {
      _currentQuote = _getRandomQuote();
      _lastQuoteTime = now;
    }

    return _currentQuote!;
  }

  // 24 saat içinde yeni quote gösterilmeli mi?
  bool _shouldShowNewQuote() {
    if (_lastQuoteTime == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(_lastQuoteTime!);
    return difference.inHours >= 24;
  }

  // Counter'ı artır (24 saat içinde sadece 1 kez)
  Future<bool> incrementCounter() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Eğer yeni bir günse, counter'ı sıfırla
    if (_lastUpdateDate == null || _lastUpdateDate!.isBefore(today)) {
      _dailyCounter = 0;
      _lastUpdateDate = today;
      _lastQuoteTime = null;
      await _saveCounter();
      return true;
    }

    // Eğer 24 saat geçmemişse, artırma
    if (!_shouldShowNewQuote()) {
      return false;
    }

    _dailyCounter++;
    _lastQuoteTime = now;
    await _saveCounter();
    return true;
  }

  // Günlük counter'ı al
  int get dailyCounter => _dailyCounter;

  // Son güncelleme tarihini al
  DateTime? get lastUpdateDate => _lastUpdateDate;

  // Son quote zamanını al
  DateTime? get lastQuoteTime => _lastQuoteTime;

  // Rastgele quote seç
  DailyQuote _getRandomQuote() {
    if (_availableQuotes.isEmpty) {
      // Tüm quote'lar okunmuşsa, listeyi yenile
      _availableQuotes = List.from(_allQuotes);
    }
    
    final random = Random();
    final index = random.nextInt(_availableQuotes.length);
    final quote = _availableQuotes[index];
    
    // Seçilen quote'u listeden çıkar
    _availableQuotes.removeAt(index);
    
    return quote;
  }

  // TXT dosyasından quote'ları yükle
  Future<void> _loadQuotes() async {
    if (_allQuotes.isNotEmpty) return;

    try {
      final String response = await rootBundle.loadString('assets/latin.txt');
      final List<String> lines = response.split('\n');
      
      String? currentLatin;
      String? currentAciklama;
      
      for (String line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;
        
        if (line.startsWith('Latin: "')) {
          currentLatin = line.substring(7, line.length - 1);
        } else if (line.startsWith('Aciklama: "')) {
          currentAciklama = line.substring(11, line.length - 1);
          
          if (currentLatin != null && currentAciklama != null) {
            _allQuotes.add(DailyQuote(
              latin: currentLatin,
              aciklama: currentAciklama,
            ));
            currentLatin = null;
            currentAciklama = null;
          }
        }
      }
      
      // İlk yüklemede available quotes'ları ayarla
      if (_availableQuotes.isEmpty) {
        _availableQuotes = List.from(_allQuotes);
      }
      
      await _loadCounter();
    } catch (e) {
      // Hata durumunda varsayılan quote'lar
      _allQuotes = [
        DailyQuote(
          latin: "Carpe Diem",
          aciklama: "Günü yakala ve her anı değerlendir.",
        ),
        DailyQuote(
          latin: "Veni, Vidi, Vici",
          aciklama: "Geldim, gördüm, yendim.",
        ),
      ];
      _availableQuotes = List.from(_allQuotes);
    }
  }

  // Counter'ı kaydet
  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_quote_counter', _dailyCounter);
    await prefs.setString('last_update_date', _lastUpdateDate?.toIso8601String() ?? '');
    await prefs.setString('last_quote_time', _lastQuoteTime?.toIso8601String() ?? '');
    
    // Okunan quote'ları kaydet
    final readQuotes = _allQuotes.where((q) => !_availableQuotes.contains(q)).map((q) => q.latin).toList();
    await prefs.setStringList('read_quotes', readQuotes);
  }

  // Counter'ı yükle
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _dailyCounter = prefs.getInt('daily_quote_counter') ?? 0;
    
    final lastUpdateStr = prefs.getString('last_update_date');
    if (lastUpdateStr != null) {
      _lastUpdateDate = DateTime.parse(lastUpdateStr);
    }
    
    final lastQuoteStr = prefs.getString('last_quote_time');
    if (lastQuoteStr != null) {
      _lastQuoteTime = DateTime.parse(lastQuoteStr);
    }
    
    // Okunan quote'ları yükle
    final readQuotes = prefs.getStringList('read_quotes') ?? [];
    _availableQuotes = _allQuotes.where((q) => !readQuotes.contains(q.latin)).toList();
    
    // Eğer tüm quote'lar okunmuşsa, listeyi yenile
    if (_availableQuotes.isEmpty) {
      _availableQuotes = List.from(_allQuotes);
    }
  }

  // Kalan süreyi hesapla (24 saatlik periyot için)
  Duration getRemainingTime() {
    if (_lastQuoteTime == null) return Duration.zero;
    
    final now = DateTime.now();
    final nextQuoteTime = _lastQuoteTime!.add(const Duration(hours: 24));
    final difference = nextQuoteTime.difference(now);
    
    return difference.isNegative ? Duration.zero : difference;
  }

  // Kalan süreyi formatla
  String getRemainingTimeFormatted() {
    final remaining = getRemainingTime();
    if (remaining.inHours > 0) {
      return '${remaining.inHours}s ${remaining.inMinutes % 60}dk';
    } else {
      return '${remaining.inMinutes}dk';
    }
  }
} 