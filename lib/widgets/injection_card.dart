import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/injection_technique.dart';
import '../theme/app_theme.dart';
import '../theme/favorites_manager.dart';

class InjectionCard extends StatefulWidget {
  final InjectionTechnique technique;
  final bool isSelected;
  final int index;

  const InjectionCard({
    super.key,
    required this.technique,
    this.isSelected = false,
    this.index = 0,
  });

  @override
  State<InjectionCard> createState() => _InjectionCardState();
}

class _InjectionCardState extends State<InjectionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favManager = context.watch<FavoritesManager>();
    final isFav = favManager.isFavorite(widget.technique.id);
    final catColor = AppTheme.categoryColor(widget.technique.category);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Semantics(
      button: true,
      label: '${widget.technique.title}, ${widget.technique.category} injection',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: _isHovered && !reduceMotion
              // ignore: deprecated_member_use
              ? (Matrix4.identity()..translate(0.0, -2.0))
              : Matrix4.identity(),
          child: Material(
            color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.go('/procedure/${widget.technique.id}'),
              focusColor: catColor.withValues(alpha: 0.1),
              hoverColor: Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              child: AnimatedContainer(
                duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  border: Border.all(
                    color: widget.isSelected
                        ? catColor
                        : _isHovered
                            ? catColor.withValues(alpha: 0.4)
                            : (isDark ? AppTheme.borderDark : AppTheme.borderLight),
                    width: widget.isSelected ? 1.5 : 1,
                  ),
                  boxShadow: _isHovered || widget.isSelected
                      ? [
                          BoxShadow(
                            color: catColor.withValues(alpha: 0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category color bar (top edge)
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [catColor, catColor.withValues(alpha: 0.0)],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppTheme.radiusMd),
                          topRight: Radius.circular(AppTheme.radiusMd),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category + Favorite row
                            Row(
                              children: [
                                Text(
                                  widget.technique.category.toUpperCase(),
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                    color: catColor,
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
                                    onPressed: () => favManager.toggleFavorite(widget.technique.id),
                                    icon: AnimatedSwitcher(
                                      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
                                      child: Icon(
                                        isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                                        key: ValueKey(isFav),
                                        color: isFav ? AppTheme.amber : (isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight),
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Title
                            Text(
                              widget.technique.title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                height: 1.3,
                                color: isDark ? AppTheme.textPrimary : AppTheme.textPrimaryLight,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Push bottom content down
                            const Spacer(),
                            // Indication
                            Text(
                              widget.technique.treats.first,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // Tags
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: widget.technique.tags.take(2).map((tag) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: catColor.withValues(alpha: isDark ? 0.08 : 0.06),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: catColor.withValues(alpha: 0.15), width: 0.5),
                                ),
                                child: Text(
                                  tag.toUpperCase(),
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: catColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
