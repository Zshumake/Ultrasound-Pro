import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Annotated US image gallery with labeled overlays.
/// Shows user-uploaded clinical images or placeholder slots.
class USImageGallery extends StatefulWidget {
  final List<String> imagePaths;
  final List<String> imageLabels;
  final Color accentColor;

  const USImageGallery({
    super.key,
    required this.imagePaths,
    required this.imageLabels,
    required this.accentColor,
  });

  @override
  State<USImageGallery> createState() => _USImageGalleryState();
}

class _USImageGalleryState extends State<USImageGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasImages = widget.imagePaths.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(Icons.collections_rounded,
                  color: widget.accentColor, size: 14),
            ),
            const SizedBox(width: 10),
            Text(
              'US IMAGE GALLERY',
              style: GoogleFonts.jetBrainsMono(
                color: widget.accentColor,
                fontWeight: FontWeight.w700,
                fontSize: 9,
                letterSpacing: 1.5,
              ),
            ),
            const Spacer(),
            if (hasImages)
              Text(
                '${_selectedIndex + 1} / ${widget.imagePaths.length}',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: isDark
                      ? AppTheme.textTertiary
                      : AppTheme.textSecondaryLight,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (hasImages)
          _buildImageViewer(context, isDark)
        else
          _buildPlaceholder(context, isDark),
      ],
    );
  }

  Widget _buildImageViewer(BuildContext context, bool isDark) {
    final label = _selectedIndex < widget.imageLabels.length
        ? widget.imageLabels[_selectedIndex]
        : '';

    return Column(
      children: [
        // Main image
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(
              color: widget.accentColor.withValues(alpha: 0.2),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                widget.imagePaths[_selectedIndex],
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Center(
                  child: Icon(Icons.broken_image_outlined,
                      color: AppTheme.textTertiary, size: 48),
                ),
              ),
              // Label overlay
              if (label.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Thumbnail strip
        if (widget.imagePaths.length > 1) ...[
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imagePaths.length,
              separatorBuilder: (_, _) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final isActive = index == _selectedIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Container(
                    width: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isActive
                            ? widget.accentColor
                            : (isDark
                                ? AppTheme.borderDark
                                : AppTheme.borderLight),
                        width: isActive ? 2 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      widget.imagePaths[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: isDark
                            ? AppTheme.surfaceDark
                            : AppTheme.bgLight,
                        child: Icon(Icons.image_outlined,
                            size: 16, color: AppTheme.textTertiary),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.bgLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.accentColor.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_a_photo_outlined,
              color: widget.accentColor.withValues(alpha: 0.4),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'US Images Coming Soon',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.textSecondary : AppTheme.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Annotated ultrasound stills with labeled anatomy\nwill be added as clinical images are captured.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              height: 1.5,
              color: isDark ? AppTheme.textTertiary : AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
