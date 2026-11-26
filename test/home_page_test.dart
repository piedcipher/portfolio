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

    testWidgets('social media buttons render', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: const [AppPalette.light]),
          home: HomePage(onToggleTheme: () {}),
        ),
      );

      final iconButtons = find.byType(IconButton);
      expect(iconButtons, findsWidgets);
    });
  });
}
