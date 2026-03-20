import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
// ignore: deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class YouTubePlayer extends StatefulWidget {
  final String videoUrl;
  final Color accentColor;

  const YouTubePlayer({
    super.key,
    required this.videoUrl,
    required this.accentColor,
  });

  @override
  State<YouTubePlayer> createState() => _YouTubePlayerState();
}

class _YouTubePlayerState extends State<YouTubePlayer> {
  late final String _viewType;

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

  @override
  void initState() {
    super.initState();
    final videoId = _extractVideoId(widget.videoUrl) ?? '';
    _viewType = 'youtube-player-$videoId-$hashCode';

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = 'https://www.youtube.com/embed/$videoId?rel=0&modestbranding=1'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.borderRadius = '8px'
          ..allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
          ..setAttribute('allowfullscreen', 'true');
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.infinity,
        height: 450,
        child: HtmlElementView(viewType: _viewType),
      ),
    );
  }
}
