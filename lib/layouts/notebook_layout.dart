import 'package:flutter/material.dart';
import 'package:tirth_today/utils/constants.dart';

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
      ],
    );
  }
}
