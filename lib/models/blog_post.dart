class BlogPost {
  const BlogPost({
    required this.slug,
    required this.title,
    required this.publishedOn,
    required this.readTimeMinutes,
    required this.tags,
    required this.markdown,
    required this.sourceUrl,
  });

  final String slug;
  final String title;
  final DateTime publishedOn;
  final int readTimeMinutes;
  final List<String> tags;
  final String markdown;
  final String sourceUrl;
}
