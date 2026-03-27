import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
// ignore: deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import '../models/injection_technique.dart';
import '../theme/app_theme.dart';

class YouTubePlayer extends StatefulWidget {
  final String videoUrl;
  final Color accentColor;
  final List<VideoTimestamp> timestamps;

  const YouTubePlayer({
    super.key,
    required this.videoUrl,
    required this.accentColor,
    this.timestamps = const [],
  });

  @override
  State<YouTubePlayer> createState() => YouTubePlayerState();
}

class YouTubePlayerState extends State<YouTubePlayer> {
  bool _activated = false;
  String? _viewType;
  html.IFrameElement? _iframe;
  int? _pendingSeek;

  String? _extractVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'];
    }
    if (uri.host == 'youtu.be' && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.first;
    }
    return null;
  }

  void _activate({int? seekSeconds}) {
    if (_activated) return;
    final videoId = _extractVideoId(widget.videoUrl) ?? '';
    final viewType = 'youtube-player-$videoId-$hashCode';

    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) {
        final startParam = seekSeconds != null ? '&start=$seekSeconds' : '';
        _iframe = html.IFrameElement()
          ..src =
              'https://www.youtube.com/embed/$videoId?rel=0&modestbranding=1&enablejsapi=1&autoplay=${seekSeconds != null ? 1 : 0}$startParam'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.borderRadius = '8px'
          ..allow =
              'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
          ..setAttribute('allowfullscreen', 'true');
        return _iframe!;
      },
    );
    setState(() {
      _viewType = viewType;
      _activated = true;
    });
  }

  void seekTo(int seconds) {
    if (!_activated) {
      _activate(seekSeconds: seconds);
      return;
    }
    _iframe?.contentWindow?.postMessage(
      jsonEncode({
        'event': 'command',
        'func': 'seekTo',
        'args': [seconds, true],
      }),
      '*',
    );
  }

  void play() {
    _iframe?.contentWindow?.postMessage(
      jsonEncode({
        'event': 'command',
        'func': 'playVideo',
        'args': [],
      }),
      '*',
    );
  }

  void seekAndPlay(int seconds) {
    if (!_activated) {
      _activate(seekSeconds: seconds);
      return;
    }
    seekTo(seconds);
    Future.delayed(const Duration(milliseconds: 200), play);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasTimestamps = widget.timestamps.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_activated)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              height: 450,
              child: HtmlElementView(viewType: _viewType!),
            ),
          )
        else
          _buildLoadButton(isDark),
        // Chapter bar
        if (hasTimestamps) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.timestamps.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final ts = widget.timestamps[index];
                return InkWell(
                  onTap: () => seekAndPlay(ts.seconds),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.accentColor
                          .withValues(alpha: isDark ? 0.1 : 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: widget.accentColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_circle_outline_rounded,
                            size: 14, color: widget.accentColor),
                        const SizedBox(width: 5),
                        Text(
                          ts.label,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: widget.accentColor,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          ts.formattedTime,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 9,
                            color: isDark
                                ? AppTheme.textTertiary
                                : AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
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

  Widget _buildLoadButton(bool isDark) {
    return InkWell(
      onTap: () => _activate(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surfaceDark : AppTheme.bgLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_rounded,
              color: widget.accentColor.withValues(alpha: 0.6),
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'TAP TO LOAD VIDEO',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: widget.accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Procedure demonstration',
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
