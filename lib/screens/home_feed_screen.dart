import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_theme.dart';
import 'search_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';
import 'notification_center_screen.dart';

/// TikTok-style vertical video feed. Each page is full-screen video with overlays.
class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedNavIndex = 0;
  bool _bottomNavVisible = true;

  /// Dummy feed items: video URL + restaurant info. Replace with real API.
  static final List<FeedItem> _feedItems = [
    FeedItem(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      restaurantName: "Joe's Burger Joint",
      rating: 4.8,
      distance: '0.5 mi',
      likeCount: 1243,
      commentCount: 89,
    ),
    FeedItem(
      videoUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      restaurantName: 'Pho Saigon',
      rating: 4.6,
      distance: '1.2 mi',
      likeCount: 892,
      commentCount: 42,
    ),
    FeedItem(
      videoUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      restaurantName: 'Pizza Roma',
      rating: 4.9,
      distance: '0.8 mi',
      likeCount: 2100,
      commentCount: 156,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_currentPage == index) return;
    final swipedUp = index > _currentPage;
    setState(() {
      _currentPage = index;
      if (swipedUp) {
        _bottomNavVisible = false;
      } else {
        _bottomNavVisible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Vertical video feed (one video per page)
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: _onPageChanged,
            itemCount: _feedItems.length,
            itemBuilder: (context, index) {
              return _FeedVideoPage(
                item: _feedItems[index],
                isActive: index == _currentPage,
                onShowBottomNav: () => setState(() => _bottomNavVisible = true),
              );
            },
          ),

          // Bottom navigation bar (ẩn khi vuốt lên feed, hiện khi vuốt xuống / ấn pause / sang màn khác)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: !_bottomNavVisible,
              child: AnimatedOpacity(
                opacity: _bottomNavVisible ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: _BottomNavBar(
                  currentIndex: _selectedNavIndex,
                  onTap: (index) {
                    setState(() => _bottomNavVisible = true);
                    if (index == 1) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
                    } else if (index == 2) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SavedScreen()));
                    } else if (index == 3) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationCenterScreen()));
                    } else if (index == 4) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
                    } else {
                      setState(() => _selectedNavIndex = index);
                    }
                  },
                  alertsCount: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedItem {
  const FeedItem({
    required this.videoUrl,
    required this.restaurantName,
    required this.rating,
    required this.distance,
    required this.likeCount,
    required this.commentCount,
  });

  final String videoUrl;
  final String restaurantName;
  final double rating;
  final String distance;
  final int likeCount;
  final int commentCount;
}

/// Single full-screen video page with overlays (restaurant info, actions, CTAs).
class _FeedVideoPage extends StatefulWidget {
  const _FeedVideoPage({
    required this.item,
    required this.isActive,
    this.onShowBottomNav,
  });

  final FeedItem item;
  final bool isActive;
  final VoidCallback? onShowBottomNav;

  @override
  State<_FeedVideoPage> createState() => _FeedVideoPageState();
}

