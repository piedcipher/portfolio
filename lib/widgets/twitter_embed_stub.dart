import 'package:flutter/material.dart';
import 'package:tirth_today/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class TwitterEmbed extends StatelessWidget {
  const TwitterEmbed({super.key, required this.text, required this.url});

  final String text;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withAlpha(230),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '“$text”',
                style: const TextStyle(fontSize: 16, height: 1.45),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tirth  ·  View on X',
                style: TextStyle(
                  color: AppColors.handwritingBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
