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
  late final String _viewType;
  html.IFrameElement? _iframe;

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

  void seekTo(int seconds) {
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
    seekTo(seconds);
    // Small delay to let seek register before play
    Future.delayed(const Duration(milliseconds: 200), play);
  }

  @override
  void initState() {
    super.initState();
    final videoId = _extractVideoId(widget.videoUrl) ?? '';
    _viewType = 'youtube-player-$videoId-$hashCode';

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        _iframe = html.IFrameElement()
          ..src =
              'https://www.youtube.com/embed/$videoId?rel=0&modestbranding=1&enablejsapi=1'
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
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasTimestamps = widget.timestamps.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video iframe
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: double.infinity,
            height: 450,
            child: HtmlElementView(viewType: _viewType),
          ),
        ),
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
                      color: widget.accentColor.withValues(alpha: isDark ? 0.1 : 0.08),
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
}
