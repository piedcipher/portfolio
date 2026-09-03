import 'dart:ui_web' as ui_web;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:web/web.dart' as web;

class TwitterEmbed extends StatefulWidget {
  const TwitterEmbed({super.key, required this.text, required this.url});

  final String text;
  final String url;

  @override
  State<TwitterEmbed> createState() => _TwitterEmbedState();
}

class _TwitterEmbedState extends State<TwitterEmbed> {
  late final String _viewType;
  bool _allowInteraction = false;

  @override
  void initState() {
    super.initState();
    final tweetId = Uri.parse(widget.url).pathSegments.last;
    _viewType = 'twitter-embed-$tweetId';
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (viewId) {
      final iframe = web.HTMLIFrameElement()
        ..src =
            'https://platform.twitter.com/embed/Tweet.html?id=$tweetId&ref_src=twsrc%5Etfw'
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '550px'
        ..setAttribute('scrolling', 'no');
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(height: 550, child: HtmlElementView(viewType: _viewType)),
            if (!_allowInteraction)
              Positioned.fill(
                child: PointerInterceptor(
                  child: Listener(
                    behavior: HitTestBehavior.opaque,
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        final scrollable = Scrollable.maybeOf(context);
                        if (scrollable == null) {
                          return;
                        }

                        final position = scrollable.position;
                        position.jumpTo(
                          (position.pixels + event.scrollDelta.dy).clamp(
                            position.minScrollExtent,
                            position.maxScrollExtent,
                          ),
                        );
                      }
                    },
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
          ],
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _allowInteraction = !_allowInteraction;
            });
          },
          icon: Icon(_allowInteraction ? Icons.pan_tool_alt : Icons.mouse),
          label: Text(
            _allowInteraction ? 'Back to scroll mode' : 'Interact with post',
          ),
        ),
      ],
    );
  }
}
