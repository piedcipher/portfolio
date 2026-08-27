import 'package:material_ui/material_ui.dart';
import 'package:tirth_today/utils/constants.dart';
import 'package:video_player/video_player.dart';

class AnimalsPage extends StatelessWidget {
  const AnimalsPage({super.key});

  static const List<String> _assetNames = [
    'Black-Panther-1.jpg',
    'Blr-White-1.jpg',
    'C-1.mp4',
    'Chansad-Red-1.jpg',
    'Chansad-Red-2.jpg',
    'Eight-1.jpg',
    'Furry-White-1.jpg',
    'Furry-White-2.jpg',
    'Furry-White-3.mp4',
    'Healthy-White-1.mp4',
    'Home-1.jpg',
    'Home-2.jpg',
    'Home-3.jpg',
    'Home-4.jpg',
    'Jodhpur-Red-1.jpg',
    'Jodhpur-Red-2.jpg',
    'Jodhpur-Red-3.mp4',
    'Nini-1.jpg',
    'Nini-2.jpg',
    'Nini-3.jpg',
    'Nini-4.jpg',
    'Nini-5.jpg',
    'Nini-6.jpg',
    'Ocd-1.jpg',
    'Ocd-2.jpg',
    'Ocd-3.jpg',
    'Ocd-4.jpg',
    'Ocd-5.jpg',
    'Sbr-1.jpg',
    'Sbr-2.jpg',
    'Sbr-3.jpg',
    'Supra-1.jpg',
    'Supra-2.jpg',
    'Supra-3.jpg',
    'Supra-4.jpg',
    'Tea-1.jpg',
    'Tea-2.jpg',
    'Vadu-1.jpg',
  ];

  static Map<String, List<String>> get _groupedAssets {
    final grouped = <String, List<String>>{};
    for (final assetName in _assetNames) {
      final groupName = assetName.replaceFirst(
        RegExp(r'-\d+\.(?:jpg|mp4)$'),
        '',
      );
      grouped.putIfAbsent(groupName, () => []).add(assetName);
    }
    return grouped;
  }

  static String _emojiForGroup(String groupName) {
    return groupName == 'Tea' || groupName == 'Eight' || groupName == 'C'
        ? '🐱'
        : '🐶';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.notebookWhite,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Animals',
                      style: TextStyle(
                        fontSize: 36,
                        color: AppColors.handwritingBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              for (final group in _groupedAssets.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _emojiForGroup(group.key),
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            group.key,
                            style: const TextStyle(
                              fontSize: 24,
                              color: AppColors.handwritingBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${group.value.length} photos',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.handwritingDarkBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: group.value.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 180,
                              mainAxisExtent: 190,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemBuilder: (context, index) {
                          final assetName = group.value[index];
                          return _AnimalMediaTile(assetName: assetName);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimalMediaTile extends StatefulWidget {
  const _AnimalMediaTile({required this.assetName});

  final String assetName;

  @override
  State<_AnimalMediaTile> createState() => _AnimalMediaTileState();
}

class _AnimalMediaTileState extends State<_AnimalMediaTile> {
  VideoPlayerController? _controller;

  bool get _isVideo => widget.assetName.toLowerCase().endsWith('.mp4');

  @override
  void initState() {
    super.initState();
    if (_isVideo) {
      final controller = VideoPlayerController.asset(
        'assets/animals_assets/${widget.assetName}',
      );
      _controller = controller;
      controller.initialize().then((_) {
        if (!mounted) return;
        controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: _buildMedia(controller),
    );
  }

  Widget _buildMedia(VideoPlayerController? controller) {
    if (!_isVideo || controller == null) {
      return Image.asset(
        'assets/animals_assets/${widget.assetName}',
        fit: BoxFit.cover,
      );
    }

    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        ),
        Positioned(
          right: 6,
          bottom: 6,
          child: IconButton(
            tooltip: controller.value.isPlaying ? 'Pause video' : 'Play video',
            color: Colors.white,
            style: IconButton.styleFrom(backgroundColor: Colors.black54),
            icon: Icon(
              controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            onPressed: () {
              setState(() {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
              });
            },
          ),
        ),
      ],
    );
  }
}
