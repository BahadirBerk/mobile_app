import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import '../widgets/parallax_background.dart';
import '../widgets/neumorphic_widgets.dart';
import '../models/note.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen>
    with TickerProviderStateMixin {
  late AnimationController _listController;
  late AnimationController _fabController;
  late AnimationController _themeController;
  
  late Animation<double> _listSlideAnimation;
  late Animation<double> _listOpacityAnimation;
  late Animation<double> _fabScaleAnimation;
  late Animation<double> _fabOpacityAnimation;
  late Animation<double> _themeRotationAnimation;

  final List<Note> _notes = [
    Note(
      id: '1',
      title: 'Günlük Planlar',
      content: 'Bugün yapılacaklar:\n• Flutter projesi üzerinde çalış\n• Spor yap\n• Kitap oku',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isCompleted: false,
    ),
    Note(
      id: '2',
      title: 'Alışveriş Listesi',
      content: 'Market alışverişi:\n☐ Süt\n☐ Ekmek\n☐ Yumurta\n☐ Meyve',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isCompleted: false,
    ),
    Note(
      id: '3',
      title: 'Proje Fikirleri',
      content: 'Gelecek projeler:\n• AI destekli not uygulaması\n• Fitness takip uygulaması\n• E-ticaret platformu',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isCompleted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _listController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _themeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _listSlideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: Curves.easeOutCubic,
    ));
    
    _listOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: Curves.easeIn,
    ));
    
    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    ));
    
    _fabOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeIn,
    ));
    
    _themeRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _themeController,
      curve: Curves.easeInOut,
    ));
    
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _listController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _fabController.forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    _fabController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    final themeProvider = ThemeProvider();
    themeProvider.toggleTheme();
    _themeController.forward().then((_) {
      _themeController.reset();
    });
  }

  void _addNewNote() {
    // TODO: Navigate to note editor
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Yeni not ekleme özelliği yakında!'),
        backgroundColor: ThemeProvider().primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider();
    
    return Scaffold(
      body: ParallaxBackground(
        isDarkMode: themeProvider.isDarkMode,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Profile Icon
                    NeumorphicCard(
                      width: 50,
                      height: 50,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Profil menüsü yakında!'),
                            backgroundColor: themeProvider.primaryColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.person,
                        color: themeProvider.primaryColor,
                        size: 24,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // App Title
                    Text(
                      'Brainy Note',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.primaryColor,
                        fontFamily: 'Roboto',
                        letterSpacing: 1,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Theme Toggle
                    AnimatedBuilder(
                      animation: _themeController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _themeRotationAnimation.value * 0.5 * 3.14159,
                          child: NeumorphicCard(
                            width: 50,
                            height: 50,
                            onTap: _toggleTheme,
                            child: Icon(
                              themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                              color: themeProvider.primaryColor,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: AnimatedBuilder(
                  animation: _listController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _listSlideAnimation.value),
                      child: Opacity(
                        opacity: _listOpacityAnimation.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // Action Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: NeumorphicButton(
                                      text: 'Yeni Not',
                                      icon: Icons.note_add,
                                      height: 70,
                                      onPressed: _addNewNote,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: NeumorphicButton(
                                      text: 'Yeni Görev',
                                      icon: Icons.task_alt,
                                      height: 70,
                                      onPressed: _addNewNote,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Notes List
                              Expanded(
                                child: _notes.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.note_add,
                                              size: 80,
                                              color: themeProvider.primaryColor.withOpacity(0.5),
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              'Henüz not yok',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: themeProvider.primaryColor.withOpacity(0.7),
                                                fontFamily: 'Roboto',
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'İlk notunuzu oluşturmak için + butonuna tıklayın',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: themeProvider.primaryColor.withOpacity(0.5),
                                                fontFamily: 'Roboto',
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: _notes.length,
                                        itemBuilder: (context, index) {
                                          final note = _notes[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 15),
                                            child: _buildNoteCard(note, index),
                                          );
                                        },
                                      ),
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
      
      // Floating Action Button
      floatingActionButton: AnimatedBuilder(
        animation: _fabController,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabScaleAnimation.value,
            child: Opacity(
              opacity: _fabOpacityAnimation.value,
              child: AnimatedFloatingActionButton(
                icon: Icons.add,
                onPressed: _addNewNote,
                backgroundColor: themeProvider.accentColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoteCard(Note note, int index) {
    final themeProvider = ThemeProvider();
    
    return NeumorphicCard(
      onTap: () {
        // TODO: Navigate to note detail
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${note.title} notunu açılıyor...'),
            backgroundColor: themeProvider.primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.primaryColor,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Icon(
                note.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: note.isCompleted 
                    ? Colors.green 
                    : themeProvider.primaryColor.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
          
          const SizedBox(height: 10),
          
          Text(
            note.content,
            style: TextStyle(
              fontSize: 14,
              color: themeProvider.primaryColor.withOpacity(0.7),
              fontFamily: 'Roboto',
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 15),
          
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: themeProvider.primaryColor.withOpacity(0.5),
              ),
              const SizedBox(width: 5),
              Text(
                _formatDate(note.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: themeProvider.primaryColor.withOpacity(0.5),
                  fontFamily: 'Roboto',
                ),
              ),
              const Spacer(),
              Icon(
                Icons.edit,
                size: 16,
                color: themeProvider.primaryColor.withOpacity(0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }
} 