import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Interactive 3D body viewer showing patient positioning and probe placement.
///
/// Embeds the Three.js viewer (web/three_viewer/index.html) via iframe
/// and communicates via postMessage to load procedures, apply poses,
/// and position the ultrasound probe.
class BodyViewer3D extends StatefulWidget {
  /// The procedure ID (e.g., "shoulder-sasd") — matches keys in base_poses.json
  final String procedureId;

  /// Accent color for the header and borders
  final Color accentColor;

  /// Optional label shown above the viewer
  final String? label;

  const BodyViewer3D({
    super.key,
    required this.procedureId,
    required this.accentColor,
    this.label,
  });

  @override
  State<BodyViewer3D> createState() => _BodyViewer3DState();
}

class _BodyViewer3DState extends State<BodyViewer3D> {
  bool _activated = false;
  String? _viewType;
  bool _viewerReady = false;
  bool _modelLoaded = false;
  html.IFrameElement? _iframe;
  StreamSubscription? _messageSub;

  void _activate() {
    final viewType =
        'body-viewer-3d-${widget.procedureId}-${DateTime.now().millisecondsSinceEpoch}';

    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = 'three_viewer/index.html'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.borderRadius = '8px'
          ..allow = 'autoplay';
        _iframe = iframe;
        return iframe;
      },
    );

    // Listen for postMessage from the iframe
    _messageSub = html.window.onMessage.listen(_onMessage);

    setState(() {
      _viewType = viewType;
      _activated = true;
    });
  }

  void _onMessage(html.MessageEvent event) {
    try {
      final data = event.data is String
          ? jsonDecode(event.data as String)
          : event.data;

      if (data is! Map) return;

      switch (data['type']) {
        case 'ready':
          setState(() => _viewerReady = true);
          // Send the procedure to load
          _sendMessage({
            'type': 'loadProcedure',
            'procedureId': widget.procedureId,
          });
          break;

        case 'loaded':
          setState(() => _modelLoaded = true);
          break;
      }
    } catch (_) {
      // Not our message
    }
  }

  void _sendMessage(Map<String, dynamic> msg) {
    if (_iframe?.contentWindow != null) {
      _iframe!.contentWindow!.postMessage(jsonEncode(msg), '*');
    }
  }

  @override
  void didUpdateWidget(BodyViewer3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.procedureId != widget.procedureId && _viewerReady) {
      setState(() => _modelLoaded = false);
      _sendMessage({
        'type': 'loadProcedure',
        'procedureId': widget.procedureId,
      });
    }
  }

  @override
  void dispose() {
    _messageSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: widget.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(Icons.accessibility_new_rounded,
                  color: widget.accentColor, size: 14),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PATIENT POSITIONING',
                    style: GoogleFonts.jetBrainsMono(
                      color: widget.accentColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (widget.label != null)
                    Text(
                      widget.label!,
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
            if (_activated && _modelLoaded)
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

        // Viewer or load button
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
                if (!_modelLoaded)
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
                              'Loading 3D body...',
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
              Icons.accessibility_new_rounded,
              color: widget.accentColor.withValues(alpha: 0.5),
              size: 32,
            ),
            const SizedBox(height: 10),
            Text(
              'TAP TO VIEW POSITIONING',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: widget.accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Interactive 3D body with probe placement',
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
