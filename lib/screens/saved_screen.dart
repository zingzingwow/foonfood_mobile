import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import 'restaurant_detail_screen.dart';
import 'food_detail_screen.dart';

/// Saved restaurants and foods. Tap to open detail, trash to remove.
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<SavedItem> _items = [
    SavedItem(id: 1, type: SavedItemType.restaurant, name: "Joe's Burger Joint", imageUrl: 'https://images.unsplash.com/photo-1632898657999-ae6920976661?w=400&q=80', rating: 4.8, cuisine: 'American'),
    SavedItem(id: 2, type: SavedItemType.restaurant, name: 'Bella Italia', imageUrl: 'https://images.unsplash.com/photo-1609166639722-47053ca112ea?w=400&q=80', rating: 4.9, cuisine: 'Italian'),
    SavedItem(id: 3, type: SavedItemType.food, name: 'Classic Burger', imageUrl: 'https://images.unsplash.com/photo-1632898657999-ae6920976661?w=400&q=80', price: 12.99, restaurant: "Joe's Burger Joint"),
  ];

  void _remove(int id) => setState(() => _items = _items.where((e) => e.id != id).toList());

  void _navTap(BuildContext context, int index) {
    if (index == 0) {
      Navigator.of(context).pop();
      return;
    }
    if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
      return;
    }
    if (index == 2) return;
    if (index == 4) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Saved', style: AppTheme.heading2.copyWith(color: AppTheme.gray900)),
              ),
            ),
            Expanded(
              child: _items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bookmark_border, size: 64, color: AppTheme.gray200),
                          const SizedBox(height: AppTheme.spacingLg),
                          Text('No saved items yet', style: AppTheme.body.copyWith(color: AppTheme.gray500)),
                          const SizedBox(height: AppTheme.spacingSm),
                          Text('Save your favorite restaurants and dishes', style: AppTheme.bodySmall.copyWith(color: AppTheme.gray400)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
                      itemCount: _items.length,
                      itemBuilder: (_, i) {
                        final item = _items[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                          child: Material(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                            child: InkWell(
                              onTap: () {
                                if (item.type == SavedItemType.restaurant) {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurantId: item.id)));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => FoodDetailScreen(foodId: item.id)));
                                }
                              },
                              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                              child: Container(
                                padding: const EdgeInsets.all(AppTheme.spacingMd),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppTheme.radiusLg), border: Border.all(color: AppTheme.gray200)),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                      child: Image.network(item.imageUrl, width: 96, height: 96, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 96, height: 96, color: AppTheme.gray200, child: const Icon(Icons.image))),
                                    ),
                                    const SizedBox(width: AppTheme.spacingMd),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name, style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600, color: AppTheme.gray900)),
                                          if (item.type == SavedItemType.restaurant) ...[
                                            Text(item.cuisine!, style: AppTheme.body.copyWith(color: AppTheme.gray500)),
                                            Row(children: [Icon(Icons.star_rounded, size: 16, color: Colors.amber[700]), const SizedBox(width: 4), Text('${item.rating}', style: AppTheme.bodySmall.copyWith(color: AppTheme.gray900))]),
                                          ] else ...[
                                            Text(item.restaurant!, style: AppTheme.body.copyWith(color: AppTheme.gray500)),
                                            Text('\$${item.price!.toStringAsFixed(2)}', style: AppTheme.body.copyWith(color: AppTheme.primaryOrange, fontWeight: FontWeight.w600)),
                                          ],
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _remove(item.id),
                                      icon: Icon(Icons.delete_outline, color: AppTheme.gray400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            BottomNavBar(currentIndex: 2, onTap: (i) => _navTap(context, i), alertsCount: 3),
          ],
        ),
      ),
    );
  }
}

enum SavedItemType { restaurant, food }

class SavedItem {
  SavedItem({required this.id, required this.type, required this.name, required this.imageUrl, this.rating, this.cuisine, this.price, this.restaurant});
  final int id;
  final SavedItemType type;
  final String name;
  final String imageUrl;
  final double? rating;
  final String? cuisine;
  final double? price;
  final String? restaurant;
}
