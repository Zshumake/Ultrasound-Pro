// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/widgets.dart';

class WebIFrameController {
  final html.IFrameElement iframe;
  WebIFrameController(this.iframe);

  void postMessage(String message, String targetOrigin) {
    iframe.contentWindow?.postMessage(message, targetOrigin);
  }

  void listenOnLoad(void Function() onData) {
    iframe.onLoad.listen((_) => onData());
  }
}

WebIFrameController? initWebIFrame(String viewType, String url, {bool allowFullscreen = true, String allow = ''}) {
  final iframe = html.IFrameElement()
    ..src = url
    ..style.border = 'none'
    ..style.width = '100%'
    ..style.height = '100%'
    ..style.borderRadius = '8px'
    ..allow = allow;

  if (allowFullscreen) {
    iframe.setAttribute('allowfullscreen', 'true');
  }

  ui_web.platformViewRegistry.registerViewFactory(
    viewType,
    (int viewId) => iframe,
  );
  return WebIFrameController(iframe);
}

Widget buildWebIFrame(String viewType) {
  return HtmlElementView(viewType: viewType);
}
