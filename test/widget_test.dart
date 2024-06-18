import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodryp/screens/mainScreen/main_screen.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/desktopMiddleSide.dart';
import 'package:foodryp/widgets/desktopLeftSide/desktopLeftSide.dart';
import 'package:foodryp/widgets/desktopRightSide/desktopRightSide.dart';

void main() {
  testWidgets('Widget interaction test', (WidgetTester tester) async {
    // Build your app and trigger a frame with MaterialApp.
    await tester.pumpWidget(const MaterialApp(
      home: MainScreen(),
    ));

    // Example: Verify elements rendered by child widgets like DesktopLeftSide, DesktopMiddleSide, DesktopRightSide
    expect(find.byType(DesktopLeftSide), findsOneWidget);
    expect(find.byType(DesktopMiddleSide), findsOneWidget);
    expect(find.byType(DesktopRightSide), findsOneWidget);

    // Example: Verify layout constraints or other specific elements
    // expect(find.byKey(Key('specific_key')), findsOneWidget);

    // Example: Test interactions (uncomment and modify as needed)
    // await tester.tap(find.byKey(Key('some_button')));
    // await tester.pump();

    // Example: Verify updated state or screen changes after interaction
    // expect(find.text('Updated Text'), findsOneWidget);
  });
}
