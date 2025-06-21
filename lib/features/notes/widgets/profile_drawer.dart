import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final userName = user != null ? user.split('@')[0] : 'Kullanıcı';

    return Drawer(
      child: Container(
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
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
                          const SnackBar(
                            content: Text('Profil ayarları yakında eklenecek!'),
                            backgroundColor: Color(0xFF2E8B57),
                          ),
                        );
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Uygulama Ayarları',
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to app settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Uygulama ayarları yakında eklenecek!'),
                            backgroundColor: Color(0xFF2E8B57),
                          ),
                        );
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Yardım',
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to help
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Yardım sayfası yakında eklenecek!'),
                            backgroundColor: Color(0xFF2E8B57),
                          ),
                        );
                      },
                    ),
                    
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'Hakkında',
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to about
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Hakkında sayfası yakında eklenecek!'),
                            backgroundColor: Color(0xFF2E8B57),
                          ),
                        );
                      },
                    ),
                    
                    const Spacer(),
                    
                    // Logout Button
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _showLogoutDialog(context);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Çıkış Yap'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E8B57),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF2E8B57),
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF2E8B57),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
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
              backgroundColor: const Color(0xFF2E8B57),
              foregroundColor: Colors.white,
            ),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await context.read<AuthProvider>().logout();
    }
  }
} 