class _FeedVideoPageState extends State<_FeedVideoPage> {
  VideoPlayerController? _controller;
  VoidCallback? _listener;
  bool _showControls = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void didUpdateWidget(_FeedVideoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _controller?.play();
      } else {
        _controller?.pause();
      }
    }
  }

  Future<void> _initVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.item.videoUrl));
    _listener = () => setState(() {});
    _controller!.addListener(_listener!);
    await _controller!.initialize();
    if (mounted && widget.isActive) {
      _controller!.play();
      _controller!.setLooping(true);
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    if (_listener != null) _controller?.removeListener(_listener!);
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      _showControls = true;
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
    _hideControlsAfterDelay();
  }

  void _seekRelative(double seconds) {
    if (_controller == null) return;
    final pos = _controller!.value.position + Duration(milliseconds: (seconds * 1000).round());
    final dur = _controller!.value.duration;
    _controller!.seekTo(pos.inMilliseconds > dur.inMilliseconds ? dur : (pos.inMilliseconds < 0 ? Duration.zero : pos));
    setState(() => _showControls = true);
    _hideControlsAfterDelay();
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _controller != null && _controller!.value.isPlaying && _showControls) {
        setState(() => _showControls = false);
      }
    });
  }

  void _onVideoTap() {
    if (!widget.isActive) return;
    widget.onShowBottomNav?.call();
    setState(() => _showControls = true);
    _togglePlayPause();
  }

  void _toggleMute() {
    if (_controller == null) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0.0 : 1.0);
      _showControls = true;
    });
    _hideControlsAfterDelay();
  }

  static String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  /// Cỡ tròn bằng 4 nút bên hông (Thả tim, Comment, ...)
  static const double _centerTuaCircleSize = 44;
  static const double _centerTuaIconSize = 24;
  /// Play = 1.5 lần nút bên hông
  static const double _centerPlayCircleSize = 66; // 44 * 1.5
  static const double _centerPlayIconSize = 36;   // 24 * 1.5

  Widget _centerControlButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _centerTuaCircleSize,
        height: _centerTuaCircleSize,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: AppTheme.white, size: _centerTuaIconSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video
        if (_controller != null && _controller!.value.isInitialized)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          )
        else
          Container(
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryOrange),
            ),
          ),

        // Gradient overlay for readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
        ),

        // Tap area: play/pause (tránh che nút bên phải và dưới)
        if (widget.isActive && _controller != null && _controller!.value.isInitialized)
          Positioned(
            left: 0,
            right: 72,
            top: 100,
            bottom: 200,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _onVideoTap,
            ),
          ),

        // Center controls: tua 10s | play/pause | tua +10s (khi pause hoặc khi đang hiện controls)
        if (widget.isActive &&
            _controller != null &&
            _controller!.value.isInitialized &&
            (_showControls || !_controller!.value.isPlaying))
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _centerControlButton(
                  icon: Icons.replay_10_rounded,
                  onTap: () => _seekRelative(-10),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: _onVideoTap,
                  child: Container(
                    width: _centerPlayCircleSize,
                    height: _centerPlayCircleSize,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      _controller!.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: AppTheme.white,
                      size: _centerPlayIconSize,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _centerControlButton(
                  icon: Icons.forward_10_rounded,
                  onTap: () => _seekRelative(10),
                ),
              ],
            ),
          ),

        // Top-left: Restaurant name, rating, distance
        Positioned(
          top: MediaQuery.of(context).padding.top + AppTheme.spacingLg,
          left: AppTheme.spacingLg,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.restaurantName,
                style: const TextStyle(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      offset: Offset(0, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber[400], size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.item.rating}',
                    style: const TextStyle(
                      color: AppTheme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.location_on_outlined,
                      color: AppTheme.white.withValues(alpha: 0.95), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    widget.item.distance,
                    style: TextStyle(
                      color: AppTheme.white.withValues(alpha: 0.95),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Right side: Like, Comment, Save, Share, Mute/Unmute (cuộn được trên màn nhỏ)
        Positioned(
          top: MediaQuery.of(context).padding.top + AppTheme.spacing3xl + 200,
          bottom: 160,
          right: AppTheme.spacingMd,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionButton(
                  icon: Icons.favorite_border,
                  label: _formatCount(widget.item.likeCount),
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: _formatCount(widget.item.commentCount),
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: Icons.bookmark_border,
                  label: null,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: null,
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  label: null,
                  onTap: _toggleMute,
                ),
              ],
            ),
          ),
        ),

        // Bottom: View Menu + Directions (above bottom nav)
        Positioned(
          left: AppTheme.spacingLg,
          right: AppTheme.spacingLg,
          bottom: 80,
          child: Row(
            children: [
              Expanded(
                child: _CtaButton(
                  label: 'View Menu',
                  icon: Icons.menu_rounded,
                  isPrimary: true,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: _CtaButton(
                  label: 'Directions',
                  icon: Icons.location_on_outlined,
                  isPrimary: false,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String? label;
  final VoidCallback onTap;

  static const double _circleSize = 44;
  static const double _iconSize = 24;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _circleSize,
            height: _circleSize,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppTheme.white, size: _iconSize),
          ),
          if (label != null) ...[
            const SizedBox(height: 6),
            Text(
              label!,
              style: const TextStyle(
                color: AppTheme.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onPressed;

  static const double _buttonHeight = 48;

  @override
  Widget build(BuildContext context) {
    const radius = _buttonHeight / 2;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          height: _buttonHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isPrimary ? AppTheme.primaryOrange : AppTheme.white,
            borderRadius: BorderRadius.circular(radius),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: isPrimary ? AppTheme.white : AppTheme.gray900,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? AppTheme.white : AppTheme.gray900,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
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
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.search_rounded,
            label: 'Search',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            icon: Icons.bookmark_outline_rounded,
            label: 'Saved',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            icon: Icons.notifications_outlined,
            label: 'Alerts',
            isSelected: currentIndex == 3,
            badge: alertsCount > 0 ? alertsCount.toString() : null,
            onTap: () => onTap(3),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isSelected: currentIndex == 4,
            onTap: () => onTap(4),
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
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
