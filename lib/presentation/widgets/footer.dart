import 'dart:async';
import 'package:about/core/constants/assets.dart';
import 'package:about/core/constants/info.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  bool _showWhy = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _showWhy = !_showWhy;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Divider(color: context.colors.borderLight),
          const SizedBox(height: 60),
          Image.asset(Assets.logo192, height: 32, fit: BoxFit.contain),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    '© ${AppInfo.copyrightYear} ${AppInfo.fullName}',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: context.colors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '•',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: context.colors.border,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _showWhyFlutterDialog(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 600),
                              switchInCurve: Curves.easeOutBack,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, animation) {
                                return SizeTransition(
                                  axis: Axis.horizontal,
                                  sizeFactor: animation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: _showWhy
                                  ? Text(
                                      'Why ',
                                      key: const ValueKey('why'),
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: context.colors.textTertiary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : const SizedBox.shrink(key: ValueKey('none1')),
                            ),
                            Text(
                              'Built with Flutter',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: context.colors.textTertiary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 600),
                              switchInCurve: Curves.easeOutBack,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, animation) {
                                return SizeTransition(
                                  axis: Axis.horizontal,
                                  sizeFactor: animation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: _showWhy
                                  ? Text(
                                      '?',
                                      key: const ValueKey('qm'),
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: context.colors.textTertiary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : const SizedBox.shrink(key: ValueKey('none2')),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (AppInfo.showGithub)
                SizedBox(
                  width: 100,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _footerLink('GitHub', AppInfo.githubUrl, context),
                  ),
                ),
              if (AppInfo.showGithub && (AppInfo.showLinkedIn || AppInfo.showTwitter))
                _divider(context),
              if (AppInfo.showLinkedIn)
                SizedBox(
                  width: AppInfo.showTwitter ? null : 100,
                  child: Align(
                    alignment: AppInfo.showTwitter ? Alignment.center : Alignment.centerLeft,
                    child: _footerLink('LinkedIn', AppInfo.linkedinUrl, context),
                  ),
                ),
              if (AppInfo.showLinkedIn && AppInfo.showTwitter)
                _divider(context),
              if (AppInfo.showTwitter)
                SizedBox(
                  width: 100,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _footerLink('Twitter', AppInfo.twitterUrl, context),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String title, String url, BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: context.colors.border,
        shape: BoxShape.circle,
      ),
    );
  }

  void _showWhyFlutterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Built With Flutter',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "This portfolio is built with Flutter Web - not because it's the easiest choice, but because it's the best way to learn.\n\n"
                  "I wanted hands-on experience with Flutter's web target beyond just reading docs. This page gave me a sandbox to experiment. I learned how responsive design works across desktop browsers, why some animations stutter on web but not mobile, and how to optimize bundle size when you can't just tell users to \"download the app.\"\n\n"
                  "Building this forced me to deal with:\n"
                  "• Responsive design across desktop breakpoints\n"
                  "• Browser-specific rendering differences\n"
                  "• Bundle size optimization for web\n"
                  "• Routing and deep linking in a web context\n"
                  "• Performance differences between mobile and browser runtimes\n\n"
                  "It's also proof that I don't just build for Android and iOS. If I'm claiming cross-platform expertise, this page is evidence I've shipped Flutter on the web, not just talked about it.\n\n"
                  "Could I have built this faster with HTML? Absolutely. But I wouldn't have learned nearly as much.",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    height: 1.6,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
