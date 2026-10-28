import 'package:material_ui/material_ui.dart';

class DeferredPage extends StatefulWidget {
  const DeferredPage({
    super.key,
    required this.loadLibrary,
    required this.builder,
  });

  final Future<void> Function() loadLibrary;
  final WidgetBuilder builder;

  @override
  State<DeferredPage> createState() => _DeferredPageState();
}

class _DeferredPageState extends State<DeferredPage> {
  late final Future<void> _loadLibrary;

  @override
  void initState() {
    super.initState();
    _loadLibrary = widget.loadLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadLibrary,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('This page could not be loaded: ${snapshot.error}'),
              ),
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return widget.builder(context);
      },
    );
  }
}
