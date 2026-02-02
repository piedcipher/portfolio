import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:page_curl_effect/page_curl_effect.dart';
import 'package:tirth_today/pages/art_video_player_page.dart';
import 'package:tirth_today/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NotebookLayout extends StatelessWidget {
  const NotebookLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                      decoration: BoxDecoration(color: AppColors.notebookBlack),
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
            const SizedBox(height: 30),
            if (GetIt.I.get<PageCurlController>().pageCurlIndex == 0)
              OverflowBar(
                spacing: 16,
                overflowSpacing: 16,
                children: [
                  FilledButton(
                    onPressed: () async {
                      launchUrl(
                        Uri.parse(
                          'https://github.com/piedcipher/tirth.today/blob/main/assets/Tirth-Patel-Resume.pdf',
                        ),
                      );
                    },
                    child: Text('View Resume'),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ArtVideoPlayer(),
                        ),
                      );
                    },
                    child: Text('View Art'),
                  ),
                ],
              ),
            const SizedBox(height: 30),
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
            const SizedBox(height: 30),
            if (GetIt.I.get<PageCurlController>().pageCurlIndex == 0)
              OverflowBar(
                spacing: 16,
                overflowSpacing: 16,
                children: [
                  FilledButton(
                    onPressed: () {
                      GetIt.I<PageCurlController>().pageCurlIndex =
                          GetIt.I<PageCurlController>().getNextPageIndex() ?? 0;
                      GetIt.I<VoidCallback>()();
                    },
                    child: Text('Flip Page'),
                  ),
                ],
              ),
            const SizedBox(height: 30),
          ],
        ),
      ],
    );
  }
}
