import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import '../widgets/parallax_background.dart';
import '../widgets/neumorphic_widgets.dart';
import '../models/note.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;

  const NoteEditorScreen({
    super.key,
    this.note,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _saveController;
  
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _saveScaleAnimation;

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _saveController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    
    _saveScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _saveController,
      curve: Curves.easeInOut,
    ));
    
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _saveController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen bir başlık girin'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    _saveController.forward();

    // Simulate save operation
    await Future.delayed(const Duration(milliseconds: 1500));
    
    _saveController.reverse();
    setState(() => _isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.note == null ? 'Not kaydedildi!' : 'Not güncellendi!'),
          backgroundColor: ThemeProvider().primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider();
    final isEditing = widget.note != null;
    
    return Scaffold(
      body: ParallaxBackground(
        isDarkMode: themeProvider.isDarkMode,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _slideController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            // Back Button
                            NeumorphicCard(
                              width: 50,
                              height: 50,
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.arrow_back,
                                color: themeProvider.primaryColor,
                                size: 24,
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Title
                            Text(
                              isEditing ? 'Notu Düzenle' : 'Yeni Not',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.primaryColor,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Save Button
                            AnimatedBuilder(
                              animation: _saveController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _saveScaleAnimation.value,
                                  child: NeumorphicCard(
                                    width: 50,
                                    height: 50,
                                    onTap: _isSaving ? null : _saveNote,
                                    child: _isSaving
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                themeProvider.primaryColor,
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.save,
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
                      
                      // Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              // Title Input
                              NeumorphicInput(
                                hintText: 'Not başlığı...',
                                controller: _titleController,
                                prefixIcon: const Icon(Icons.title),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Content Input
                              Expanded(
                                child: NeumorphicInput(
                                  hintText: 'Notunuzu buraya yazın...',
                                  controller: _contentController,
                                  prefixIcon: const Icon(Icons.edit_note),
                                  maxLines: null,
                                  expands: true,
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Formatting Tools
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: themeProvider.surfaceColor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: themeProvider.shadows,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildFormatButton(
                                      icon: Icons.format_bold,
                                      onTap: () => _insertText('**bold**'),
                                    ),
                                    _buildFormatButton(
                                      icon: Icons.format_italic,
                                      onTap: () => _insertText('*italic*'),
                                    ),
                                    _buildFormatButton(
                                      icon: Icons.format_list_bulleted,
                                      onTap: () => _insertText('• '),
                                    ),
                                    _buildFormatButton(
                                      icon: Icons.check_box,
                                      onTap: () => _insertText('☐ '),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormatButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final themeProvider = ThemeProvider();
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: themeProvider.surfaceColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 5,
              offset: const Offset(-2, -2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: themeProvider.primaryColor,
          size: 20,
        ),
      ),
    );
  }

  void _insertText(String text) {
    final currentText = _contentController.text;
    final selection = _contentController.selection;
    
    final newText = currentText.replaceRange(
      selection.start,
      selection.end,
      text,
    );
    
    _contentController.text = newText;
    _contentController.selection = TextSelection.collapsed(
      offset: selection.start + text.length,
    );
  }
} 