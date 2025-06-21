import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../theme/theme_provider.dart';
import '../widgets/note_card_widget.dart';
import '../widgets/neumorphic_button.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/daily_quote_widget.dart';
import '../widgets/profile_drawer.dart';
import 'note_detail_screen.dart';
import 'daily_quote_screen.dart';
import 'package:intl/intl.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _buttonAnimationController;
  late AnimationController _themeAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _themeRotationAnimation;
  int _currentNavIndex = 1; // Default to notes tab

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _themeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _themeRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _themeAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().loadNotes();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _buttonAnimationController.dispose();
    _themeAnimationController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    final themeProvider = context.read<ThemeProvider>();
    themeProvider.toggleTheme();
    _themeAnimationController.forward().then((_) {
      _themeAnimationController.reset();
    });
  }

  void _openDailyQuote() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const DailyQuoteScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 1200),
      ),
    );
  }

  void _createNewNote() async {
    // Button scale animation
    _buttonAnimationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _buttonAnimationController.reverse();
      });
    });
    
    // Wait for button animation
    await Future.delayed(const Duration(milliseconds: 250));
    
    if (mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const NoteDetailScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  void _createNewTask() {
    // Button scale animation
    _buttonAnimationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _buttonAnimationController.reverse();
      });
    });
    
    // TODO: Implement task creation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Görev oluşturma özelliği yakında eklenecek!'),
        backgroundColor: context.read<ThemeProvider>().primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    
    switch (index) {
      case 0: // Create
        _createNewNote();
        break;
      case 1: // Notes
        // Already on notes page
        break;
      case 2: // Tasks
        _createNewTask();
        break;
    }
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMMM yyyy', 'tr_TR');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NotesProvider>().notes;
    final user = context.watch<AuthProvider>().currentUser;
    final themeProvider = context.watch<ThemeProvider>();
    final userName = user != null ? user.split('@')[0] : 'Kullanıcı';

    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      drawer: const ProfileDrawer(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Top Section with Profile Icon and Title
              Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                decoration: BoxDecoration(
                  gradient: themeProvider.primaryGradient,
                ),
                child: Column(
                  children: [
                    // Top Row with Profile Icon and Theme Toggle
                    Row(
                      children: [
                        // Profile Icon (Drawer Trigger)
                        Builder(
                          builder: (context) => GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Theme Toggle Button
                        AnimatedBuilder(
                          animation: _themeAnimationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _themeRotationAnimation.value * 0.5 * 3.14159,
                              child: GestureDetector(
                                onTap: _toggleTheme,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    themeProvider.isDarkMode 
                                        ? Icons.wb_sunny 
                                        : Icons.nightlight_round,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Title with simple design
                    Text(
                      'Brainy Note',
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2.0,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Welcome Message
                    Text(
                      'Hoş geldin $userName',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bugün ${_getCurrentDate()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Action Buttons with enhanced animations
                      AnimatedBuilder(
                        animation: _buttonAnimationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _buttonScaleAnimation.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                NeumorphicButton(
                                  title: 'Yeni Not',
                                  icon: Icons.edit_note,
                                  onPressed: _createNewNote,
                                  color: themeProvider.primaryColor,
                                ),
                                NeumorphicButton(
                                  title: 'Yeni Görev',
                                  icon: Icons.task_alt,
                                  onPressed: _createNewTask,
                                  color: themeProvider.secondaryColor,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Daily Quote
                      Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 16),
                        child: Flexible(
                          child: DailyQuoteWidget(),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Notes Section (if any notes exist)
                      if (notes.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Son Notlar',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.primaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Show all notes
                              },
                              child: Text(
                                'Tümünü Gör',
                                style: TextStyle(
                                  color: themeProvider.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Recent Notes
                        ...notes.take(3).map((note) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: NoteCardWidget(
                            note: note,
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => NoteDetailScreen(note: note),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeOutCubic;
                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    var offsetAnimation = animation.drive(tween);
                                    return SlideTransition(position: offsetAnimation, child: child);
                                  },
                                  transitionDuration: const Duration(milliseconds: 1000),
                                ),
                              );
                            },
                            onDelete: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Notu Sil'),
                                  content: const Text('Bu notu silmek istediğinizden emin misiniz?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('İptal'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: themeProvider.accentColor,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Sil'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                await context.read<NotesProvider>().deleteNote(note);
                              }
                            },
                          ),
                        )),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Bottom Navigation
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
        primaryColor: themeProvider.primaryColor,
        secondaryColor: themeProvider.secondaryColor,
      ),
    );
  }
}
