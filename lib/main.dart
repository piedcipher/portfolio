import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

enum Socials { github, stackOverflow, medium, twitter, linkedIn, speakerDeck }

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
  static final notebookBlack = Colors.black26.withOpacity(.1);
  static const handwritingBlue = Color(0xFF0039A6);
  static const handwritingDarkBlue = Color(0xFF002b59);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Data.name,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.noteBookWhite),
        textTheme: GoogleFonts.pangolinTextTheme(),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ArtVideoPlayer()),
          );
        },
        label: const Text('View Art'),
        icon: const Icon(Icons.brush),
      ),
      backgroundColor: AppColors.noteBookWhite,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                const SizedBox(width: 60),
                DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.notebookRed),
                  child: const SizedBox(width: 1.5, height: double.infinity),
                ),
                const SizedBox(width: 5),
                DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.notebookRed),
                  child: const SizedBox(width: 1.5, height: double.infinity),
                ),
                const Spacer(),
                DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.notebookRed),
                  child: const SizedBox(width: 1.5, height: double.infinity),
                ),
                const SizedBox(width: 5),
                DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.notebookRed),
                  child: const SizedBox(width: 1.5, height: double.infinity),
                ),
                const SizedBox(width: 60),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Column(
                      children: [
                        const SizedBox(height: 40),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.notebookBlack,
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.notebookRed),
                  child: const SizedBox(height: 1.5, width: double.infinity),
                ),
                const SizedBox(height: 5),
                DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.notebookRed),
                  child: const SizedBox(height: 1.5, width: double.infinity),
                ),
                const Spacer(),
                DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.notebookRed),
                  child: const SizedBox(height: 1.5, width: double.infinity),
                ),
                const SizedBox(height: 5),
                DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.notebookRed),
                  child: const SizedBox(height: 1.5, width: double.infinity),
                ),
                const SizedBox(height: 60),
              ],
            ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ArtVideoPlayer extends StatefulWidget {
  const ArtVideoPlayer({super.key});

  @override
  State<ArtVideoPlayer> createState() => _ArtVideoPlayerState();
}

class _ArtVideoPlayerState extends State<ArtVideoPlayer> {
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/art.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    VideoProgressIndicator(_controller, allowScrubbing: true),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
