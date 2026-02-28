import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Segmented control: two options, Gray 100 bg, active segment white + shadow.
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.value,
    required this.onChanged,
    required this.options,
    this.labelBuilder,
  });

  final T value;
  final ValueChanged<T> onChanged;
  final List<T> options;
  final String Function(T)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.gray100,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Row(
        children: List.generate(options.length, (i) {
          final option = options[i];
          final isSelected = value == option;
          final label = labelBuilder != null
              ? labelBuilder!(option)
              : option.toString();
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  boxShadow: isSelected ? [AppTheme.shadowSm] : null,
                ),
                child: Text(
                  label,
                  style: AppTheme.bodyLarge.copyWith(
                    color: isSelected ? AppTheme.gray900 : AppTheme.gray600,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
