import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get_it/get_it.dart';
import 'package:page_flip/page_flip.dart';
import 'package:tirth_today/layouts/notebook_layout.dart';
import 'package:tirth_today/utils/constants.dart';

const List<String> _artImageFiles = [
  'Ads.jpeg',
  'Batman.jpeg',
  'BatmanGreen.jpeg',
  'BatmanRed.jpeg',
  'BatmanYellow.jpeg',
  'Beach.jpeg',
  'BeachEmoji.jpeg',
  'Beer.jpeg',
  'Bloc.jpeg',
  'Cake.jpeg',
  'CakeEmoji.jpeg',
  'Calc.jpeg',
  'Camera.jpeg',
  'Candy.png',
  'Cat.png',
  'Cheese.png',
  'Clock.jpeg',
  'Cookie.png',
  'Devs.jpeg',
  'English.jpeg',
  'Espresso.jpeg',
  'Figma.jpeg',
  'Find.jpeg',
  'Flutter.jpeg',
  'FlutterComm.jpeg',
  'FlutterFlakes.jpeg',
  'GO-Jgc0WwAAtN8l.jpeg',
  'Gemini.jpeg',
  'Google.jpeg',
  'HDFC.jpeg',
  'HighLevel.jpeg',
  'Honey.jpeg',
  'HoneyEmoji.jpeg',
  'Hotstar.jpeg',
  'JamalKudu.jpeg',
  'Keep.jpeg',
  'Kite.jpeg',
  'LG.jpeg',
  'Lemonade.jpeg',
  'MarvelJesus.jpeg',
  'Maths.png',
  'Note.jpeg',
  'Notes.jpeg',
  'Olympics.jpeg',
  'Omnitrix.jpeg',
  'OmnitrixTimeout.jpeg',
  'Patang.jpeg',
  'PaytmFlights.png',
  'Pencil.jpeg',
  'Photos.jpeg',
  'Rainbow.jpeg',
  'Rapido.jpeg',
  'React.jpeg',
  'Reminders.jpeg',
  'Scapia.jpeg',
  'Scapia2.jpeg',
  'Slack.jpeg',
  'Slackbot.jpeg',
  'Studio.jpeg',
  'Substack.jpeg',
  'Substack2.jpeg',
  'SuperMoney.jpeg',
  'TVF.jpeg',
  'TVFBlack.jpeg',
  'Toaster.png',
  'Train.png',
  'Trees.jpeg',
  'Ubuntu.jpeg',
  'VSCode.jpeg',
  'Watermelon.png',
  'X.jpeg',
];

class ArtPage extends StatefulWidget {
  const ArtPage({super.key});

  @override
  State<ArtPage> createState() => _ArtPageState();
}

class _ArtPageState extends State<ArtPage> {
  late CardSwiperController _controller;
  late Timer _autoSwipeTimer;

  @override
  void initState() {
    super.initState();
    _controller = CardSwiperController();
    _startAutoSwipe();
  }

  void _startAutoSwipe() {
    _autoSwipeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        _controller.swipe(CardSwiperDirection.left);
      }
    });
  }

  @override
  void dispose() {
    _autoSwipeTimer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.notebookWhite,
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
      body: Stack(
        children: [
          const NotebookLayout(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Art w Flutter",
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
                const SizedBox(height: 10),
                Flexible(
                  child: CardSwiper(
                    controller: _controller,
                    numberOfCardsDisplayed: 1,
                    cardsCount: _artImageFiles.length,
                    padding: const EdgeInsets.only(bottom: 24),
                    cardBuilder: (context, index, data, data2) {
                      final imagePath = 'assets/Art/${_artImageFiles[index]}';
                      return Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(imagePath, fit: BoxFit.cover),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
