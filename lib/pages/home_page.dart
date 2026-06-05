import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:page_flip/page_flip.dart';
import 'package:tirth_today/layouts/notebook_layout.dart';
import 'package:tirth_today/pages/art_video_player_page.dart';
import 'package:tirth_today/utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          GetIt.I
              .get<GlobalKey<PageFlipWidgetState>>()
              .currentState
              ?.nextPage();
        },
        label: Text('Next Page'),
        tooltip: 'Page can be swiped as well',
      ),
      backgroundColor: AppColors.notebookWhite,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            NotebookLayout(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  Data.name,
                  style: TextStyle(
                    fontSize: 32,
                    color: AppColors.handwritingBlue,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dotted,
                    decorationColor: AppColors.handwritingBlue,
                    decorationThickness: .8,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  Data.tagline,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.handwritingBlue,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.wavy,
                    decorationColor: AppColors.handwritingBlue,
                    decorationThickness: .8,
                  ),
                ),
                const SizedBox(height: 12),
                OverflowBar(
                  spacing: 8,
                  overflowSpacing: 8,
                  children: [
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.github.tooltip,
                      icon: const FaIcon(FontAwesomeIcons.github),
                      onPressed: () {
                        Socials.github.launcher();
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.stackOverflow.tooltip,
                      icon: const FaIcon(FontAwesomeIcons.stackOverflow),
                      onPressed: () {
                        Socials.stackOverflow.launcher();
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.medium.tooltip,
                      icon: const FaIcon(FontAwesomeIcons.medium),
                      onPressed: () {
                        Socials.medium.launcher();
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.twitter.tooltip,
                      icon: const FaIcon(FontAwesomeIcons.xTwitter),
                      onPressed: () {
                        Socials.twitter.launcher();
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.linkedIn.tooltip,
                      icon: const FaIcon(FontAwesomeIcons.linkedinIn),
                      onPressed: () {
                        Socials.linkedIn.launcher();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OverflowBar(
                  spacing: 8,
                  overflowSpacing: 8,
                  children: [
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.speakerDeck.tooltip,
                      icon: const FaIcon(FontAwesomeIcons.speakerDeck),
                      onPressed: () {
                        Socials.speakerDeck.launcher();
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.resume.tooltip,
                      icon: const FaIcon(FontAwesomeIcons.file),
                      onPressed: () {
                        Socials.resume.launcher();
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.art.tooltip,
                      icon: const FaIcon(FontAwesomeIcons.paintbrush),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ArtVideoPlayer(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.unsplash.tooltip,
                      icon: const FaIcon(FontAwesomeIcons.unsplash),
                      onPressed: () {
                        Socials.unsplash.launcher();
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.teampixel.tooltip,
                      icon: const FaIcon(FontAwesomeIcons.cameraRetro),
                      onPressed: () {
                        Socials.teampixel.launcher();
                      },
                    ),
                  ],
                ),
              ],
            ),
            Positioned(left: 40, child: const Natraj()),
          ],
        ),
      ),
    );
  }
}

class Natraj extends StatefulWidget {
  const Natraj({super.key});

  @override
  State<Natraj> createState() => _NatrajState();
}

class _NatrajState extends State<Natraj> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sway;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: false);

    _sway = Tween<double>(
      begin: 40,
      end: 60,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(color: Colors.black),
          child: SizedBox(height: 100, width: 35),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(color: Colors.white),
          child: SizedBox(height: 10, width: 35),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black),
              child: SizedBox(height: 400, width: 35),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                  child: SizedBox(height: 400, width: 1),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                  child: SizedBox(height: 400, width: 2),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                  child: SizedBox(height: 400, width: 4),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                  child: SizedBox(height: 400, width: 4),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                  child: SizedBox(height: 400, width: 12),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                  child: SizedBox(height: 400, width: 4),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                  child: SizedBox(height: 400, width: 4),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                  child: SizedBox(height: 400, width: 2),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                  child: SizedBox(height: 400, width: 1),
                ),
              ],
            ),
          ],
        ),
        ClipPath(
          clipper: WoodClipper(),
          child: const DecoratedBox(
            decoration: BoxDecoration(color: Color(0xFFBC664F)),
            child: SizedBox(height: 65, width: 35),
          ),
        ),
        ClipPath(
          clipper: InkClipper(),
          child: const DecoratedBox(
            decoration: BoxDecoration(color: Color(0xFF141519)),
            child: SizedBox(height: 30, width: 15),
          ),
        ),
      ],
    );
  }
}

class WoodClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double offset = 10;
    final path = Path();
    path.lineTo(offset, height);
    path.lineTo(width - offset, height);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class InkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double offset = 7;
    final path = Path();
    path.lineTo(offset, height);
    path.lineTo(width - offset, height);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
