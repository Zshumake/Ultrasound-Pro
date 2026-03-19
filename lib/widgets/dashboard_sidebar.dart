import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_manager.dart';

class DashboardSidebar extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final Function(String) onCategorySelected;
  final bool isMobile;

  const DashboardSidebar({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategorySelected,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: isMobile ? double.infinity : 260,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        border: Border(
          right: BorderSide(
            color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildAppHeader(context, isDark),
          const SizedBox(height: AppTheme.space8),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.space8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                    child: Text(
                      'REGIONS',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                        color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
                      ),
                    ),
                  ),
                  ...categories.map((cat) => _buildSidebarItem(context, cat, isDark)),
                ],
              ),
            ),
          ),
          _buildFooter(context, isDark),
        ],
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Ultrasound icon with glow
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.cyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: AppTheme.cyan.withValues(alpha: 0.3), width: 1),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.monitor_heart_outlined, color: AppTheme.cyan, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'US GUIDED',
                style: GoogleFonts.jetBrainsMono(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 1.5,
                  color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
                ),
              ),
              Text(
                'INJECTION MANUAL',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.0,
                  color: AppTheme.cyan.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, String title, bool isDark) {
    final bool isSelected = selectedCategory == title;
    final catColor = _getCategoryColor(title);

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title category',
      child: InkWell(
        onTap: () {
          onCategorySelected(title);
          if (isMobile) Navigator.pop(context);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? catColor.withValues(alpha: isDark ? 0.08 : 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: isSelected
                ? Border.all(color: catColor.withValues(alpha: 0.2), width: 1)
                : Border.all(color: Colors.transparent, width: 1),
          ),
          child: Row(
            children: [
              // Accent bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: isSelected ? catColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                _getIconForCategory(title),
                size: 16,
                color: isSelected ? catColor : (isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? catColor : (isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    final tm = context.read<ThemeManager>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.cyan, Color(0xFF7B61FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text('R', style: GoogleFonts.jetBrainsMono(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700,
            )),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Resident', style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600, fontSize: 12,
                  color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
                )),
                Text(
                  'v2.1',
                  style: GoogleFonts.jetBrainsMono(
                    color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          // Theme toggle
          Semantics(
            button: true,
            label: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            child: InkWell(
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              onTap: () => tm.toggleTheme(!isDark),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (isDark ? AppTheme.borderDark : AppTheme.borderLight),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  size: 16,
                  color: isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'all': return AppTheme.cyan;
      case 'favorites': return AppTheme.amber;
      case 'recent': return const Color(0xFF7B61FF);
      default: return AppTheme.categoryColor(cat);
    }
  }

  IconData _getIconForCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'all': return Icons.grid_view_rounded;
      case 'favorites': return Icons.star_rounded;
      case 'recent': return Icons.history_rounded;
      case 'shoulder': return Icons.accessibility_new_rounded;
      case 'elbow': return Icons.adjust_rounded;
      case 'hand': return Icons.front_hand_rounded;
      case 'hip': return Icons.directions_walk_rounded;
      case 'knee': return Icons.nordic_walking_rounded;
      case 'foot': return Icons.do_not_step_rounded;
      default: return Icons.category_rounded;
    }
  }
}
