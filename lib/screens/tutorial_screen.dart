import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/primary_button.dart';

/// Tutorial / Quick Actions popup shown after login.
/// Full-screen overlay with dimmed background, X button top-right, and modal.
class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  void _close(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Dimmed barrier — tap to close
          GestureDetector(
            onTap: () => _close(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),

          // X button — top-right corner of screen
          Positioned(
            top: MediaQuery.of(context).padding.top + AppTheme.spacingSm,
            right: AppTheme.spacingLg,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () => _close(context),
                icon: Icon(
                  Icons.close,
                  size: 28,
                  color: AppTheme.gray400,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.white.withValues(alpha: 0.9),
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ),

          // Centered modal card
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing2xl),
              child: GestureDetector(
                onTap: () {}, // absorb tap so modal doesn't close
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 360),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(AppTheme.spacing2xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title + emoji
                      Text(
                        'Quick Actions 🚀',
                        style: AppTheme.heading3.copyWith(
                          color: AppTheme.gray900,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'Swipe to explore faster!',
                        style: AppTheme.body.copyWith(
                          color: AppTheme.gray500,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing2xl),

                      // Swipe Left row
                      _ActionRow(
                        circleColor: const Color(0xFFE3F2FD), // light blue
                        icon: Icons.arrow_back_ios_new_rounded,
                        iconSize: 20,
                        title: 'Swipe Left',
                        subtitle: 'Get directions on map',
                      ),
                      const SizedBox(height: AppTheme.spacingMd),

                      // Swipe Right row
                      _ActionRow(
                        circleColor: AppTheme.primaryOrange,
                        icon: Icons.arrow_forward_ios_rounded,
                        iconSize: 20,
                        title: 'Swipe Right',
                        subtitle: 'View restaurant menu',
                      ),
                      const SizedBox(height: AppTheme.spacing2xl),

                      // Got it! button
                      PrimaryButton(
                        label: 'Got it!',
                        onPressed: () => _close(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.circleColor,
    required this.icon,
    required this.iconSize,
    required this.title,
    required this.subtitle,
  });

  final Color circleColor;
  final IconData icon;
  final double iconSize;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.gray50,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: iconSize,
              color: AppTheme.white,
            ),
          ),
          const SizedBox(width: AppTheme.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.gray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTheme.body.copyWith(
                    color: AppTheme.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
