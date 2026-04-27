import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Injection site illustration with optional in-plane / out-of-plane toggle.
/// Red dot = needle entry point. Blue bar = probe placement.
///
/// Pass [onAxisChanged] to be notified when the user switches tabs.
/// Receives `true` for IN PLANE (long-axis image), `false` for OUT OF PLANE.
class InjectionIllustration extends StatefulWidget {
  final String longImg;
  final String? shortImg;
  final Color catColor;
  /// Optional callback fired whenever the axis tab changes.
  final ValueChanged<bool>? onAxisChanged;

  const InjectionIllustration({
    super.key,
    required this.longImg,
    this.shortImg,
    required this.catColor,
    this.onAxisChanged,
  });

  @override
  State<InjectionIllustration> createState() => _InjectionIllustrationState();
}

class _InjectionIllustrationState extends State<InjectionIllustration> {
  bool _isLong = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasToggle = widget.shortImg != null;
    final currentImg = _isLong ? widget.longImg : widget.shortImg!;
    final labelColor = isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Legend: red dot = needle entry
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            // Legend: blue bar = probe
            Container(
              width: 22,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'NEEDLE ENTRY  ·  PROBE',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: labelColor,
              ),
            ),
            // IN PLANE / OUT OF PLANE toggle
            if (hasToggle) ...[
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surfaceDark : AppTheme.borderLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _AxisTab(
                      label: 'IN PLANE',
                      selected: _isLong,
                      color: widget.catColor,
                      onTap: () {
                        setState(() => _isLong = true);
                        widget.onAxisChanged?.call(true);
                      },
                    ),
                    _AxisTab(
                      label: 'OUT OF PLANE',
                      selected: !_isLong,
                      color: widget.catColor,
                      onTap: () {
                        setState(() => _isLong = false);
                        widget.onAxisChanged?.call(false);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.catColor.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd - 1),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Image.asset(
                  currentImg,
                  key: ValueKey(currentImg),
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AxisTab extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _AxisTab({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: selected
                ? Colors.white
                : (isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight),
          ),
        ),
      ),
    );
  }
}
