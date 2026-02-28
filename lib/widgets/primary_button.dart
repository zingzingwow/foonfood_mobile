import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Primary button per design specs: #FF6B35, 48px min height, 12px radius.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed =
        widget.enabled && !widget.isLoading ? widget.onPressed : null;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: effectiveOnPressed == null
          ? null
          : () {
              if (!widget.isLoading) effectiveOnPressed();
            },
      child: AnimatedScale(
        scale: _pressed && widget.enabled && !widget.isLoading ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48,
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: !widget.enabled
                ? AppTheme.gray200
                : _pressed && !widget.isLoading
                    ? AppTheme.orangePressed
                    : AppTheme.primaryOrange,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            boxShadow: !widget.enabled
                ? null
                : _pressed && !widget.isLoading
                    ? null
                    : [AppTheme.shadowOrange],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
                  ),
                )
              : Text(
                  widget.label,
                  style: AppTheme.buttonText.copyWith(
                    color: widget.enabled ? AppTheme.white : AppTheme.gray400,
                  ),
                ),
        ),
      ),
    );
  }
}
