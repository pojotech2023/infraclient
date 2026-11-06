import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:builder_customer/feature/dashboard/presentation/widgets/app_drawer.dart';

void main() {
  testWidgets('Test AppDrawer tab taps', (WidgetTester tester) async {
    int selectedTab = -1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          drawer: AppDrawer(
            onSelectTab: (index) {
              selectedTab = index;
            },
          ),
          body: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Scaffold.of(ctx).openDrawer(),
              child: const Text('Open Drawer'),
            ),
          ),
        ),
      ),
    );

    // Open drawer
    await tester.tap(find.text('Open Drawer'));
    await tester.pumpAndSettle();

    // Drawer should show all items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Drawings'), findsOneWidget);
    expect(find.text('Tickets'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('View Payments'), findsOneWidget);

    // Tap Drawings
    await tester.tap(find.text('Drawings'));
    await tester.pumpAndSettle();

    print('Selected tab after Drawings tap: $selectedTab');
    expect(selectedTab, 1);
  });
}
