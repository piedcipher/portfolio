import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;
import 'package:flutter/material.dart';

class FlutterJobBoard extends StatefulWidget {
  const FlutterJobBoard({super.key});

  @override
  State<FlutterJobBoard> createState() => _FlutterJobBoardState();
}

class _FlutterJobBoardState extends State<FlutterJobBoard> {
  @override
  void initState() {
    super.initState();
    ui_web.platformViewRegistry.registerViewFactory('notion-job-board', (
      int viewId,
    ) {
      final iframe = web.HTMLIFrameElement()
        ..src =
            'https://piedcipher.notion.site/Flutter-Job-Board-3766addaed67807aa6e8dee0cb5fdb92'
        ..style.border = 'none'
        ..width = '100%'
        ..height = '100%';

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: HtmlElementView(viewType: 'notion-job-board')),
    );
  }
}
