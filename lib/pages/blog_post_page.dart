import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tirth_today/data/github_blog_repository.dart';
import 'package:tirth_today/models/blog_post.dart';
import 'package:tirth_today/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class BlogPostPage extends StatelessWidget {
  const BlogPostPage({super.key, required this.slug});

  final String slug;

  static const _repository = GitHubBlogRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.notebookWhite,
      body: SafeArea(
        child: SelectionArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Back to blog',
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pushReplacementNamed('/blog');
                        }
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Blog Post',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.handwritingBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FutureBuilder<BlogPost?>(
                  future: _repository.fetchPostBySlug(slug),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError || snapshot.data == null) {
                      return const _BlogPostNotFound();
                    }

                    final post = snapshot.data!;
                    return _BlogPostBody(
                      post: post,
                      onTagTap: (tag) {
                        final encodedTag = Uri.encodeQueryComponent(tag);
                        Navigator.of(
                          context,
                        ).pushReplacementNamed('/blog?tag=$encodedTag');
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BlogPostBody extends StatelessWidget {
  const _BlogPostBody({required this.post, required this.onTagTap});

  final BlogPost post;
  final ValueChanged<String> onTagTap;

  @override
  Widget build(BuildContext context) {
    final contentBlocks = _splitContentBlocks(post.markdown);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_formatDate(post.publishedOn)}  •  ${post.readTimeMinutes} min read',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.handwritingDarkBlue,
          ),
        ),
        if (post.tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in post.tags)
                ActionChip(
                  label: Text(tag),
                  backgroundColor: Colors.white.withAlpha(230),
                  onPressed: () => onTagTap(tag),
                ),
            ],
          ),
        ],
        const SizedBox(height: 10),
        ..._buildContentWidgets(contentBlocks),
      ],
    );
  }
}

List<Widget> _buildContentWidgets(List<_BlogContentBlock> contentBlocks) {
  final widgets = <Widget>[];

  void addGap() {
    if (widgets.isNotEmpty) {
      widgets.add(const SizedBox(height: 20));
    }
  }

  for (var index = 0; index < contentBlocks.length; index++) {
    final block = contentBlocks[index];

    if (block.detailsTitle != null) {
      final nestedBlocks = <_BlogContentBlock>[];
      var nextIndex = index + 1;
      while (nextIndex < contentBlocks.length &&
          !contentBlocks[nextIndex].isDetailsEnd) {
        nestedBlocks.add(contentBlocks[nextIndex]);
        nextIndex++;
      }

      addGap();
      widgets.add(
        _CollapsibleSection(
          title: block.detailsTitle!,
          children: _buildContentWidgets(nestedBlocks),
        ),
      );

      if (nextIndex < contentBlocks.length &&
          contentBlocks[nextIndex].isDetailsEnd) {
        index = nextIndex;
      }
      continue;
    }

    if (block.isDetailsEnd) {
      continue;
    }

    addGap();
    widgets.add(
      block.isYoutube
          ? _YoutubeEmbed(videoId: block.videoId!)
          : _BlogMarkdown(markdown: block.markdown!),
    );
  }

  return widgets;
}

class _BlogMarkdown extends StatelessWidget {
  const _BlogMarkdown({required this.markdown});

  final String markdown;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: markdown,
      imageDirectory: 'assets',
      sizedImageBuilder: (config) {
        final uri = config.uri;
        final scheme = uri.scheme.toLowerCase();
        final isRemote = scheme == 'https' || scheme == 'http';

        if (isRemote) {
          return Image.network(
            uri.toString(),
            width: config.width,
            height: config.height,
            fit: BoxFit.contain,
            webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
          );
        }

        return Image.asset(
          uri.toString(),
          width: config.width,
          height: config.height,
          fit: BoxFit.contain,
        );
      },
      onTapLink: (text, href, title) async {
        if (href == null || href.isEmpty) {
          return;
        }

        final uri = Uri.tryParse(href);
        final scheme = uri?.scheme.toLowerCase();
        final isAllowedScheme = scheme == 'https' || scheme == 'http';
        if (uri != null && isAllowedScheme) {
          await launchUrl(uri);
        }
      },
    );
  }
}

class _YoutubeEmbed extends StatefulWidget {
  const _YoutubeEmbed({required this.videoId});

  final String videoId;

  @override
  State<_YoutubeEmbed> createState() => _YoutubeEmbedState();
}

class _YoutubeEmbedState extends State<_YoutubeEmbed> {
  YoutubePlayerController? _controller;
  bool _isInteracting = false;

  String get _thumbnailUrl =>
      'https://i.ytimg.com/vi/${widget.videoId}/hqdefault.jpg';

  void _activatePlayer() {
    _controller ??= YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );
    setState(() => _isInteracting = true);
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  void _onScrollEvent(PointerScrollEvent event) {
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable != null) {
      final position = scrollable.position;
      position.jumpTo(
        (position.pixels + event.scrollDelta.dy).clamp(
          position.minScrollExtent,
          position.maxScrollExtent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    final thumbnail = ClipRRect(
      borderRadius: borderRadius,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _thumbnailUrl,
              fit: BoxFit.cover,
              webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
              errorBuilder: (_, _, _) => const ColoredBox(color: Colors.black),
            ),
            ColoredBox(color: Colors.black.withAlpha(70)),
            const Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 64,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );

    final player = DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: _controller == null
            ? const AspectRatio(aspectRatio: 16 / 9, child: SizedBox.shrink())
            : YoutubePlayer(controller: _controller!, aspectRatio: 16 / 9),
      ),
    );

