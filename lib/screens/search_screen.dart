import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'restaurant_detail_screen.dart';

/// Search / Khám Phá screen: trending chips, restaurant list, filter by query.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  List<RestaurantSearchItem> _filteredRestaurants = _mockRestaurants;
  static const List<RestaurantSearchItem> _mockRestaurants = [
    RestaurantSearchItem(
      id: 1,
      name: "Joe's Burger Joint",
      rating: 4.8,
      reviews: 234,
      distance: '0.5 mi',
      cuisine: 'American',
      deliveryTime: '20-30 min',
      imageUrl:
          'https://images.unsplash.com/photo-1632898657999-ae6920976661?w=400&q=80',
    ),
    RestaurantSearchItem(
      id: 2,
      name: 'Bella Italia',
      rating: 4.9,
      reviews: 456,
      distance: '1.2 mi',
      cuisine: 'Italian',
      deliveryTime: '25-35 min',
      imageUrl:
          'https://images.unsplash.com/photo-1609166639722-47053ca112ea?w=400&q=80',
    ),
    RestaurantSearchItem(
      id: 3,
      name: 'Sushi Paradise',
      rating: 4.7,
      reviews: 189,
      distance: '2.1 mi',
      cuisine: 'Japanese',
      deliveryTime: '30-40 min',
      imageUrl:
          'https://images.unsplash.com/photo-1728395235153-5999948803cb?w=400&q=80',
    ),
  ];

  static const List<String> _trendingSearches = [
    'Burgers',
    'Pizza',
    'Sushi',
    'Tacos',
    'Thai Food',
    'Salads',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredRestaurants = _mockRestaurants;
      } else {
        final q = query.toLowerCase();
        _filteredRestaurants = _mockRestaurants
            .where(
              (r) =>
                  r.name.toLowerCase().contains(q) ||
                  r.cuisine.toLowerCase().contains(q),
            )
            .toList();
      }
    });
  }

  void _onTrendingTap(String term) {
    _searchController.text = term;
    _onSearchChanged(term);
  }

  void _onRestaurantTap(RestaurantSearchItem restaurant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RestaurantDetailScreen(restaurantId: restaurant.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text;
    final showTrending = query.trim().isEmpty;
    final showEmptyState =
        query.trim().isNotEmpty && _filteredRestaurants.isEmpty;

    return Scaffold(
      backgroundColor: AppTheme.gray50,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky header with gradient + search
            _SearchHeader(
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showTrending) ...[
                      // Trending
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            size: 22,
                            color: AppTheme.primaryOrange,
                          ),
                          const SizedBox(width: AppTheme.spacingSm),
                          Text(
                            'Trending',
                            style: AppTheme.heading3.copyWith(
                              color: AppTheme.gray900,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      Wrap(
                        spacing: AppTheme.spacingSm,
                        runSpacing: AppTheme.spacingSm,
                        children: _trendingSearches
                            .map(
                              (term) => _TrendChip(
                                label: term,
                                onTap: () => _onTrendingTap(term),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: AppTheme.spacing2xl),
                      Text(
                        'Popular Restaurants',
                        style: AppTheme.heading3.copyWith(
                          color: AppTheme.gray900,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                    ],

                    if (showEmptyState)
                      _EmptySearchState()
                    else
                      ..._filteredRestaurants
                          .map(
                            (r) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppTheme.spacingMd),
                              child: _RestaurantCard(
                                restaurant: r,
                                onTap: () => _onRestaurantTap(r),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),

            // Bottom navigation
            _SearchBottomNav(
              currentIndex: 1,
              alertsCount: 3,
              onHomeTap: () => Navigator.of(context).pop(),
              onSearchTap: () {},
              onSavedTap: () {},
              onAlertsTap: () {},
              onProfileTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantSearchItem {
  const RestaurantSearchItem({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.cuisine,
    required this.deliveryTime,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final double rating;
  final int reviews;
  final String distance;
  final String cuisine;
  final String deliveryTime;
  final String imageUrl;
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.searchController,
    required this.searchFocusNode,
    required this.onChanged,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingLg,
        AppTheme.spacing2xl,
        AppTheme.spacingLg,
        AppTheme.spacing2xl,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryOrange,
            AppTheme.orangeDark,
            AppTheme.orangePressed,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Khám Phá',
            style: AppTheme.heading2.copyWith(
              color: AppTheme.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          TextField(
            controller: searchController,
            focusNode: searchFocusNode,
            onChanged: onChanged,
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.gray900),
            decoration: InputDecoration(
              hintText: 'Tìm nhà hàng hoặc món ăn...',
              hintStyle: AppTheme.bodyLarge.copyWith(color: AppTheme.gray400),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 22,
                color: AppTheme.gray400,
              ),
              filled: true,
              fillColor: AppTheme.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(999),
                borderSide: BorderSide(color: AppTheme.primaryOrange, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendChip extends StatelessWidget {
  const _TrendChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingLg,
            vertical: AppTheme.spacingSm + 2,
          ),
          decoration: BoxDecoration(
            color: AppTheme.gray100,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: AppTheme.body.copyWith(
              color: AppTheme.gray900,
            ),
          ),
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({
    required this.restaurant,
    required this.onTap,
  });

  final RestaurantSearchItem restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.gray200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                child: Image.network(
                  restaurant.imageUrl,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 96,
                    height: 96,
                    color: AppTheme.gray200,
                    child: const Icon(Icons.restaurant, color: AppTheme.gray400),
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.gray900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.cuisine,
                      style: AppTheme.body.copyWith(color: AppTheme.gray500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${restaurant.rating}',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.gray900,
                          ),
                        ),
                        Text(
                          ' (${restaurant.reviews})',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.gray400,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppTheme.gray500,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          restaurant.distance,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.gray500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppTheme.gray500,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          restaurant.deliveryTime,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.gray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing3xl),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_rounded,
              size: 64,
              color: AppTheme.gray200,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'No restaurants found',
              style: AppTheme.body.copyWith(color: AppTheme.gray500),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Try searching for something else',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.gray400),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBottomNav extends StatelessWidget {
  const _SearchBottomNav({
    required this.currentIndex,
    required this.alertsCount,
    required this.onHomeTap,
    required this.onSearchTap,
    required this.onSavedTap,
    required this.onAlertsTap,
    required this.onProfileTap,
  });

  final int currentIndex;
  final int alertsCount;
  final VoidCallback onHomeTap;
  final VoidCallback onSearchTap;
  final VoidCallback onSavedTap;
  final VoidCallback onAlertsTap;
  final VoidCallback onProfileTap;

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
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: onHomeTap,
          ),
          _NavItem(
            icon: Icons.search_rounded,
            label: 'Search',
            isSelected: currentIndex == 1,
            onTap: onSearchTap,
          ),
          _NavItem(
            icon: Icons.bookmark_outline_rounded,
            label: 'Saved',
            isSelected: currentIndex == 2,
            onTap: onSavedTap,
          ),
          _NavItem(
            icon: Icons.notifications_outlined,
            label: 'Alerts',
            isSelected: currentIndex == 3,
            badge: alertsCount > 0 ? alertsCount.toString() : null,
            onTap: onAlertsTap,
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isSelected: currentIndex == 4,
            onTap: onProfileTap,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

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
              Icon(
                icon,
                size: 26,
                color: isSelected ? AppTheme.primaryOrange : AppTheme.gray600,
              ),
              if (badge != null)
                Positioned(
                  top: -4,
                  right: -10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 2),
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppTheme.primaryOrange : AppTheme.gray600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
