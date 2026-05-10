import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nichesphere/main.dart';

void main() {
  testWidgets('NicheSphere app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const NicheSphereApp());
    // App should render the splash screen
    expect(find.text('NicheSphere'), findsOneWidget);
  });
}
