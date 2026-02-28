import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'notification_settings_screen.dart';
import 'search_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  void _navTap(BuildContext context, int index) {
    if (index == 0) Navigator.of(context).pop();
    if (index == 1) Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
    if (index == 2) Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedScreen()));
    if (index == 4) Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        title: const Text('Alerts'),
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationSettingsScreen())))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        children: [
          ListTile(leading: const Icon(Icons.receipt_long), title: const Text('Order #1001 confirmed'), subtitle: const Text('2 mins ago'), trailing: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.primaryOrange, shape: BoxShape.circle))),
          ListTile(leading: const Icon(Icons.local_offer), title: const Text('New promotion at Joe\'s Burger'), subtitle: const Text('1 hour ago')),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) => _navTap(context, index),
        alertsCount: 3,
      ),
    );
  }
}
