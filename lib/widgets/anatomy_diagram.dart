import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Split-view anatomy diagram: probe position (left) + expected sono view (right).
/// Shows placeholder slots until user adds their own clinical images.
class AnatomyDiagram extends StatelessWidget {
  final String? probePositionImg;
  final String? expectedSonoImg;
  final Color accentColor;
  final String procedureTitle;

  const AnatomyDiagram({
    super.key,
    this.probePositionImg,
    this.expectedSonoImg,
    required this.accentColor,
    required this.procedureTitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child:
                  Icon(Icons.schema_outlined, color: accentColor, size: 14),
            ),
            const SizedBox(width: 10),
            Text(
              'ANATOMY DIAGRAM',
              style: GoogleFonts.jetBrainsMono(
                color: accentColor,
                fontWeight: FontWeight.w700,
                fontSize: 9,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isMobile)
          Column(
            children: [
              _buildPanel(
                context,
                isDark: isDark,
                label: 'PROBE POSITION',
                icon: Icons.sensors_outlined,
                imagePath: probePositionImg,
                placeholderText: 'Probe placement photo\nwill be added',
              ),
              const SizedBox(height: 12),
              _buildPanel(
                context,
                isDark: isDark,
                label: 'EXPECTED US VIEW',
                icon: Icons.monitor_heart_outlined,
                imagePath: expectedSonoImg,
                placeholderText: 'Expected sonographic\nview will be added',
              ),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildPanel(
                  context,
                  isDark: isDark,
                  label: 'PROBE POSITION',
                  icon: Icons.sensors_outlined,
                  imagePath: probePositionImg,
                  placeholderText: 'Probe placement photo\nwill be added',
                ),
              ),
              const SizedBox(width: 12),
              // Arrow connector
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: accentColor.withValues(alpha: 0.3),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPanel(
                  context,
                  isDark: isDark,
                  label: 'EXPECTED US VIEW',
                  icon: Icons.monitor_heart_outlined,
                  imagePath: expectedSonoImg,
                  placeholderText: 'Expected sonographic\nview will be added',
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPanel(
    BuildContext context, {
    required bool isDark,
    required String label,
    required IconData icon,
    String? imagePath,
    required String placeholderText,
  }) {
    final hasImage = imagePath != null && imagePath.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: isDark ? 0.06 : 0.04),
              border: Border(
                bottom: BorderSide(
                  color: accentColor.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 12, color: accentColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          // Image or placeholder
          if (hasImage)
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _placeholderContent(isDark, placeholderText),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              height: 180,
              child: _placeholderContent(isDark, placeholderText),
            ),
        ],
      ),
    );
  }

  Widget _placeholderContent(bool isDark, String text) {
    return Container(
      color: isDark
          ? AppTheme.bgDark.withValues(alpha: 0.5)
          : AppTheme.bgLight,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: accentColor.withValues(alpha: 0.2),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark
                    ? AppTheme.textTertiary
                    : AppTheme.textSecondaryLight,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
