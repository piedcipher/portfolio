import 'package:material_ui/material_ui.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:page_flip/page_flip.dart';
import 'package:tirth_today/pages/animals_page.dart' deferred as animals;
import 'package:tirth_today/pages/art_page.dart';
import 'package:tirth_today/pages/blog_list_page.dart' deferred as blog_list;
import 'package:tirth_today/pages/blog_post_page.dart' deferred as blog_post;
import 'package:tirth_today/pages/flutter_job_board.dart'
    deferred as flutter_job_board;
import 'package:tirth_today/pages/home_page.dart';
import 'package:tirth_today/pages/rough_page.dart';
import 'package:tirth_today/pages/work_experience_page.dart';
import 'package:tirth_today/utils/constants.dart';
import 'package:tirth_today/widgets/deferred_art_video_player.dart';
import 'package:tirth_today/widgets/deferred_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  ThemeData _buildTheme(AppPalette palette, Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.ink,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: palette.paper,
      extensions: [palette],
      fontFamily: GoogleFonts.pangolin().fontFamily,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.ink,
        foregroundColor: palette.paper,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Data.name,
      initialRoute: '/',
      theme: _buildTheme(AppPalette.light, Brightness.light),
      darkTheme: _buildTheme(AppPalette.dark, Brightness.dark),
      themeMode: _themeMode,
      routes: {
        '/': (_) => MyHomePage(onToggleTheme: _toggleTheme),
        '/flutter-job-board': (_) => DeferredPage(
          loadLibrary: flutter_job_board.loadLibrary,
          builder: (_) => flutter_job_board.FlutterJobBoard(),
        ),
        '/blog': (_) => DeferredPage(
          loadLibrary: blog_list.loadLibrary,
          builder: (_) => blog_list.BlogListPage(),
        ),
        '/animals': (_) => DeferredPage(
          loadLibrary: animals.loadLibrary,
          builder: (_) => animals.AnimalsPage(),
        ),
      },
      onGenerateRoute: (settings) {
        final routeName = settings.name ?? '/';
        final routeUri = Uri.tryParse(routeName);
        final normalizedPath = routeUri?.path ?? routeName;

        if (normalizedPath == '/blog') {
          final selectedTag = routeUri?.queryParameters['tag'];
          return MaterialPageRoute(
            builder: (_) => DeferredPage(
              loadLibrary: blog_list.loadLibrary,
              builder: (_) => blog_list.BlogListPage(initialTag: selectedTag),
            ),
            settings: settings,
          );
        }

        if (normalizedPath.startsWith('/blog/')) {
          final slug = normalizedPath.substring('/blog/'.length);
          return MaterialPageRoute(
            builder: (_) => DeferredPage(
              loadLibrary: blog_post.loadLibrary,
              builder: (_) => blog_post.BlogPostPage(slug: slug),
            ),
            settings: settings,
          );
        }

        return null;
      },
      onUnknownRoute: (_) => MaterialPageRoute(
        builder: (_) => MyHomePage(onToggleTheme: _toggleTheme),
      ),
    );
  }
}

class BlogNotFoundPage extends StatelessWidget {
  const BlogNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      backgroundColor: palette.paper,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Post not found',
                style: TextStyle(
                  fontSize: 28,
                  color: palette.ink,
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
  const MyHomePage({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = GlobalKey<PageFlipWidgetState>();
  bool _showRoughPage = false;

  @override
  void initState() {
    super.initState();
    if (GetIt.I.isRegistered<GlobalKey<PageFlipWidgetState>>()) {
      GetIt.I.unregister<GlobalKey<PageFlipWidgetState>>();
    }
    GetIt.I.registerSingleton<GlobalKey<PageFlipWidgetState>>(_controller);
  }

  void _returnToPreviousPage() {
    setState(() => _showRoughPage = false);
    _controller.currentState?.previousPage();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Stack(
      children: [
        PageFlipWidget(
          key: _controller,
          backgroundColor: palette.paper,
          onFlipStart: () async {
            final audioPlayer = AudioPlayer();
            await audioPlayer.setAsset('assets/page_flip.mp3');
            await audioPlayer.play();
            await audioPlayer.stop();
          },
          onPageFlipped: (pageNumber) {
            if (pageNumber == Pages.values.length) {
              setState(() => _showRoughPage = true);
            }
          },
          children: <Widget>[
            for (var i = 0; i < Pages.values.length; i++)
              switch (Pages.values[i]) {
                Pages.home => HomePage(onToggleTheme: widget.onToggleTheme),
                Pages.workExperience => const WorkExperiencePage(),
                Pages.artPage => const ArtPage(),
                Pages.artVideoPlayer => const DeferredArtVideoPlayer(),
              },
            const SizedBox.expand(),
          ],
        ),
        if (_showRoughPage)
          RoughPage(onReturnToPreviousPage: _returnToPreviousPage),
      ],
    );
  }
}
