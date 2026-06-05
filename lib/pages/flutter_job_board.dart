import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FlutterJobBoard extends StatefulWidget {
  const FlutterJobBoard({super.key});

  @override
  State<FlutterJobBoard> createState() => _FlutterJobBoardState();
}

class _FlutterJobBoardState extends State<FlutterJobBoard> {
  static final _uri = Uri.parse(
    'https://piedcipher.notion.site/Flutter-Job-Board-3766addaed67807aa6e8dee0cb5fdb92',
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await launchUrl(_uri, webOnlyWindowName: '_blank');

      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