    if (!_isInteracting) {
      return GestureDetector(
        onTap: _activatePlayer,
        child: MouseRegion(cursor: SystemMouseCursors.click, child: thumbnail),
      );
    }

    return MouseRegion(
      onExit: (_) => setState(() => _isInteracting = false),
      child: Stack(
        children: [
          player,
          Positioned.fill(
            child: ClipRRect(
              borderRadius: borderRadius,
              child: PointerInterceptor(
                child: Listener(
                  onPointerSignal: (event) {
                    if (event is PointerScrollEvent) _onScrollEvent(event);
                  },
                  child: const ColoredBox(color: Colors.transparent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleSection extends StatelessWidget {
  const _CollapsibleSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withAlpha(230),
      margin: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: AppColors.handwritingBlue,
          collapsedIconColor: AppColors.handwritingBlue,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.handwritingBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: children,
        ),
      ),
    );
  }
}

class _BlogContentBlock {
  const _BlogContentBlock.markdown(this.markdown)
    : videoId = null,
      isYoutube = false,
      detailsTitle = null,
      isDetailsEnd = false;

  const _BlogContentBlock.youtube(this.videoId)
    : markdown = null,
      isYoutube = true,
      detailsTitle = null,
      isDetailsEnd = false;

  const _BlogContentBlock.detailsStart(this.detailsTitle)
    : markdown = null,
      videoId = null,
      isYoutube = false,
      isDetailsEnd = false;

  const _BlogContentBlock.detailsEnd()
    : markdown = null,
      videoId = null,
      isYoutube = false,
      detailsTitle = null,
      isDetailsEnd = true;

  final String? markdown;
  final String? videoId;
  final bool isYoutube;
  final String? detailsTitle;
  final bool isDetailsEnd;
}

List<_BlogContentBlock> _splitContentBlocks(String markdown) {
  final lines = markdown.split('\n');
  final blocks = <_BlogContentBlock>[];
  final buffer = <String>[];
  var awaitingDetailsSummary = false;

  void flushMarkdown() {
    final chunk = buffer.join('\n').trim();
    if (chunk.isNotEmpty) {
      blocks.add(_BlogContentBlock.markdown(chunk));
    }
    buffer.clear();
  }

  for (final line in lines) {
    final trimmedLine = line.trim();

    if (_isDetailsOpen(trimmedLine)) {
      flushMarkdown();
      awaitingDetailsSummary = true;
      continue;
    }

    final detailsSummary = _extractDetailsSummary(trimmedLine);
    if (detailsSummary != null) {
      flushMarkdown();
      blocks.add(_BlogContentBlock.detailsStart(detailsSummary));
      awaitingDetailsSummary = false;
      continue;
    }

    if (_isDetailsClose(trimmedLine)) {
      flushMarkdown();
      blocks.add(const _BlogContentBlock.detailsEnd());
      awaitingDetailsSummary = false;
      continue;
    }

    if (awaitingDetailsSummary && trimmedLine.isEmpty) {
      continue;
    }

    final videoId = _extractYoutubeVideoId(trimmedLine);
    if (videoId != null) {
      flushMarkdown();
      blocks.add(_BlogContentBlock.youtube(videoId));
      continue;
    }

    awaitingDetailsSummary = false;
    buffer.add(line);
  }

  flushMarkdown();
  return blocks;
}

String? _extractYoutubeVideoId(String line) {
  if (line.isEmpty) {
    return null;
  }

  final match = RegExp(r'^<?(https?://[^\s>]+)>?$').firstMatch(line);
  final url = match?.group(1);
  if (url == null) {
    return null;
  }

  final uri = Uri.tryParse(url);
  if (uri == null) {
    return null;
  }

  final host = uri.host.toLowerCase();
  if (host == 'youtu.be') {
    final segment = uri.pathSegments.isEmpty ? '' : uri.pathSegments.first;
    return segment.isEmpty ? null : segment;
  }

  if (host.endsWith('youtube.com') || host.endsWith('youtube-nocookie.com')) {
    final videoId = uri.queryParameters['v'];
    if (videoId != null && videoId.isNotEmpty) {
      return videoId;
    }

    if (uri.pathSegments.length >= 2 &&
        (uri.pathSegments.first == 'embed' ||
            uri.pathSegments.first == 'shorts')) {
      return uri.pathSegments[1];
    }
  }

  return null;
}

bool _isDetailsOpen(String line) => line.toLowerCase() == '<details>';

bool _isDetailsClose(String line) => line.toLowerCase() == '</details>';

String? _extractDetailsSummary(String line) {
  final match = RegExp(
    r'^<summary>(.+)</summary>$',
    caseSensitive: false,
  ).firstMatch(line);
  final title = match?.group(1)?.trim();
  if (title == null || title.isEmpty) {
    return null;
  }

  return title;
}

class _BlogPostNotFound extends StatelessWidget {
  const _BlogPostNotFound();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 16),
      child: Text(
        'This post could not be loaded from local assets.',
        style: TextStyle(
          fontSize: 16,
          color: AppColors.handwritingDarkBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
}
