import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ResidentPearlsCard extends StatelessWidget {
  final List<String> pearls;

  const ResidentPearlsCard({super.key, required this.pearls});

  @override
  Widget build(BuildContext context) {
    if (pearls.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    const pearlColor = Color(0xFFFFAA00); // Amber — wisdom color

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: pearlColor.withValues(alpha: isDark ? 0.04 : 0.03),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: pearlColor.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: pearlColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.psychology_outlined, color: pearlColor, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESIDENT PEARLS',
                    style: GoogleFonts.jetBrainsMono(
                      color: pearlColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Institutional Wisdom & Expert Tips',
                    style: GoogleFonts.inter(
                      color: isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...pearls.asMap().entries.map((entry) => _buildPearlItem(context, entry.value, entry.key, isDark)),
        ],
      ),
    );
  }

  Widget _buildPearlItem(BuildContext context, String pearl, int index, bool isDark) {
    const pearlColor = Color(0xFFFFAA00);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.auto_awesome,
              size: 12,
              color: pearlColor.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              pearl,
              style: GoogleFonts.inter(
                color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
