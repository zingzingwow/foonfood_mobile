import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'merchant_dashboard_screen.dart';
import 'order_management_screen.dart';
import 'staff_management_screen.dart';

/// Entry to merchant mode: select restaurant/location, quick actions (Orders, Staff, Menu, Dashboard).
class MerchantModeEntryScreen extends StatefulWidget {
  const MerchantModeEntryScreen({super.key});

  @override
  State<MerchantModeEntryScreen> createState() => _MerchantModeEntryScreenState();
}

class _MerchantModeEntryScreenState extends State<MerchantModeEntryScreen> {
  String _selectedLocation = 'Downtown Branch';
  final List<String> _locations = ['Downtown Branch', 'Uptown Branch', 'Westside Branch'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Merchant Mode'),
        backgroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(AppTheme.radiusLg), border: Border.all(color: AppTheme.gray200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Joe's Burger Joint", style: AppTheme.heading3.copyWith(color: AppTheme.gray900)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                    items: _locations.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                    onChanged: (v) => setState(() => _selectedLocation = v ?? _selectedLocation),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
                    child: Text('Owner', style: AppTheme.bodySmall.copyWith(color: Colors.purple[700], fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacing2xl),
            Text('Quick Actions', style: AppTheme.heading3.copyWith(color: AppTheme.gray900)),
            const SizedBox(height: AppTheme.spacingMd),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _ActionCard(icon: Icons.people_outline, label: 'Manage Staff', color: Colors.purple, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StaffManagementScreen()))),
                _ActionCard(icon: Icons.restaurant_menu, label: 'Manage Menu', color: Colors.blue, onTap: () {}),
                _ActionCard(icon: Icons.list_alt, label: 'Orders', color: Colors.green, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrderManagementScreen()))),
                _ActionCard(icon: Icons.bar_chart, label: 'Analytics', color: AppTheme.primaryOrange, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MerchantDashboardScreen()))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          decoration: BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(AppTheme.radiusLg), border: Border.all(color: AppTheme.gray200)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(label, style: AppTheme.body.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
