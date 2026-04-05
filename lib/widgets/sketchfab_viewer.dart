import 'package:flutter/material.dart';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SketchfabViewer extends StatefulWidget {
  final String modelId;
  final String? modelTitle;
  final Color accentColor;

  const SketchfabViewer({
    super.key,
    required this.modelId,
    required this.accentColor,
    this.modelTitle,
  });

  @override
  State<SketchfabViewer> createState() => _SketchfabViewerState();
}

class _SketchfabViewerState extends State<SketchfabViewer> {
  bool _activated = false;
  String? _viewType;
  bool _iframeLoaded = false;

  void _activate() {
    final viewType = 'sketchfab-viewer-${widget.modelId}-$hashCode';
    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src =
              'https://sketchfab.com/models/${widget.modelId}/embed?autostart=1&ui_theme=dark&ui_infos=0&ui_watermark_link=0&ui_watermark=0'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.borderRadius = '8px'
          ..allow = 'autoplay; fullscreen; xr-spatial-tracking'
          ..setAttribute('allowfullscreen', 'true');
        iframe.onLoad.listen((_) {
          if (mounted) setState(() => _iframeLoaded = true);
        });
        return iframe;
      },
    );
    setState(() {
      _viewType = viewType;
      _activated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              child: Icon(Icons.view_in_ar_rounded,
                  color: widget.accentColor, size: 14),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '3D ANATOMY',
                    style: GoogleFonts.jetBrainsMono(
                      color: widget.accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (widget.modelTitle != null)
                    Text(
                      widget.modelTitle!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? AppTheme.textSecondary
                            : AppTheme.textSecondaryLight,
                      ),
                    ),
                ],
              ),
            ),
            if (_activated)
              Text(
                'Drag to rotate',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9,
                  color: isDark
                      ? AppTheme.textTertiary
                      : AppTheme.textSecondaryLight,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_activated)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: widget.accentColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 400,
                  child: HtmlElementView(viewType: _viewType!),
                ),
                if (!_iframeLoaded)
                  Positioned.fill(
                    child: Container(
                      color: isDark
                          ? AppTheme.surfaceDark
                          : AppTheme.surfaceLight,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: widget.accentColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Loading 3D model...',
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 10,
                                color: isDark
                                    ? AppTheme.textTertiary
                                    : AppTheme.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        else
          _buildLoadButton(isDark),
      ],
    );
  }

  Widget _buildLoadButton(bool isDark) {
    return InkWell(
      onTap: _activate,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : AppTheme.bgLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_in_ar_rounded,
              color: widget.accentColor.withValues(alpha: 0.5),
              size: 32,
            ),
            const SizedBox(height: 10),
            Text(
              'TAP TO LOAD 3D MODEL',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: widget.accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Interactive anatomy viewer',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark
                    ? AppTheme.textTertiary
                    : AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
