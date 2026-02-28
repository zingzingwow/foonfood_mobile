import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'food_detail_screen.dart';
import 'cart_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key, required this.restaurantId});
  final int restaurantId;

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  int _currentImage = 0;
  bool _followed = false;
  late TabController _tabController;
  final Map<int, int> _quantities = {};

  static const _images = [
    'https://images.unsplash.com/photo-1632898657999-ae6920976661?w=800&q=80',
    'https://images.unsplash.com/photo-1756361629888-90596c86fd79?w=800&q=80',
  ];
  static const _menuItems = [
    _MenuData(id: 1, name: 'Classic Burger', price: 12.99, imageUrl: 'https://images.unsplash.com/photo-1632898657999-ae6920976661?w=400&q=80'),
    _MenuData(id: 2, name: 'Cheese Pizza', price: 14.99, imageUrl: 'https://images.unsplash.com/photo-1756361629888-90596c86fd79?w=400&q=80'),
    _MenuData(id: 3, name: 'Caesar Salad', price: 9.99, imageUrl: 'https://images.unsplash.com/photo-1615865417491-9941019fbc00?w=400&q=80'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _totalItems => _quantities.values.fold(0, (a, b) => a + b);
  double get _totalPrice => _menuItems.fold(0.0, (s, m) => s + m.price * (_quantities[m.id] ?? 0));

  void _updateQty(int id, int delta) {
    setState(() {
      final cur = _quantities[id] ?? 0;
      final next = (cur + delta).clamp(0, 99);
      if (next == 0) _quantities.remove(id); else _quantities[id] = next;
    });
  }

  void _addToCart() {
    final n = _menuItems.where((m) => (_quantities[m.id] ?? 0) > 0).length;
    if (n == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ít nhất 1 món!')));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã thêm $n món vào giỏ!')));
    setState(() => _quantities.clear());
  }

  void _buyNow() {
    final n = _menuItems.where((m) => (_quantities[m.id] ?? 0) > 0).length;
    if (n == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ít nhất 1 món!')));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 256,
            pinned: true,
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: _images.length,
                    onPageChanged: (i) => setState(() => _currentImage = i),
                    itemBuilder: (_, i) => Image.network(_images[i], fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black26, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Joe's Burger Joint", style: AppTheme.heading2.copyWith(color: AppTheme.gray900)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 18, color: Colors.amber[700]),
                      const SizedBox(width: 4),
                      Text('4.8', style: AppTheme.body.copyWith(color: AppTheme.gray900)),
                      Text(' (234)', style: AppTheme.body.copyWith(color: AppTheme.gray500)),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined, size: 18, color: AppTheme.gray500),
                      Text('0.5 mi', style: AppTheme.body.copyWith(color: AppTheme.gray500)),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => setState(() => _followed = !_followed),
                          icon: Icon(Icons.favorite, size: 20, color: _followed ? AppTheme.gray600 : AppTheme.primaryOrange),
                          label: Text(_followed ? 'Following' : 'Follow'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _followed ? AppTheme.gray900 : AppTheme.primaryOrange,
                            backgroundColor: _followed ? AppTheme.gray200 : AppTheme.primaryOrange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.location_on_outlined, size: 20), label: const Text('Directions')),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.phone_outlined)),
                    ],
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: AppTheme.gray900,
              unselectedLabelColor: AppTheme.gray500,
              indicatorColor: AppTheme.primaryOrange,
              tabs: const [Tab(text: 'Menu'), Tab(text: 'Reviews'), Tab(text: 'Info')],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    itemCount: _menuItems.length,
                    itemBuilder: (_, i) {
                      final item = _menuItems[i];
                      final qty = _quantities[item.id] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FoodDetailScreen(foodId: item.id))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                child: Image.network(item.imageUrl, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox(width: 80, height: 80, child: Icon(Icons.restaurant))),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FoodDetailScreen(foodId: item.id))),
                                    child: Text(item.name, style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                                  ),
                                  Text('\$${item.price.toStringAsFixed(2)}', style: AppTheme.body.copyWith(color: AppTheme.primaryOrange, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(onPressed: qty <= 0 ? null : () => _updateQty(item.id, -1), icon: const Icon(Icons.remove_circle_outline), style: IconButton.styleFrom(backgroundColor: AppTheme.gray100)),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('$qty', style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600))),
                                IconButton(onPressed: () => _updateQty(item.id, 1), icon: const Icon(Icons.add_circle, color: AppTheme.primaryOrange), style: IconButton.styleFrom(backgroundColor: AppTheme.orangeLight)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ListView(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    children: [
                      ListTile(leading: const CircleAvatar(child: Text('👩')), title: const Text('Sarah Johnson'), subtitle: const Text('2 days ago')),
                      const Text('Best burgers in town!', style: TextStyle(color: AppTheme.gray600)),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    children: [
                      ListTile(leading: const Icon(Icons.location_on_outlined), title: const Text('Address'), subtitle: const Text('123 Main Street, Downtown')),
                      ListTile(leading: const Icon(Icons.phone_outlined), title: const Text('Phone'), subtitle: const Text('(555) 123-4567')),
                      ListTile(leading: const Icon(Icons.access_time), title: const Text('Hours'), subtitle: const Text('Mon-Sun: 11:00 AM - 10:00 PM')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _totalItems > 0
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Row(
                  children: [
                    Expanded(child: OutlinedButton.icon(onPressed: _addToCart, icon: const Icon(Icons.shopping_cart_outlined), label: Text('Thêm vào giỏ ($_totalItems)'))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _buyNow,
                        icon: const Icon(Icons.flash_on),
                        label: Text('Mua ngay ($_totalItems)'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryOrange, foregroundColor: AppTheme.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class _MenuData {
  const _MenuData({required this.id, required this.name, required this.price, required this.imageUrl});
  final int id;
  final String name;
  final double price;
  final String imageUrl;
}
