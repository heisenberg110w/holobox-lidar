import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:holobox/features/admin/screens/admin_login_screen.dart';

void main() {
  testWidgets('Login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.text('Holobox'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
