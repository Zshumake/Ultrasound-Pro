import 'package:flutter/widgets.dart';

class YouTubeIFrame {
  void seekTo(int seconds) {}
  void play() {}
}

YouTubeIFrame? initWebPlayer(String viewType, String videoId, int? seekSeconds) {
  // No-op for non-web platforms
  return null;
}

Widget buildWebPlayer(String viewType) {
  return const Center(child: Text("YouTube interactive player is only supported on Web currently. Natively you would open a link."));
}
