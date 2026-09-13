import 'package:material_ui/material_ui.dart';
import 'package:tirth_today/layouts/notebook_layout.dart';
import 'package:tirth_today/utils/constants.dart';

class RoughPage extends StatefulWidget {
  const RoughPage({super.key, this.onReturnToPreviousPage});

  final VoidCallback? onReturnToPreviousPage;

  @override
  State<RoughPage> createState() => _RoughPageState();
}

class _RoughPageState extends State<RoughPage> {
  final List<_Stroke> _strokes = [];
  final List<_Stroke> _redoStack = [];
  _Stroke? _activeStroke;
  _SketchTool _selectedTool = _SketchTool.pen;

  void _startStroke(PointerDownEvent event) {
    final stroke = _Stroke(
      color: _selectedTool == _SketchTool.eraser
          ? AppColors.notebookWhite
          : AppColors.handwritingBlue,
      width: switch (_selectedTool) {
        _SketchTool.pen => 4,
        _SketchTool.brush => 10,
        _SketchTool.eraser => 24,
      },
      points: [event.localPosition],
    );

    setState(() {
      _activeStroke = stroke;
      _redoStack.clear();
    });
  }

  void _extendStroke(PointerMoveEvent event) {
    final stroke = _activeStroke;
    if (stroke == null) {
      return;
    }

    setState(() => stroke.points.add(event.localPosition));
  }

  void _finishStroke([PointerEvent? _]) {
    final stroke = _activeStroke;
    if (stroke == null) {
      return;
    }

    setState(() {
      _strokes.add(stroke);
      _activeStroke = null;
    });
  }

  void _undo() {
    if (_strokes.isEmpty) {
      return;
    }

    setState(() => _redoStack.add(_strokes.removeLast()));
  }

  void _redo() {
    if (_redoStack.isEmpty) {
      return;
    }

    setState(() => _strokes.add(_redoStack.removeLast()));
  }

  void _clear() {
    if (_strokes.isEmpty && _activeStroke == null) {
      return;
    }

    setState(() {
      _strokes.clear();
      _redoStack.clear();
      _activeStroke = null;
    });
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
                      child: Listener(
                        behavior: HitTestBehavior.opaque,
                        onPointerDown: _startStroke,
                        onPointerMove: _extendStroke,
                        onPointerUp: _finishStroke,
                        onPointerCancel: _finishStroke,
                        child: CustomPaint(
                          painter: _SketchPainter(
                            strokes: [..._strokes, ?_activeStroke],
                          ),
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 74),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        tooltip: 'Undo',
                        onPressed: _strokes.isEmpty ? null : _undo,
                        icon: const Icon(Icons.undo),
                      ),
                      IconButton(
                        tooltip: 'Redo',
                        onPressed: _redoStack.isEmpty ? null : _redo,
                        icon: const Icon(Icons.redo),
                      ),
                      IconButton(
                        tooltip: 'Clear',
                        onPressed: _strokes.isEmpty ? null : _clear,
                        icon: const Icon(Icons.delete_outline),
                      ),
                      _ToolButton(
                        tool: _SketchTool.pen,
                        selectedTool: _selectedTool,
                        onSelected: (tool) =>
                            setState(() => _selectedTool = tool),
                      ),
                      _ToolButton(
                        tool: _SketchTool.brush,
                        selectedTool: _selectedTool,
                        onSelected: (tool) =>
                            setState(() => _selectedTool = tool),
                      ),
                      _ToolButton(
                        tool: _SketchTool.eraser,
                        selectedTool: _selectedTool,
                        onSelected: (tool) =>
                            setState(() => _selectedTool = tool),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 60,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! > 0) {
                  widget.onReturnToPreviousPage?.call();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum _SketchTool { pen, brush, eraser }

class _Stroke {
  _Stroke({required this.color, required this.width, required this.points});

  final Color color;
  final double width;
  final List<Offset> points;
}

class _SketchPainter extends CustomPainter {
  const _SketchPainter({required this.strokes});

  final List<_Stroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) {
        continue;
      }

      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      final path = Path()
        ..moveTo(stroke.points.first.dx, stroke.points.first.dy);

      for (final point in stroke.points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }

      if (stroke.points.length == 1) {
        canvas.drawCircle(
          stroke.points.first,
          stroke.width / 2,
          paint..style = PaintingStyle.fill,
        );
      } else {
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SketchPainter oldDelegate) => true;
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.tool,
    required this.selectedTool,
    required this.onSelected,
  });

  final _SketchTool tool;
  final _SketchTool selectedTool;
  final ValueChanged<_SketchTool> onSelected;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, String tooltip) = switch (tool) {
      _SketchTool.pen => (Icons.edit, 'Pen'),
      _SketchTool.brush => (Icons.brush, 'Brush'),
      _SketchTool.eraser => (Icons.cleaning_services, 'Eraser'),
    };

    return IconButton(
      tooltip: tooltip,
      isSelected: tool == selectedTool,
      onPressed: () => onSelected(tool),
      icon: Icon(icon),
      selectedIcon: Icon(icon),
    );
  }
}
