import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tirth_today/pages/blog_post_page.dart';
import 'package:tirth_today/utils/constants.dart';

void main() {
  testWidgets('renders the post photos in a responsive gallery', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [AppPalette.light]),
        home: const BlogPostPage(slug: '20-blackout'),
      ),
    );
    await tester.pumpAndSettle();

    final gallery = find.byKey(const ValueKey('blog-photo-gallery'));
    expect(gallery, findsOneWidget);
    expect(tester.widget<Row>(gallery).children, hasLength(5));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            (widget.semanticLabel?.startsWith('Photo ') ?? false),
      ),
      findsNWidgets(23),
    );

    tester.view.physicalSize = const Size(320, 800);
    await tester.pumpAndSettle();
    expect(tester.widget<Row>(gallery).children, hasLength(1));
  });
}
