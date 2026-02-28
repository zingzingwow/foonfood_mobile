import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop())),
      body: ListView(
        children: [
          SwitchListTile(title: const Text('Order updates'), subtitle: const Text('Confirmations and status'), value: true, onChanged: (_) {}, activeColor: AppTheme.primaryOrange),
          SwitchListTile(title: const Text('Promotions'), value: true, onChanged: (_) {}, activeColor: AppTheme.primaryOrange),
          SwitchListTile(title: const Text('Sound'), value: true, onChanged: (_) {}, activeColor: AppTheme.primaryOrange),
        ],
      ),
    );
  }
}
