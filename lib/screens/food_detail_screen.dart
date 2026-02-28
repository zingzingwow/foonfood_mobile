import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';

/// Food detail: image, name, price, quantity, comments, Add to cart / Buy now.
class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key, required this.foodId});

  final int foodId;

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;

  static const _food = _FoodData(
    id: 1,
    name: 'Classic Burger',
    price: 12.99,
    description: 'Juicy beef patty with fresh lettuce, tomatoes, pickles, and our special sauce on a toasted brioche bun. Served with crispy fries.',
    imageUrl: 'https://images.unsplash.com/photo-1632898657999-ae6920976661?w=800&q=80',
    rating: 4.8,
    reviews: 89,
  );

  void _addToCart() {
    // TODO: persist cart
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã thêm $_quantity ${_food.name} vào giỏ hàng!')));
    Navigator.of(context).pop();
  }

  void _buyNow() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(_food.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const ColoredBox(color: AppTheme.gray200)),
                  Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black26, Colors.transparent]))),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_food.name, style: AppTheme.heading2.copyWith(color: AppTheme.gray900)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star_rounded, size: 18, color: Colors.amber[700]),
                                const SizedBox(width: 4),
                                Text('${_food.rating}', style: AppTheme.body.copyWith(color: AppTheme.gray900)),
                                Text(' (${_food.reviews} reviews)', style: AppTheme.body.copyWith(color: AppTheme.gray400)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text('\$${_food.price.toStringAsFixed(2)}', style: AppTheme.heading3.copyWith(color: AppTheme.primaryOrange)),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  Text(_food.description, style: AppTheme.body.copyWith(color: AppTheme.gray600, height: 1.5)),
                  const SizedBox(height: AppTheme.spacing2xl),
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    decoration: BoxDecoration(color: AppTheme.gray50, borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                              icon: const Icon(Icons.remove_circle_outline),
                              style: IconButton.styleFrom(backgroundColor: AppTheme.white, side: const BorderSide(color: AppTheme.gray200)),
                            ),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('$_quantity', style: AppTheme.heading3)),
                            IconButton(
                              onPressed: () => setState(() => _quantity++),
                              icon: const Icon(Icons.add_circle, color: AppTheme.primaryOrange),
                              style: IconButton.styleFrom(backgroundColor: AppTheme.primaryOrange),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing2xl),
                  Text('Comments', style: AppTheme.heading3),
                  const SizedBox(height: 8),
                  const TextField(
                    maxLines: 3,
                    decoration: InputDecoration(hintText: 'Write a comment...', border: OutlineInputBorder(), alignLabelWithHint: true),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _addToCart,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Add to Cart'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppTheme.gray900, backgroundColor: AppTheme.gray200),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _buyNow,
                  icon: const Icon(Icons.flash_on),
                  label: const Text('Buy Now'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryOrange, foregroundColor: AppTheme.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodData {
  const _FoodData({required this.id, required this.name, required this.price, required this.description, required this.imageUrl, required this.rating, required this.reviews});
  final int id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviews;
}
