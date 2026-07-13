import 'package:flutter/material.dart';
import 'package:tirth_today/data/github_blog_repository.dart';
import 'package:tirth_today/models/blog_post.dart';
import 'package:tirth_today/utils/constants.dart';

class BlogListPage extends StatelessWidget {
  const BlogListPage({super.key, this.initialTag});

  static const _repository = GitHubBlogRepository();
  final String? initialTag;

  @override
  Widget build(BuildContext context) {
    final selectedTag = _normalizeTag(initialTag);

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
                      'Blog',
                      style: TextStyle(
                        fontSize: 36,
                        color: AppColors.handwritingBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (selectedTag != null) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Filtering by:',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.handwritingDarkBlue,
                      ),
                    ),
                    Chip(
                      label: Text(selectedTag),
                      backgroundColor: Colors.white.withAlpha(230),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).popUntil(ModalRoute.withName('/blog')),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              FutureBuilder<List<BlogPost>>(
                future: _repository.fetchPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return const _BlogListError();
                  }

                  final posts = snapshot.data ?? const <BlogPost>[];
                  final visiblePosts = selectedTag == null
                      ? posts
                      : posts
                            .where(
                              (post) => post.tags.any(
                                (tag) =>
                                    _normalizeTag(tag) ==
                                    _normalizeTag(selectedTag),
                              ),
                            )
                            .toList();

                  if (visiblePosts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'No posts found for this tag.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      for (final post in visiblePosts) _BlogCard(post: post),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? _normalizeTag(String? tag) {
  if (tag == null) {
    return null;
  }

  const maxTagLength = 64;
  final normalized = tag
      .replaceAll(RegExp(r'[^a-zA-Z0-9 _\-]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  if (normalized.isEmpty) {
    return null;
  }

  return normalized
      .substring(0, normalized.length.clamp(0, maxTagLength))
      .toLowerCase();
}

class _BlogListError extends StatelessWidget {
  const _BlogListError();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Could not load posts from local assets.',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.handwritingDarkBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Check BlogConfig.directory and confirm markdown files exist in assets/blogs/.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class _BlogCard extends StatelessWidget {
  const _BlogCard({required this.post});

  final BlogPost post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Colors.white.withAlpha(230),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          post.title,
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.handwritingBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${_formatDate(post.publishedOn)}  •  ${post.readTimeMinutes} min read',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.handwritingDarkBlue,
          ),
        ),
        isThreeLine: post.tags.isNotEmpty,
        titleAlignment: ListTileTitleAlignment.top,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).pushNamed('/blog/${post.slug}'),
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
