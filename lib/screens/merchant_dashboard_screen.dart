import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'order_management_screen.dart';
import 'restaurant_settings_screen.dart';

class MerchantDashboardScreen extends StatelessWidget {
  const MerchantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RestaurantSettingsScreen(restaurantId: 1))))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        children: [
          Row(
            children: [
              Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.attach_money, color: AppTheme.primaryOrange), const SizedBox(height: 8), Text('\$2,450', style: AppTheme.heading3), const Text('Revenue', style: TextStyle(color: AppTheme.gray500))])))),
              const SizedBox(width: 12),
              Expanded(child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.shopping_bag_outlined, color: Colors.green), const SizedBox(height: 8), Text('124', style: AppTheme.heading3), const Text('Orders', style: TextStyle(color: AppTheme.gray500))])))),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Recent Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderManagementScreen())),
            leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
            title: const Text('Order #1001'),
            subtitle: const Text('\$24.99'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
