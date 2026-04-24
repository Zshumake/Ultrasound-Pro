import 'package:flutter/widgets.dart';

class WebIFrameController {
  void postMessage(String message, String targetOrigin) {}
  void listenOnLoad(void Function() onData) {}
}

WebIFrameController? initWebIFrame(String viewType, String url, {bool allowFullscreen = true, String allow = ''}) {
  return null;
}

Widget buildWebIFrame(String viewType) {
  return const Center(child: Text("Interactive iframes are only supported on Web currently. Locally, use a Web browser."));
}
