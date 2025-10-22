import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_curl_effect/page_curl_effect.dart';
import 'package:tirth_today/pages/art_video_player_page.dart';
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
    return PageCurlEffect(
      pages: [HomePage(), WorkExperiencePage(), ArtVideoPlayer()],
      pageCurlController: PageCurlController(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ),
        pageCurlIndex: Pages.home.index,
        numberOfPage: Pages.values.length,
      ),
    );
  }
}
