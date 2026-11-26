import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tirth_today/pages/home_page.dart';
import 'package:tirth_today/utils/constants.dart';

void main() {
  group('Mobile Navigation Responsive Tests', () {
    testWidgets('Desktop layout shows all buttons horizontally', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      expect(find.text('Dark theme'), findsOneWidget);
      expect(find.text('Blog'), findsOneWidget);
      expect(find.text('Job Board'), findsOneWidget);
      expect(find.text('Flutter Interview Questions'), findsOneWidget);
      expect(find.text('Animals'), findsOneWidget);
      expect(find.text('Contact Me'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsNothing);
    });

    testWidgets('Mobile layout shows hamburger menu', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.text('Flutter Interview Questions'), findsNothing);
    });

    testWidgets('Mobile drawer navigation works correctly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);
      expect(find.text('Blog'), findsOneWidget);
      expect(find.text('Job Board'), findsOneWidget);
      expect(find.text('Flutter Interview Questions'), findsOneWidget);
      expect(find.text('Animals'), findsOneWidget);
      expect(find.text('Contact Me'), findsOneWidget);
    });

    testWidgets('Mobile drawer header displays correctly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(DrawerHeader), findsOneWidget);
      expect(find.text(Data.name), findsWidgets);
      expect(find.text(Data.tagline), findsWidgets);
    });

    testWidgets('Theme toggle on mobile top-right', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool toggled = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(
            onToggleTheme: () {
              toggled = true;
            },
          ),
        ),
      );

      final themeIcon = find.byIcon(Icons.dark_mode_outlined);
      expect(themeIcon, findsOneWidget);

      await tester.tap(themeIcon);
      expect(toggled, isTrue);
    });

    testWidgets('Drawer closes after navigation', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          routes: {
            '/blog': (_) => Scaffold(body: Center(child: Text('Blog Page'))),
          },
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);

      await tester.tap(find.text('Blog'));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsNothing);
    });

    testWidgets('Small mobile device (320px) works', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
    });

    testWidgets('Tablet size (768px) shows desktop layout', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      expect(find.text('Flutter Interview Questions'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsNothing);
    });

    testWidgets('Drawer respects dark theme', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          darkTheme: ThemeData(extensions: const [AppPalette.dark]),
          themeMode: ThemeMode.dark,
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      await tester.tap(find.byIcon(Icons.light_mode_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);
    });
  });
}
