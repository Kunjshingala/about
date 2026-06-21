import 'package:about/core/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Responsive', () {
    testWidgets('isMobile returns true for width < 600',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(599, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          expect(Responsive.isMobile(context), isTrue);
          expect(Responsive.isTablet(context), isFalse);
          expect(Responsive.isDesktop(context), isFalse);
          return const SizedBox();
        }),
      ));
    });

    testWidgets('isTablet returns true for 600 <= width < 1024',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          expect(Responsive.isMobile(context), isFalse);
          expect(Responsive.isTablet(context), isTrue);
          expect(Responsive.isDesktop(context), isFalse);
          return const SizedBox();
        }),
      ));
    });

    testWidgets('isDesktop returns true for width >= 1024',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          expect(Responsive.isMobile(context), isFalse);
          expect(Responsive.isTablet(context), isFalse);
          expect(Responsive.isDesktop(context), isTrue);
          return const SizedBox();
        }),
      ));
    });

    testWidgets('scale returns appropriately scaled size',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(600, 800); // 0.5 factor
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          // 600 / 1200 = 0.5
          expect(Responsive.scale(context, 20), equals(10.0));
          return const SizedBox();
        }),
      ));
    });
  });
}
