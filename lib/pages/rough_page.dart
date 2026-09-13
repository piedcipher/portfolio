import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tirth_today/layouts/notebook_layout.dart';
import 'package:tirth_today/utils/constants.dart';

class RoughPage extends StatefulWidget {
  const RoughPage({super.key});

  @override
  State<RoughPage> createState() => _RoughPageState();
}

class _RoughPageState extends State<RoughPage> {
  late final DrawingController _drawingController;

  @override
  void initState() {
    super.initState();
    _drawingController = DrawingController();
  }

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.notebookWhite,
      body: Stack(
        children: [
          const NotebookLayout(),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Rough",
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
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 74),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(160),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.handwritingBlue.withAlpha(70),
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: DrawingBoard(
                        controller: _drawingController,
                        background: const ColoredBox(
                          color: AppColors.notebookWhite,
                        ),
                        boardPanEnabled: false,
                        boardScaleEnabled: false,
                        enablePalmRejection: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 74),
                  child: DrawingBar(
                    controller: _drawingController,
                    style: const WrapToolsBarStyle(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                    ),
                    tools: [
                      DefaultActionItem.undo(),
                      DefaultActionItem.redo(),
                      DefaultActionItem.clear(),
                      DefaultToolItem.pen(),
                      DefaultToolItem.brush(),
                      DefaultToolItem.eraser(),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
