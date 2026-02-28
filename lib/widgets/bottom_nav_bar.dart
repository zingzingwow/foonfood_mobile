import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shared bottom navigation: Home, Search, Saved, Alerts, Profile.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.alertsCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int alertsCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppTheme.spacingMd,
        bottom: MediaQuery.of(context).padding.bottom + AppTheme.spacingSm,
        left: AppTheme.spacingLg,
        right: AppTheme.spacingLg,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_rounded, label: 'Home', isSelected: currentIndex == 0, onTap: () => onTap(0)),
          _NavItem(icon: Icons.search_rounded, label: 'Search', isSelected: currentIndex == 1, onTap: () => onTap(1)),
          _NavItem(icon: Icons.bookmark_outline_rounded, label: 'Saved', isSelected: currentIndex == 2, onTap: () => onTap(2)),
          _NavItem(icon: Icons.notifications_outlined, label: 'Alerts', isSelected: currentIndex == 3, badge: alertsCount > 0 ? alertsCount.toString() : null, onTap: () => onTap(3)),
          _NavItem(icon: Icons.person_outline_rounded, label: 'Profile', isSelected: currentIndex == 4, onTap: () => onTap(4)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.isSelected, required this.onTap, this.badge});

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 26, color: isSelected ? AppTheme.primaryOrange : AppTheme.gray600),
              if (badge != null)
                Positioned(
                  top: -4,
                  right: -10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: const BoxDecoration(color: AppTheme.error, shape: BoxShape.circle),
                    child: Text(badge!, style: const TextStyle(color: AppTheme.white, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: isSelected ? AppTheme.primaryOrange : AppTheme.gray600, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
        ],
      ),
    );
  }
}
