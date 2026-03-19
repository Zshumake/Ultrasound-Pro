import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Monospaced, all-caps section header — like instrument panel labels
class MedicalSectionHeader extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color? color;

  const MedicalSectionHeader({
    super.key,
    required this.title,
    this.fontSize = 10,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 12,
          height: 1.5,
          color: color ?? AppTheme.cyan.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 10),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.jetBrainsMono(
            color: color ?? (isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight),
            fontWeight: FontWeight.w700,
            fontSize: fontSize,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}

/// Small tag pill with category-aware color
class MedicalTag extends StatelessWidget {
  final String text;
  final Color? color;

  const MedicalTag({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? AppTheme.cyan;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: isDark ? 0.08 : 0.06),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: c.withValues(alpha: 0.15), width: 0.5),
      ),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.jetBrainsMono(
          color: c.withValues(alpha: 0.8),
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Info panel with icon, title, and body text
class MedicalInfoBox extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;
  final Color? color;

  const MedicalInfoBox({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? AppTheme.cyan;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.withValues(alpha: isDark ? 0.04 : 0.03),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: c.withValues(alpha: 0.12), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: c, size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.jetBrainsMono(
                    color: c,
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(text, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Image placeholder with scanning-line aesthetic
class MedicalPlaceholderImage extends StatelessWidget {
  final String label;
  final double height;
  final bool isMain;
  final String? imagePath;

  const MedicalPlaceholderImage({
    super.key,
    required this.label,
    this.height = 150,
    this.isMain = false,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isMain ? AppTheme.cyan : (isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight);

    return Semantics(
      image: true,
      label: imagePath != null ? label : 'Placeholder: $label',
      child: Container(
        height: height,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceElevated : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isMain
                ? AppTheme.cyan.withValues(alpha: 0.2)
                : (isDark ? AppTheme.borderDark : AppTheme.borderLight),
            width: 1,
          ),
        ),
        child: imagePath != null
            ? Image.asset(
                imagePath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(context, accentColor, isDark),
              )
            : _buildPlaceholder(context, accentColor, isDark),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, Color accentColor, bool isDark) {
    return Stack(
      children: [
        // Grid pattern background
        if (isMain)
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter(color: accentColor.withValues(alpha: 0.06))),
          ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isMain ? Icons.monitor_heart_outlined : Icons.add_photo_alternate_outlined,
                color: accentColor.withValues(alpha: 0.3),
                size: isMain ? 36 : 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.jetBrainsMono(
                  color: accentColor.withValues(alpha: 0.4),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Grid background painter for US-view placeholder
class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 0.5;
    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bullet list item
class BulletPointItem extends StatelessWidget {
  final String text;

  const BulletPointItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.cyan.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

/// Numbered step with accent circle badge
class NumberedStepItem extends StatelessWidget {
  final int number;
  final String text;
  final Color? color;

  const NumberedStepItem({
    super.key,
    required this.number,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? AppTheme.cyan;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: c.withValues(alpha: isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: c.withValues(alpha: 0.2), width: 1),
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: GoogleFonts.jetBrainsMono(
                color: c,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }
}
