import 'package:about/core/constants/info.dart';
import 'package:about/core/enums/section.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/blocs/resume/resume_bloc.dart';
import 'package:about/presentation/widgets/mobile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MobileDrawer', () {
    testWidgets('renders personal information and navigation items', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [AppColors.light]),
        home: BlocProvider<ResumeBloc>(
          create: (_) => ResumeBloc(),
          child: Scaffold(
            drawer: MobileDrawer(onNavTap: (_) {}),
          ),
        ),
      ));

      // Open drawer
      tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();

      // Check personal info
      expect(find.text('${AppInfo.firstName.toUpperCase()} ${AppInfo.lastName.toUpperCase()}'), findsOneWidget);
      expect(find.text('© ${AppInfo.copyrightYear} ${AppInfo.fullName}'), findsOneWidget);

      // Check nav items
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);
      expect(find.text('Experience'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      if (AppInfo.showContact) {
        expect(find.text('Contact'), findsOneWidget);
      }
    });

    testWidgets('calls onNavTap when an item is tapped', (WidgetTester tester) async {
      Section? tappedItem;
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(extensions: [AppColors.light]),
        home: BlocProvider<ResumeBloc>(
          create: (_) => ResumeBloc(),
          child: Scaffold(
            drawer: MobileDrawer(onNavTap: (section) {
              tappedItem = section;
            }),
          ),
        ),
      ));

      // Open drawer
      tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
      await tester.pumpAndSettle();

      // Tap About
      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      expect(tappedItem, equals(Section.about));
    });
  });
}
