import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum Socials { github, stackOverflow, medium, twitter, linkedIn, speakerDeck }

enum Pages { home, workExperience, artVideoPlayer }

extension SocialsExtension on Socials {
  void launcher() async {
    final url = Uri.parse(_socials[this]!);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  String get tooltip {
    switch (this) {
      case Socials.github:
        return 'GitHub';
      case Socials.stackOverflow:
        return 'Stack Overflow';
      case Socials.medium:
        return 'Medium';
      case Socials.twitter:
        return 'Twitter';
      case Socials.linkedIn:
        return 'LinkedIn';
      case Socials.speakerDeck:
        return 'Speaker Deck';
    }
  }
}

const _socials = {
  Socials.github: 'https://github.com/piedcipher',
  Socials.stackOverflow: 'https://stackoverflow.com/users/4593315/tirth-patel',
  Socials.medium: 'https://medium.com/@piedcipher',
  Socials.twitter: 'https://x.com/piedcipher',
  Socials.linkedIn: 'https://linkedin.com/in/tirth-patel',
  Socials.speakerDeck: 'https://speakerdeck.com/piedcipher',
};

abstract class Data {
  static const name = 'Tirth Patel';
  static const tagline = 'engineer, photographer, artist';
}

abstract class AppColors {
  static const noteBookWhite = Color(0xFFF3EEFB);
  static final notebookRed = Colors.redAccent[100];
  static final notebookBlack = Colors.black26.withAlpha(30);
  static const handwritingBlue = Color(0xFF0039A6);
  static const handwritingDarkBlue = Color(0xFF002b59);
}
