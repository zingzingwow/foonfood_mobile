import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
          bottom: const TabBar(
            labelColor: AppTheme.primaryOrange,
            unselectedLabelColor: AppTheme.gray500,
            indicatorColor: AppTheme.primaryOrange,
            tabs: [Tab(text: 'New'), Tab(text: 'Preparing'), Tab(text: 'Ready'), Tab(text: 'Delivered')],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(padding: const EdgeInsets.all(16), children: [Card(child: ListTile(title: const Text('Order #1001'), subtitle: const Text('\$24.99'), trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(icon: const Icon(Icons.check, color: AppTheme.success), onPressed: () {}), IconButton(icon: const Icon(Icons.close, color: AppTheme.error), onPressed: () {})])))]),
            const Center(child: Text('No orders')),
            const Center(child: Text('No orders')),
            const Center(child: Text('No orders')),
          ],
        ),
      ),
    );
  }
}
