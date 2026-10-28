import 'package:material_ui/material_ui.dart';
import 'package:tirth_today/pages/art_video_player_page.dart'
    deferred as art_video_player;

class DeferredArtVideoPlayer extends StatefulWidget {
  const DeferredArtVideoPlayer({super.key, this.startImmediately = false});

  final bool startImmediately;

  @override
  State<DeferredArtVideoPlayer> createState() => _DeferredArtVideoPlayerState();
}

class _DeferredArtVideoPlayerState extends State<DeferredArtVideoPlayer> {
  Future<void>? _loadLibrary;

  @override
  void initState() {
    super.initState();
    if (widget.startImmediately) {
      _loadLibrary = art_video_player.loadLibrary();
    }
  }

  void _startLoading() {
    setState(() {
      _loadLibrary = art_video_player.loadLibrary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loadLibrary = _loadLibrary;
    if (loadLibrary == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: FilledButton(
            onPressed: _startLoading,
            child: const Text('Play art video'),
          ),
        ),
      );
    }

    return FutureBuilder<void>(
      future: loadLibrary,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'The art video could not be loaded.',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _startLoading,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return art_video_player.ArtVideoPlayer();
      },
    );
  }
}
