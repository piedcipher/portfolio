import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tirth_today/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class FlutterJobBoard extends StatefulWidget {
  const FlutterJobBoard({super.key});

  @override
  State<FlutterJobBoard> createState() => _FlutterJobBoardState();
}

class _FlutterJobBoardState extends State<FlutterJobBoard> {
  static final _jobBoardUri = Uri.parse(
    'https://piedcipher.notion.site/Flutter-Job-Board-3766addaed67807aa6e8dee0cb5fdb92',
  );
  bool _isOpening = false;

  Future<void> _openJobBoard() async {
    if (_isOpening) return;
    setState(() {
      _isOpening = true;
    });

    final opened = await launchUrl(
      _jobBoardUri,
      mode: LaunchMode.externalApplication,
      webOnlyWindowName: '_blank',
    );

    if (!mounted) return;
    setState(() {
      _isOpening = false;
    });

    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the job board link.')),
      );
    }
  }

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: _jobBoardUri.toString()));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job board link copied to clipboard.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.notebookWhite,
      appBar: AppBar(
        title: const Text('Flutter Job Board'),
        backgroundColor: AppColors.notebookWhite,
        foregroundColor: AppColors.handwritingBlue,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Curated Flutter opportunities',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.handwritingBlue,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'I maintain this Notion board with Flutter roles and relevant opportunities.',
                    ),
                    const SizedBox(height: 16),
                    SelectableText(
                      _jobBoardUri.toString(),
                      style: const TextStyle(color: AppColors.handwritingBlue),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        FilledButton.icon(
                          onPressed: _isOpening ? null : _openJobBoard,
                          icon: _isOpening
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.open_in_new),
                          label: Text(
                            _isOpening ? 'Opening...' : 'Open Job Board',
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _copyLink,
                          icon: const Icon(Icons.copy),
                          label: const Text('Copy Link'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
