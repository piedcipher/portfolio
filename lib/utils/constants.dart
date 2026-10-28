import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

enum Socials {
  github,
  stackOverflow,
  medium,
  twitter,
  linkedIn,
  speakerDeck,
  resume,
  art,
  unsplash,
  teampixel,
}

enum Pages { home, workExperience, artPage, artVideoPlayer }

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
      case Socials.resume:
        return 'Resume';
      case Socials.art:
        return 'Art';
      case Socials.unsplash:
        return 'Unsplash';
      case Socials.teampixel:
        return 'Photography #TeamPixel';
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
  Socials.resume: 'https://tirth.today/assets/assets/Tirth-Patel-Resume.pdf',
  Socials.unsplash: 'https://unsplash.com/@piedcipher',
  Socials.teampixel:
      'https://x.com/search?q=from%3Apiedcipher%20%23teampixel&src=typed_query',
};

abstract class Data {
  static const name = 'Tirth Patel';
  static const tagline = 'Engineer, Photographer, Artist';
}

abstract class BlogConfig {
  static const directory = 'assets/blogs';
}

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.paper,
    required this.margin,
    required this.rule,
    required this.ink,
    required this.mutedInk,
    required this.surface,
  });

  final Color paper;
  final Color margin;
  final Color rule;
  final Color ink;
  final Color mutedInk;
  final Color surface;

  static const light = AppPalette(
    paper: Color(0xFFF3EEFB),
    margin: Color(0xFFF4AAB0),
    rule: Color(0x1F000000),
    ink: Color(0xFF0039A6),
    mutedInk: Color(0xFF002B59),
    surface: Color(0xE6FFFFFF),
  );

  static const dark = AppPalette(
    paper: Color(0xFF171923),
    margin: Color(0xFFB76572),
    rule: Color(0x26FFFFFF),
    ink: Color(0xFFB8CCFF),
    mutedInk: Color(0xFFD4DEFF),
    surface: Color(0xE6262934),
  );

  @override
  AppPalette copyWith({
    Color? paper,
    Color? margin,
    Color? rule,
    Color? ink,
    Color? mutedInk,
    Color? surface,
  }) {
    return AppPalette(
      paper: paper ?? this.paper,
      margin: margin ?? this.margin,
      rule: rule ?? this.rule,
      ink: ink ?? this.ink,
      mutedInk: mutedInk ?? this.mutedInk,
      surface: surface ?? this.surface,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }

    return AppPalette(
      paper: Color.lerp(paper, other.paper, t)!,
      margin: Color.lerp(margin, other.margin, t)!,
      rule: Color.lerp(rule, other.rule, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      mutedInk: Color.lerp(mutedInk, other.mutedInk, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
