import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projects/main.dart'; // Adjust the import according to your file structure

void main() {
  testWidgets('Calculator performs addition', (WidgetTester tester) async {
    await tester.pumpWidget(const CalculatorApp());

    // Simulate button presses
    await tester.tap(find.text('2')); // Tap '2'
    await tester.tap(find.text('+')); // Tap '+'
    await tester.tap(find.text('3')); // Tap '3'
    await tester.tap(find.text('=')); // Tap '='

    // Verify the result
    expect(find.text('5'), findsOneWidget); // Assuming your calculator displays the result as '5'
  });
}
