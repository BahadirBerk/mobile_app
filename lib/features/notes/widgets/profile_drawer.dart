import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../theme/theme_provider.dart';
import '../../auth/screens/login_screen.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final themeProvider = context.watch<ThemeProvider>();
    final userName = user != null ? user.split('@')[0] : 'Kullanıcı';

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.primaryGradient,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                children: [
                  // Profile Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 3,
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
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // User Name
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Email
                  Text(
                    user ?? 'kullanıcı@email.com',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu Items
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: themeProvider.cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    
                    // Menu Items
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Profil Ayarları',
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to profile settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Profil ayarları yakında eklenecek!'),
                            backgroundColor: themeProvider.primaryColor,
                          ),
                        );
                      },
                      themeProvider: themeProvider,
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Uygulama Ayarları',
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to app settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Uygulama ayarları yakında eklenecek!'),
                            backgroundColor: themeProvider.primaryColor,
                          ),
                        );
                      },
                      themeProvider: themeProvider,
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Yardım',
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to help
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Yardım sayfası yakında eklenecek!'),
                            backgroundColor: themeProvider.primaryColor,
                          ),
                        );
                      },
                      themeProvider: themeProvider,
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'Hakkında',
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to about
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Hakkında sayfası yakında eklenecek!'),
                            backgroundColor: themeProvider.primaryColor,
                          ),
                        );
                      },
                      themeProvider: themeProvider,
                    ),
                    
                    const Spacer(),
                    
                    // Logout Button
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final authProvider = context.read<AuthProvider>();
                          final navigator = Navigator.of(context);
                          
                          final confirmed = await _showLogoutDialog(context);
                          
                          if (confirmed == true) {
                            await authProvider.logout();
                            navigator.pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Çıkış Yap'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeProvider.accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
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
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeProvider themeProvider,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: themeProvider.primaryColor,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: themeProvider.textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) async {
    final themeProvider = context.read<ThemeProvider>();
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
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
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }
} 