import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/bottom_nav_bar.dart';
import 'search_screen.dart';
import 'saved_screen.dart';
import 'orders_screen.dart';
import 'login_screen.dart';
import 'merchant_mode_entry_screen.dart';
import 'create_restaurant_screen.dart';

/// Profile: user info, mode toggle (Customer/Merchant), Saved, Orders, Settings, Logout.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _merchantMode = false;
  bool _isAnonymous = false; // TODO: from auth

  void _navTap(BuildContext context, int index) {
    if (index == 0) {
      Navigator.of(context).pop();
      return;
    }
    if (index == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
      return;
    }
    if (index == 2) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedScreen()));
      return;
    }
    if (index == 4) return;
  }

  @override
  Widget build(BuildContext context) {
    if (_isAnonymous) return _buildAnonymousProfile(context);
    return _buildAuthenticatedProfile(context);
  }

  Widget _buildAnonymousProfile(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(AppTheme.spacing2xl, AppTheme.spacing2xl, AppTheme.spacing2xl, 96),
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primaryOrange, AppTheme.orangeDark]),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(color: AppTheme.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)]),
                    alignment: Alignment.center,
                    child: const Text('👤', style: TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(width: AppTheme.spacingLg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Anonymous User', style: AppTheme.heading3.copyWith(color: AppTheme.white)),
                        Text('Khách', style: AppTheme.body.copyWith(color: AppTheme.orangeLight)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(AppTheme.spacingLg, 0, AppTheme.spacingLg, AppTheme.spacingLg),
                child: Column(
                  children: [
                    const SizedBox(height: AppTheme.spacing4xl),
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacing2xl),
                      decoration: BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(AppTheme.radiusXl), border: Border.all(color: AppTheme.orangeLight), boxShadow: [AppTheme.shadowSm]),
                      child: Column(
                        children: [
                          Icon(Icons.person_add_rounded, size: 48, color: AppTheme.primaryOrange),
                          const SizedBox(height: AppTheme.spacingLg),
                          Text('Đăng nhập để trải nghiệm đầy đủ!', style: AppTheme.heading3.copyWith(color: AppTheme.gray900), textAlign: TextAlign.center),
                          const SizedBox(height: AppTheme.spacingSm),
                          Text('Lưu nhà hàng yêu thích, theo dõi đơn hàng và nhiều hơn nữa', style: AppTheme.body.copyWith(color: AppTheme.gray600), textAlign: TextAlign.center),
                          const SizedBox(height: AppTheme.spacing2xl),
                          PrimaryButton(label: 'Đăng nhập / Đăng ký', onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false)),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    _Section(title: 'Tính năng khi đăng nhập', children: [
                      _MenuItem(icon: Icons.bookmark_border, title: 'Nhà hàng đã lưu', subtitle: 'Lưu nhà hàng yêu thích', badge: 'Đăng nhập', enabled: false),
                      _MenuItem(icon: Icons.shopping_bag_outlined, title: 'Lịch sử đơn hàng', subtitle: 'Theo dõi đơn hàng của bạn', badge: 'Đăng nhập', enabled: false),
                      _MenuItem(icon: Icons.store_outlined, title: 'Tạo Nhà hàng', subtitle: 'Quản lý nhà hàng của bạn', badge: 'Đăng nhập', enabled: false),
                    ]),
                    _Section(title: 'Cài đặt', children: [
                      _MenuItem(icon: Icons.settings_outlined, title: 'Cài đặt chung', onTap: () {}),
                    ]),
                  ],
                ),
              ),
            ),
            BottomNavBar(currentIndex: 4, onTap: (i) => _navTap(context, i), alertsCount: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedProfile(BuildContext context) {
    const hasRestaurantAccess = true;
    const canCreateRestaurant = true;

    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(AppTheme.spacing2xl, AppTheme.spacing2xl, AppTheme.spacing2xl, 96),
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primaryOrange, AppTheme.orangeDark]),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(color: AppTheme.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)]),
                    alignment: Alignment.center,
                    child: const Text('👨‍🍳', style: TextStyle(fontSize: 32)),
                  ),
                  const SizedBox(width: AppTheme.spacingLg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe', style: AppTheme.heading3.copyWith(color: AppTheme.white)),
                        Text('john.doe@email.com', style: AppTheme.body.copyWith(color: AppTheme.orangeLight)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(AppTheme.spacingLg, 0, AppTheme.spacingLg, AppTheme.spacingLg),
                child: Column(
                  children: [
                    const SizedBox(height: AppTheme.spacing4xl),
                    if (hasRestaurantAccess)
                      _Section(
                        title: 'Chế độ',
                        child: SwitchListTile(
                          value: _merchantMode,
                          onChanged: (v) {
                            setState(() => _merchantMode = v);
                            if (v) Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MerchantModeEntryScreen()));
                          },
                          title: Text(_merchantMode ? 'Merchant Mode' : 'Chế độ Khách hàng', style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                          subtitle: Text(_merchantMode ? 'Quản lý nhà hàng' : 'Duyệt và đặt món', style: AppTheme.bodySmall),
                          secondary: Icon(_merchantMode ? Icons.store : Icons.shopping_bag_outlined, color: _merchantMode ? Colors.purple : AppTheme.primaryOrange),
                          activeColor: AppTheme.primaryOrange,
                        ),
                      ),
                    if (!_merchantMode) ...[
                      _Section(
                        title: 'Hoạt động của tôi',
                        children: [
                          _MenuItem(icon: Icons.bookmark_border, title: 'Nhà hàng đã lưu', subtitle: '12 nhà hàng', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedScreen()))),
                          _MenuItem(icon: Icons.shopping_bag_outlined, title: 'Lịch sử đơn hàng', subtitle: '24 đơn hàng', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OrdersScreen()))),
                        ],
                      ),
                      if (canCreateRestaurant)
                        _Section(
                          title: 'Nhà hàng',
                          child: PrimaryButton(
                            label: 'Tạo Nhà hàng',
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateRestaurantScreen())),
                          ),
                        ),
                    ] else
                      _Section(
                        title: 'Không gian làm việc Nhà hàng',
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppTheme.spacingLg),
                              decoration: BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(AppTheme.radiusLg), border: Border.all(color: AppTheme.orangeLight)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primaryOrange, AppTheme.orangeDark]), borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                                        alignment: Alignment.center,
                                        child: const Text('🍔', style: TextStyle(fontSize: 24)),
                                      ),
                                      const SizedBox(width: AppTheme.spacingMd),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Joe's Burger Joint", style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                                            Text('Downtown Branch', style: AppTheme.bodySmall.copyWith(color: AppTheme.gray500)),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                              decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
                                              child: Text('Owner', style: AppTheme.bodySmall.copyWith(color: Colors.purple[700], fontWeight: FontWeight.w600)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppTheme.spacingLg),
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton.icon(
                                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MerchantModeEntryScreen())),
                                      icon: const Icon(Icons.arrow_forward),
                                      label: const Text('Vào Không gian làm việc'),
                                      style: TextButton.styleFrom(foregroundColor: AppTheme.white, backgroundColor: AppTheme.primaryOrange),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    _Section(title: 'Cài đặt', children: [_MenuItem(icon: Icons.settings_outlined, title: 'Cài đặt Tài khoản', onTap: () {})]),
                    const SizedBox(height: AppTheme.spacingMd),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text('Đăng xuất'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppTheme.error, side: const BorderSide(color: AppTheme.gray200), minimumSize: const Size(double.infinity, 48)),
                    ),
                    const SizedBox(height: AppTheme.spacing2xl),
                  ],
                ),
              ),
            ),
            BottomNavBar(currentIndex: 4, onTap: (i) => _navTap(context, i), alertsCount: 3),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.children, this.child});

  final String title;
  final List<Widget>? children;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingLg),
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(AppTheme.radiusXl), border: Border.all(color: AppTheme.gray100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppTheme.bodySmall.copyWith(color: AppTheme.gray500, letterSpacing: 0.5)),
          const SizedBox(height: AppTheme.spacingMd),
          if (child != null) child!,
          if (children != null) ...children!,
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.icon, required this.title, this.subtitle, this.badge, this.onTap, this.enabled = true});

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? badge;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: enabled ? AppTheme.orangeLight : AppTheme.gray100, child: Icon(icon, color: enabled ? AppTheme.primaryOrange : AppTheme.gray400)),
      title: Text(title, style: AppTheme.bodyLarge.copyWith(color: AppTheme.gray900)),
      subtitle: subtitle != null ? Text(subtitle!, style: AppTheme.bodySmall) : null,
      trailing: badge != null ? Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: AppTheme.orangeLight, borderRadius: BorderRadius.circular(999)), child: Text(badge!, style: AppTheme.bodySmall.copyWith(color: AppTheme.primaryOrange, fontWeight: FontWeight.w500))) : (onTap != null ? const Icon(Icons.chevron_right, color: AppTheme.gray400) : null),
      onTap: enabled ? onTap : null,
    );
  }
}
