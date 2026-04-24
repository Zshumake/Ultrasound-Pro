// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:convert';
import 'package:flutter/widgets.dart';

class YouTubeIFrame {
  final html.IFrameElement iframe;
  YouTubeIFrame(this.iframe);

  void seekTo(int seconds) {
    iframe.contentWindow?.postMessage(
      jsonEncode({
        'event': 'command',
        'func': 'seekTo',
        'args': [seconds, true],
      }),
      '*',
    );
  }

  void play() {
    iframe.contentWindow?.postMessage(
      jsonEncode({
        'event': 'command',
        'func': 'playVideo',
        'args': [],
      }),
      '*',
    );
  }
}

YouTubeIFrame? initWebPlayer(String viewType, String videoId, int? seekSeconds) {
  final startParam = seekSeconds != null ? '&start=$seekSeconds' : '';
  final iframe = html.IFrameElement()
    ..src =
        'https://www.youtube.com/embed/$videoId?rel=0&modestbranding=1&enablejsapi=1&autoplay=${seekSeconds != null ? 1 : 0}$startParam'
    ..style.border = 'none'
    ..style.width = '100%'
    ..style.height = '100%'
    ..style.borderRadius = '8px'
    ..allow =
        'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
    ..setAttribute('allowfullscreen', 'true');

  ui_web.platformViewRegistry.registerViewFactory(
    viewType,
    (int viewId) => iframe,
  );
  return YouTubeIFrame(iframe);
}

Widget buildWebPlayer(String viewType) {
  return HtmlElementView(viewType: viewType);
}
