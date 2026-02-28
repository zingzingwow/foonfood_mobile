import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Staff Management'),
        backgroundColor: AppTheme.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.person_add), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        children: [
          ListTile(
            leading: const CircleAvatar(child: Text('J')),
            title: const Text('John Doe'),
            subtitle: const Text('Owner'),
            trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)), child: Text('Owner', style: TextStyle(color: Colors.purple[700], fontSize: 12))),
          ),
          ListTile(
            leading: const CircleAvatar(child: Text('A')),
            title: const Text('Alice Smith'),
            subtitle: const Text('Manager'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () {}), IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: () {})]),
          ),
        ],
      ),
    );
  }
}
