import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tirth_today/data/github_blog_repository.dart';
import 'package:tirth_today/models/blog_post.dart';
import 'package:tirth_today/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    return _BlogPostBody(post: post);
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
  const _BlogPostBody({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
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
                Chip(
                  label: Text(tag),
                  backgroundColor: Colors.white.withAlpha(230),
                ),
            ],
          ),
        ],
        const SizedBox(height: 10),
        MarkdownBody(
          data: post.markdown,
          onTapLink: (text, href, title) async {
            if (href == null || href.isEmpty) {
              return;
            }

            final uri = Uri.tryParse(href);
            if (uri != null) {
              await launchUrl(uri);
            }
          },
        ),
      ],
    );
  }
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
