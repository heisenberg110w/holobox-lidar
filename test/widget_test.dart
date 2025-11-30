import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Import your actual app files
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/features/home/providers/home_provider.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HomeProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that our app starts properly
    expect(find.text('Delivery address'), findsOneWidget);
    expect(find.text('92 High Street, London'), findsOneWidget);

    // You can add more specific tests here
  });

  testWidgets('Home screen loads categories', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HomeProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Wait for the provider to load data
    await tester.pump(const Duration(seconds: 1));

    // Check if categories section exists
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Flash Sale'), findsOneWidget);
  });

  testWidgets('Recently viewed button exists', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HomeProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Check if recently viewed button exists
    expect(find.text('Recently Viewed Items'), findsOneWidget);
  });
}
