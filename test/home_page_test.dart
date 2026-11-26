import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tirth_today/pages/home_page.dart';
import 'package:tirth_today/utils/constants.dart';

void main() {
  group('HomePage Widget Tests', () {
    testWidgets('renders HomePage with correct title and tagline', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          darkTheme: ThemeData(extensions: const [AppPalette.dark]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      expect(find.text(Data.name), findsOneWidget);
      expect(find.text(Data.tagline), findsOneWidget);
    });

    testWidgets('theme toggle button changes theme', (
      WidgetTester tester,
    ) async {
      bool themeToggled = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          darkTheme: ThemeData(extensions: const [AppPalette.dark]),
          home: HomePage(
            onToggleTheme: () {
              themeToggled = true;
            },
          ),
        ),
      );

      // On desktop, find the Dark theme button
      final themeButton = find.byIcon(Icons.dark_mode_outlined);
      expect(themeButton, findsOneWidget);

      await tester.tap(themeButton);
      expect(themeToggled, isTrue);
    });

    testWidgets('renders blog navigation button on desktop', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      expect(find.text('Blog'), findsOneWidget);
    });

    testWidgets('renders job board button on desktop', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      expect(find.text('Job Board'), findsOneWidget);
    });

    testWidgets('renders animals button on desktop', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      expect(find.text('Animals'), findsOneWidget);
    });

    testWidgets('renders contact me button on desktop', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      expect(find.text('Contact Me'), findsOneWidget);
    });

    testWidgets('shows hamburger menu on mobile', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
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
    });

    testWidgets('drawer opens on mobile menu tap', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      expect(find.byType(Drawer), findsNothing);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('drawer contains navigation items on mobile', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
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

      expect(find.text('Blog'), findsOneWidget);
      expect(find.text('Job Board'), findsOneWidget);
      expect(find.text('Animals'), findsOneWidget);
      expect(find.text('Contact Me'), findsOneWidget);
    });

    testWidgets('drawer header shows name and tagline', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
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

      expect(find.text(Data.name), findsWidgets);
      expect(find.text(Data.tagline), findsWidgets);
    });

    testWidgets('theme toggle accessible on mobile', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool themeToggled = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(
            onToggleTheme: () {
              themeToggled = true;
            },
          ),
        ),
      );

      final themeButton = find.byIcon(Icons.dark_mode_outlined);
      expect(themeButton, findsOneWidget);

      await tester.tap(themeButton);
      expect(themeToggled, isTrue);
    });

    testWidgets('social media buttons render', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      final iconButtons = find.byType(IconButton);
      expect(iconButtons, findsWidgets);
    });

    testWidgets('responsive layout changes at breakpoint', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      expect(find.byIcon(Icons.menu), findsNothing);

      tester.view.physicalSize = const Size(300, 800);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });
  });
}
