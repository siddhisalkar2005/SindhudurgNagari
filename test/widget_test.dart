import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Flutter test works', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('SindhudurgNagri'),
          ),
        ),
      ),
    );

    expect(
      find.text('SindhudurgNagri'),
      findsOneWidget,
    );
  });
}