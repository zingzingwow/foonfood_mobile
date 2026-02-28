import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'search_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';
import 'restaurant_detail_screen.dart';

/// Orders: tabs Active / History, order cards.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _orders = [
    _OrderData(id: 1, restaurantName: "Joe's Burger Joint", items: ['Classic Burger', 'French Fries'], total: 18.99, status: 'active', orderTime: '10 mins ago', estimatedDelivery: '20-30 mins', imageUrl: 'https://images.unsplash.com/photo-1632898657999-ae6920976661?w=400&q=80'),
    _OrderData(id: 2, restaurantName: 'Bella Italia', items: ['Margherita Pizza', 'Caesar Salad'], total: 24.99, status: 'completed', orderTime: '2 days ago', estimatedDelivery: null, imageUrl: 'https://images.unsplash.com/photo-1609166639722-47053ca112ea?w=400&q=80'),
    _OrderData(id: 3, restaurantName: 'Sushi Paradise', items: ['California Roll', 'Miso Soup'], total: 19.99, status: 'completed', orderTime: '1 week ago', estimatedDelivery: null, imageUrl: 'https://images.unsplash.com/photo-1728395235153-5999948803cb?w=400&q=80'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navTap(BuildContext context, int index) {
    if (index == 0) {
      Navigator.of(context).pop();
      return;
    }
    if (index == 1) Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
    if (index == 2) Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedScreen()));
    if (index == 4) Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final active = _orders.where((o) => o.status == 'active').toList();
    final completed = _orders.where((o) => o.status == 'completed').toList();

    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Orders', style: AppTheme.heading2.copyWith(color: AppTheme.gray900)),
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: AppTheme.gray900,
              unselectedLabelColor: AppTheme.gray500,
              indicatorColor: AppTheme.primaryOrange,
              tabs: [
                Tab(text: 'Active (${active.length})'),
                const Tab(text: 'History'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrderList(active),
                  _buildOrderList(completed),
                ],
              ),
            ),
            BottomNavBar(currentIndex: 2, onTap: (i) => _navTap(context, i), alertsCount: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<_OrderData> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: AppTheme.gray200),
            const SizedBox(height: AppTheme.spacingLg),
            Text('No active orders', style: AppTheme.body.copyWith(color: AppTheme.gray500)),
            const SizedBox(height: 4),
            Text('Your active orders will appear here', style: AppTheme.bodySmall.copyWith(color: AppTheme.gray400)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      itemCount: orders.length,
      itemBuilder: (_, i) => _OrderCard(
        order: orders[i],
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurantId: orders[i].id))),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});
  final _OrderData order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Material(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppTheme.radiusLg), border: Border.all(color: AppTheme.gray200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: Image.network(order.imageUrl, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(width: 80, height: 80, child: Icon(Icons.restaurant))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.restaurantName, style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(order.items.join(', '), style: AppTheme.bodySmall.copyWith(color: AppTheme.gray500)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (order.status == 'active') ...[
                                Icon(Icons.schedule, size: 16, color: AppTheme.primaryOrange),
                                const SizedBox(width: 4),
                                Text(order.estimatedDelivery ?? '', style: AppTheme.bodySmall.copyWith(color: AppTheme.primaryOrange)),
                              ] else ...[
                                Icon(Icons.check_circle_outline, size: 16, color: AppTheme.success),
                                const SizedBox(width: 4),
                                const Text('Delivered', style: TextStyle(fontSize: 12, color: AppTheme.success)),
                              ],
                              Text(' • ${order.orderTime}', style: AppTheme.bodySmall.copyWith(color: AppTheme.gray400)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('\$${order.total.toStringAsFixed(2)}', style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderData {
  const _OrderData({required this.id, required this.restaurantName, required this.items, required this.total, required this.status, required this.orderTime, this.estimatedDelivery, required this.imageUrl});
  final int id;
  final String restaurantName;
  final List<String> items;
  final double total;
  final String status;
  final String orderTime;
  final String? estimatedDelivery;
  final String imageUrl;
}
