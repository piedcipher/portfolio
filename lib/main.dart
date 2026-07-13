import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:page_flip/page_flip.dart';
import 'package:tirth_today/pages/art_page.dart';
import 'package:tirth_today/pages/art_video_player_page.dart';
import 'package:tirth_today/pages/blog_list_page.dart';
import 'package:tirth_today/pages/blog_post_page.dart';
import 'package:tirth_today/pages/flutter_job_board.dart';
import 'package:tirth_today/pages/home_page.dart';
import 'package:tirth_today/pages/work_experience_page.dart';
import 'package:tirth_today/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Data.name,
      initialRoute: '/',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.notebookWhite),
        textTheme: GoogleFonts.pangolinTextTheme(),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.handwritingBlue,
          foregroundColor: Colors.white,
        ),
      ),
      routes: {
        '/': (_) => const MyHomePage(),
        '/flutter-job-board': (_) => const FlutterJobBoard(),
        '/blog': (_) => const BlogListPage(),
      },
      onGenerateRoute: (settings) {
        final routeName = settings.name ?? '/';
        final routeUri = Uri.tryParse(routeName);
        final normalizedPath = routeUri?.path ?? routeName;

        if (normalizedPath == '/blog') {
          final selectedTag = routeUri?.queryParameters['tag'];
          return MaterialPageRoute(
            builder: (_) => BlogListPage(initialTag: selectedTag),
            settings: settings,
          );
        }

        if (normalizedPath.startsWith('/blog/')) {
          final slug = normalizedPath.substring('/blog/'.length);
          return MaterialPageRoute(
            builder: (_) => BlogPostPage(slug: slug),
            settings: settings,
          );
        }

        return null;
      },
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const MyHomePage()),
    );
  }
}

class BlogNotFoundPage extends StatelessWidget {
  const BlogNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.notebookWhite,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Post not found',
                style: TextStyle(
                  fontSize: 28,
                  color: AppColors.handwritingBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This blog URL does not exist yet.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed('/blog'),
                child: const Text('Back to blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  void initState() {
    super.initState();
    if (GetIt.I.isRegistered<GlobalKey<PageFlipWidgetState>>()) {
      GetIt.I.unregister<GlobalKey<PageFlipWidgetState>>();
    }
    GetIt.I.registerSingleton<GlobalKey<PageFlipWidgetState>>(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return PageFlipWidget(
      key: _controller,
      backgroundColor: AppColors.notebookWhite,
      onFlipStart: () async {
        final audioPlayer = AudioPlayer();
        await audioPlayer.setAsset('assets/page_flip.mp3');
        await audioPlayer.play();
        await audioPlayer.stop();
      },
      lastPage: ArtVideoPlayer(),
      children: <Widget>[
        for (var i = 0; i < Pages.values.length; i++)
          switch (Pages.values[i]) {
            Pages.home => const HomePage(),
            Pages.workExperience => const WorkExperiencePage(),
            Pages.artPage => const ArtPage(),
            _ => const ArtVideoPlayer(),
          },
      ],
    );
  }
}
