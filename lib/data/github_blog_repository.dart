import 'dart:convert';

import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:tirth_today/models/blog_post.dart';
import 'package:tirth_today/utils/constants.dart';

class GitHubBlogRepository {
  const GitHubBlogRepository();

  Future<List<BlogPost>> fetchPosts() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final markdownAssets =
        manifest
            .listAssets()
            .where(
              (path) =>
                  path.startsWith('${BlogConfig.directory}/') &&
                  path.toLowerCase().endsWith('.md'),
            )
            .toList()
          ..sort((a, b) => b.compareTo(a));

    final posts = <BlogPost>[];
    for (final assetPath in markdownAssets) {
      final name = assetPath.split('/').last;
      final slug = _slugFromFileName(name);
      final markdown = await rootBundle.loadString(assetPath);
      posts.add(_parseMarkdown(slug, markdown, assetPath));
    }

    return posts;
  }

  Future<BlogPost?> fetchPostBySlug(String slug) async {
    final assetPath = '${BlogConfig.directory}/$slug.md';
    try {
      final markdown = await rootBundle.loadString(assetPath);
      return _parseMarkdown(slug, markdown, assetPath);
    } catch (_) {
      return null;
    }
  }

  BlogPost _parseMarkdown(String slug, String markdown, String sourceUrl) {
    final lines = const LineSplitter().convert(markdown);
    final frontMatter = _extractFrontMatter(lines);
    final content = _stripFrontMatter(markdown);

    final title =
        _stringValue(frontMatter, 'title') ?? _extractTitle(lines) ?? slug;
    final dateString = _stringValue(frontMatter, 'date');
    final parsedDate = dateString != null
        ? DateTime.tryParse(dateString)
        : null;
    final readTime =
        int.tryParse(_stringValue(frontMatter, 'read_time') ?? '') ??
        _estimateReadTimeMinutes(content);

    return BlogPost(
      slug: slug,
      title: title,
      publishedOn: parsedDate ?? DateTime.now(),
      readTimeMinutes: readTime,
      tags: _parseTags(frontMatter['tags']),
      markdown: content,
      sourceUrl: sourceUrl,
    );
  }

  String _slugFromFileName(String name) {
    final dotIndex = name.lastIndexOf('.');
    return dotIndex == -1 ? name : name.substring(0, dotIndex);
  }

  Map<String, dynamic> _extractFrontMatter(List<String> lines) {
    if (lines.isEmpty || lines.first.trim() != '---') {
      return {};
    }

    final frontMatter = <String, dynamic>{};
    for (var i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line == '---') {
        break;
      }
      if (!line.contains(':')) {
        continue;
      }

      final separator = line.indexOf(':');
      final key = line.substring(0, separator).trim();
      final value = line.substring(separator + 1).trim();
      frontMatter[key] = value;
    }

    return frontMatter;
  }

  String _stripFrontMatter(String markdown) {
    if (!markdown.startsWith('---\n')) {
      return markdown;
    }

    final endFrontMatter = markdown.indexOf('\n---\n', 4);
    if (endFrontMatter == -1) {
      return markdown;
    }

    return markdown.substring(endFrontMatter + 5).trim();
  }

  String? _extractTitle(List<String> lines) {
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('# ')) {
        return trimmed.substring(2).trim();
      }
    }
    return null;
  }

  String? _stringValue(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value == null) {
      return null;
    }
    return value.toString().trim();
  }

  List<String> _parseTags(dynamic rawTags) {
    if (rawTags == null) {
      return const [];
    }

    final value = rawTags.toString().trim();
    if (value.isEmpty) {
      return const [];
    }

    var normalized = value;
    if (normalized.startsWith('[') && normalized.endsWith(']')) {
      normalized = normalized.substring(1, normalized.length - 1);
    }

    return normalized
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  int _estimateReadTimeMinutes(String markdown) {
    final plainText = markdown.replaceAll(RegExp(r'[#*_`>\-\[\]\(\)]'), ' ');
    final words = plainText
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;
    final minutes = (words / 220).ceil();
    return minutes <= 0 ? 1 : minutes;
  }
}
