import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tirth_today/layouts/notebook_layout.dart';
import 'package:tirth_today/pages/art_video_player_page.dart';
import 'package:tirth_today/pages/work_experience_page.dart';
import 'package:tirth_today/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.noteBookWhite,
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
                      icon: const Icon(FontAwesomeIcons.github),
                      onPressed: () {
                        Socials.github.launcher();
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.stackOverflow.tooltip,
                      icon: const Icon(FontAwesomeIcons.stackOverflow),
                      onPressed: () {
                        Socials.stackOverflow.launcher();
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.medium.tooltip,
                      icon: const Icon(FontAwesomeIcons.medium),
                      onPressed: () {
                        Socials.medium.launcher();
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
                      tooltip: Socials.twitter.tooltip,
                      icon: const Icon(FontAwesomeIcons.xTwitter),
                      onPressed: () {
                        Socials.twitter.launcher();
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.linkedIn.tooltip,
                      icon: const Icon(FontAwesomeIcons.linkedinIn),
                      onPressed: () {
                        Socials.linkedIn.launcher();
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.speakerDeck.tooltip,
                      icon: const Icon(FontAwesomeIcons.speakerDeck),
                      onPressed: () {
                        Socials.speakerDeck.launcher();
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
                      tooltip: Socials.resume.tooltip,
                      icon: const Icon(FontAwesomeIcons.file),
                      onPressed: () {
                        launchUrl(
                          Uri.parse(
                            'https://tirth.today/assets/assets/Tirth-Patel-Resume.pdf',
                          ),
                        );
                      },
                    ),
                    IconButton(
                      color: AppColors.handwritingBlue,
                      tooltip: Socials.art.tooltip,
                      icon: const Icon(FontAwesomeIcons.paintbrush),
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
                      tooltip: Socials.flip.tooltip,
                      icon: const Icon(FontAwesomeIcons.turnUp),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const WorkExperiencePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
