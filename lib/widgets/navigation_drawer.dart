import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../screens/home_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/quiz_menu_screen.dart';
import '../screens/project_screen.dart';
import '../screens/glossary_screen.dart';

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor,
                  AppTheme.primaryColorLight,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Icon(
                    Icons.code,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                // App Title
                Text(
                  'Learn Dart',
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.quiz,
                  title: 'Quiz',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizMenuScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Question and Answer',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Question and Answer - Coming Soon!'),
                        backgroundColor: AppTheme.primaryColor,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.code,
                  title: 'Programs',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Programs - Coming Soon!'),
                        backgroundColor: AppTheme.primaryColor,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.check_circle_outline,
                  title: 'Your Progress',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Your Progress - Coming Soon!'),
                        backgroundColor: AppTheme.primaryColor,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.apps,
                  title: 'More Apps',
                  onTap: () {
                    Navigator.pop(context);
                    // Open more apps or app store
                  },
                ),
                _buildMenuItem(
                  icon: Icons.star_outline,
                  title: 'Rate This App',
                  onTap: () {
                    Navigator.pop(context);
                    // Open app rating
                  },
                ),
                _buildMenuItem(
                  icon: Icons.block,
                  title: 'Remove Ads',
                  onTap: () {
                    Navigator.pop(context);
                    // Show remove ads dialog or navigate to premium
                  },
                ),
                _buildMenuItem(
                  icon: Icons.exit_to_app,
                  title: 'Exit',
                  onTap: () {
                    Navigator.pop(context);
                    // Exit app
                    SystemNavigator.pop();
                  },
                ),
                
                // Separator
                const Divider(
                  height: 20,
                  thickness: 1,
                  color: Colors.grey,
                ),
                
                // Share & Feedback Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Share & Feedback',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                
                _buildMenuItem(
                  icon: Icons.share,
                  title: 'Share',
                  onTap: () {
                    Navigator.pop(context);
                    // Share app
                  },
                ),
                _buildMenuItem(
                  icon: Icons.feedback,
                  title: 'Feedback',
                  onTap: () {
                    Navigator.pop(context);
                    // Open feedback form or email
                  },
                ),
              ],
            ),
          ),
        ],
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
        color: Colors.black,
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
