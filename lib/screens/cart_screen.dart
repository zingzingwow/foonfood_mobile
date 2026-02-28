import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _items = [
    CartItem(id: 1, name: 'Classic Burger', price: 12.99, quantity: 2, imageUrl: 'https://images.unsplash.com/photo-1632898657999-ae6920976661?w=400&q=80'),
    CartItem(id: 2, name: 'Caesar Salad', price: 9.99, quantity: 1, imageUrl: 'https://images.unsplash.com/photo-1615865417491-9941019fbc00?w=400&q=80'),
  ];

  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _updateQty(int id, int delta) {
    setState(() {
      final i = _items.indexWhere((e) => e.id == id);
      if (i < 0) return;
      final q = (_items[i].quantity + delta).clamp(1, 99);
      _items[i] = CartItem(id: _items[i].id, name: _items[i].name, price: _items[i].price, quantity: q, imageUrl: _items[i].imageUrl);
    });
  }

  void _remove(int id) => setState(() => _items.removeWhere((e) => e.id == id));

  double get _subtotal => _items.fold(0.0, (s, e) => s + e.price * e.quantity);
  double get _tax => _subtotal * 0.08;
  static const double _deliveryFee = 3.99;
  double get _total => _subtotal + _tax + _deliveryFee;

  void _placeOrder() {
    if (_addressController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập đầy đủ địa chỉ và số điện thoại!')));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đặt hàng thành công!')));
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Giỏ Hàng'),
        backgroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingLg),
                    decoration: BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(AppTheme.radiusLg), border: Border.all(color: AppTheme.gray200)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              child: Image.network(
                                item.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Icon(Icons.restaurant),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.name, style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)), Text('\$${item.price.toStringAsFixed(2)}', style: AppTheme.body.copyWith(color: AppTheme.primaryOrange))])),
                            IconButton(onPressed: () => _remove(item.id), icon: const Icon(Icons.delete_outline, color: AppTheme.gray400)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(onPressed: () => _updateQty(item.id, -1), icon: const Icon(Icons.remove), style: IconButton.styleFrom(backgroundColor: AppTheme.gray100)),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('${item.quantity}', style: AppTheme.bodyLarge)),
                                IconButton(onPressed: () => _updateQty(item.id, 1), icon: const Icon(Icons.add, color: AppTheme.primaryOrange), style: IconButton.styleFrom(backgroundColor: AppTheme.orangeLight)),
                              ],
                            ),
                            Text('\$${(item.price * item.quantity).toStringAsFixed(2)}', style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            Text('Địa Chỉ Giao Hàng *', style: AppTheme.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            TextField(controller: _addressController, maxLines: 2, decoration: const InputDecoration(hintText: 'Nhập địa chỉ...', border: OutlineInputBorder(), filled: true, fillColor: AppTheme.white)),
            const SizedBox(height: 12),
            Text('Số Điện Thoại *', style: AppTheme.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            TextField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: 'Số điện thoại', border: OutlineInputBorder(), filled: true, fillColor: AppTheme.white)),
            const SizedBox(height: 12),
            Text('Ghi Chú (Tùy chọn)', style: AppTheme.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            TextField(controller: _noteController, maxLines: 2, decoration: const InputDecoration(hintText: 'Ghi chú cho tài xế...', border: OutlineInputBorder(), filled: true, fillColor: AppTheme.white)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              decoration: BoxDecoration(color: AppTheme.gray50, borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
              child: Column(
                children: [
                  _row('Tạm tính', _subtotal),
                  _row('Phí giao hàng', _deliveryFee),
                  _row('Thuế (8%)', _tax),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Tổng Cộng', style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)), Text('\$${_total.toStringAsFixed(2)}', style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w700, color: AppTheme.primaryOrange))]),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: ElevatedButton(
            onPressed: _placeOrder,
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryOrange, foregroundColor: AppTheme.white, minimumSize: const Size(double.infinity, 56)),
            child: Text('Đặt Hàng • \$${_total.toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, double value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: AppTheme.body.copyWith(color: AppTheme.gray600)), Text('\$${value.toStringAsFixed(2)}', style: AppTheme.body.copyWith(color: AppTheme.gray600))]),
      );
}

class CartItem {
  CartItem({required this.id, required this.name, required this.price, required this.quantity, required this.imageUrl});
  final int id;
  final String name;
  final double price;
  int quantity;
  final String imageUrl;
}
