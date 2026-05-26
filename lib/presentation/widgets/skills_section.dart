import 'package:about/core/dimensions.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = Responsive.screenWidth(context);
    final isMobile = Responsive.isMobile(context);

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: Dimensions.maxWidth),
        padding: EdgeInsets.symmetric(
            horizontal: isMobile ? width * 0.05 : Dimensions.spaceXXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skills',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'What I build with, and why it matters.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
            const SizedBox(height: 40),

            // Shipping Cross-Platform Apps
            _skillCategory(
                    'Shipping Cross-Platform Apps',
                    [
                      'Flutter',
                      'Dart',
                      'Clean Architecture',
                      'MVVM',
                      'GoRouter',
                      'GetIt',
                    ],
                    context)
                .animate()
                .fadeIn(duration: 600.ms, delay: 100.ms)
                .slideX(begin: -0.1),
            const SizedBox(height: 24),

            // Managing State
            _skillCategory(
                    'Managing State (Without Breaking Things)',
                    [
                      'RxDart (BehaviorSubject)',
                      'BLoC (flutter_bloc)',
                      'Redux',
                      'GetX',
                    ],
                    context)
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slideX(begin: -0.1),
            const SizedBox(height: 24),

            // Storing Data
            _skillCategory(
                    'Storing Data (Offline-First, Synced Later)',
                    [
                      'Hive',
                      'SharedPreferences',
                      'SQLite',
                      'Firebase Firestore',
                      'Firebase Realtime Database',
                    ],
                    context)
                .animate()
                .fadeIn(duration: 600.ms, delay: 300.ms)
                .slideX(begin: -0.1),
            const SizedBox(height: 24),

            // Backend & Real-Time Updates
            _skillCategory(
                    'Backend & Real-Time Updates',
                    [
                      'Firebase (Auth, Storage, Crashlytics, FCM)',
                      'REST API (Dio/HTTP)',
                      'WebSocket',
                    ],
                    context)
                .animate()
                .fadeIn(duration: 600.ms, delay: 400.ms)
                .slideX(begin: -0.1),
            const SizedBox(height: 24),

            // Platform-Native Features
            _skillCategory(
                    'Platform-Native Features',
                    [
                      'Platform Channels',
                      'RemoteView (Android)',
                      'LiveActivity (iOS)',
                      'Deep Linking',
                    ],
                    context)
                .animate()
                .fadeIn(duration: 600.ms, delay: 500.ms)
                .slideX(begin: -0.1),
            const SizedBox(height: 24),

            // Third-Party Integrations
            _skillCategory(
                    'Third-Party Integrations',
                    [
                      'Google Maps',
                      'Payment Gateways',
                      'Social Logins',
                      'Intercom',
                      'Face Detection',
                      'Audio/Video Player',
                    ],
                    context)
                .animate()
                .fadeIn(duration: 600.ms, delay: 600.ms)
                .slideX(begin: -0.1),
            const SizedBox(height: 24),

            // Deployment
            _skillCategory(
                    'Deployment (The Part Most Devs Avoid)',
                    [
                      'Play Store',
                      'App Store',
                      'TestFlight',
                      'App Signing',
                      'Provisioning Profiles',
                    ],
                    context)
                .animate()
                .fadeIn(duration: 600.ms, delay: 700.ms)
                .slideX(begin: -0.1),
            const SizedBox(height: 24),

            // Tools I Use Daily
            _skillCategory(
                    'Tools I Use Daily',
                    [
                      'Git/GitHub',
                      'Android Studio',
                      'Xcode',
                      'VS Code',
                      'Postman',
                      'Figma',
                      'Flutter DevTools',
                    ],
                    context)
                .animate()
                .fadeIn(duration: 600.ms, delay: 800.ms)
                .slideX(begin: -0.1),
          ],
        ),
      ),
    );
  }

  Widget _skillCategory(
    String title,
    List<String> skills,
    BuildContext context,
  ) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: isMobile ? 10 : 11,
            fontWeight: FontWeight.bold,
            color: context.colors.textTertiary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: skills
              .map(
                (s) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: isMobile ? 8 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.fieldBackground,
                    border: Border.all(color: context.colors.border),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      fontWeight: FontWeight.w500,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
