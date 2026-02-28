import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StaffWorkspaceScreen extends StatelessWidget {
  const StaffWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Staff Workspace'),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
          bottom: const TabBar(
            labelColor: AppTheme.primaryOrange,
            unselectedLabelColor: AppTheme.gray500,
            indicatorColor: AppTheme.primaryOrange,
            tabs: [Tab(text: 'New'), Tab(text: 'Preparing'), Tab(text: 'Done')],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(padding: const EdgeInsets.all(16), children: [Card(child: ListTile(title: const Text('Order #1001'), subtitle: const Text('2x Burger, 1x Fries')))]),
            const Center(child: Text('No orders')),
            const Center(child: Text('No orders')),
          ],
        ),
      ),
    );
  }
}
