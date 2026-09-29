import 'package:about/core/constants/info.dart';
import 'package:about/core/dimensions.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/widgets/hover_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  // Max width for the bio column — keeps prose readable on wide desktops.
  static const double _bioMaxWidth = 640.0;

  @override
  Widget build(BuildContext context) {
    final width = Responsive.screenWidth(context);
    final isMobile = Responsive.isMobile(context);

    // Name is the single largest element on the page: fluid 56–96px.
    final nameSize = Dimensions.getResponsiveSize(
      width,
      factor: 0.085,
      min: 52,
      max: 96,
    );

    // Job title sits just below — smaller, medium weight.
    final titleSize = Dimensions.getResponsiveSize(
      width,
      factor: 0.022,
      min: 16,
      max: 22,
    );

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: Dimensions.maxWidth),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? width * 0.05 : Dimensions.spaceXXL,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top breathing room (navbar offset).
            SizedBox(
              height: Dimensions.getResponsiveSize(
                    width,
                    factor: 0.1,
                    min: 0,
                    max: 100,
                  ) +
                  80,
            ),

            // ── Full name — largest text on the page ──────────────────────
            Text(
              AppInfo.fullName,
              style: GoogleFonts.inter(
                fontSize: nameSize,
                fontWeight: FontWeight.w800,
                color: context.colors.textPrimary,
                height: 1.05,
                letterSpacing: -2.0,
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.15),

            const SizedBox(height: Dimensions.spaceM),

            // ── Job title — directly under name, smaller, medium weight ───
            Text(
              AppInfo.jobTitle,
              style: GoogleFonts.inter(
                fontSize: titleSize,
                fontWeight: FontWeight.w500,
                color: context.colors.textSecondary,
                letterSpacing: 0.1,
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 150.ms),

            const SizedBox(height: Dimensions.spaceXL),

            // ── Bio — capped at ~640px on desktop, full-width on mobile ───
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : _bioMaxWidth,
              ),
              child: Text(
                AppInfo.bio,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 14 : 16,
                  color: context.colors.textSecondary,
                  height: 1.75,
                ),
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 300.ms),

            const SizedBox(height: Dimensions.spaceXXL),

            // ── CTA buttons ───────────────────────────────────────────────
            const Wrap(
              spacing: Dimensions.spaceM,
              runSpacing: Dimensions.spaceS + 4, // ~12
              children: [
                _HoverCTAButton(
                  title: 'Download CV/Resume',
                  isPrimary: true,
                  url: AppInfo.resumeDownloadUrl,
                ),
                _HoverCTAButton(
                  title: 'View CV/Resume',
                  isPrimary: false,
                  url: AppInfo.resumeViewUrl,
                ),
              ],
            ).animate().fadeIn(duration: 800.ms, delay: 500.ms),

            const SizedBox(height: Dimensions.spaceXXL),

            // ── Social icons ──────────────────────────────────────────────
            const Wrap(
              spacing: Dimensions.spaceL,
              runSpacing: Dimensions.spaceM,
              children: [
                if (AppInfo.showGithub)
                  _HoverSocialIcon(
                    icon: FontAwesomeIcons.github,
                    url: AppInfo.githubUrl,
                  ),
                if (AppInfo.showLinkedIn)
                  _HoverSocialIcon(
                    icon: FontAwesomeIcons.linkedin,
                    url: AppInfo.linkedinUrl,
                  ),
                if (AppInfo.showTwitter)
                  _HoverSocialIcon(
                    icon: FontAwesomeIcons.xTwitter,
                    url: AppInfo.twitterUrl,
                  ),
                _HoverSocialIcon(
                  icon: FontAwesomeIcons.envelope,
                  url: AppInfo.emailAddress,
                ),
              ],
            ).animate().fadeIn(duration: 800.ms, delay: 700.ms),
          ],
        ),
      ),
    );
  }
}

// ─── CTA Button ───────────────────────────────────────────────────────────────

class _HoverCTAButton extends StatelessWidget {
  const _HoverCTAButton({
    required this.title,
    required this.isPrimary,
    required this.url,
  });

  final String title;
  final bool isPrimary;
  final String url;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return HoverWrapper(
      builder: (context, isHovered) {
        return Link(
          uri: Uri.parse(url),
          target: LinkTarget.blank,
          builder: (context, followLink) => GestureDetector(
            onTap: followLink,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? Dimensions.spaceL : Dimensions.spaceXL,
                vertical: isMobile
                    ? Dimensions.spaceM / 1.33 // ~12
                    : Dimensions.spaceM / 1.14, // ~14
              ),
              decoration: BoxDecoration(
                color: isPrimary
                    ? context.colors.primary
                    : context.colors.surface,
                border: isPrimary
                    ? null
                    : Border.all(
                        color: isHovered
                            ? context.colors.primary
                            : context.colors.border,
                        width: isHovered ? 2 : 1,
                      ),
                borderRadius: BorderRadius.circular(Dimensions.radiusFull),
                boxShadow: isPrimary
                    ? [
                        BoxShadow(
                          color: context.colors.shadowStrong,
                          blurRadius: isHovered ? 15 : 10,
                          offset: Offset(0, isHovered ? 6 : 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: isPrimary
                      ? context.colors.surface
                      : context.colors.textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Social Icon ──────────────────────────────────────────────────────────────

class _HoverSocialIcon extends StatelessWidget {
  const _HoverSocialIcon({required this.icon, required this.url});

  final FaIconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return HoverWrapper(
      builder: (context, isHovered) {
        return Link(
          uri: Uri.parse(url),
          target: LinkTarget.blank,
          builder: (context, followLink) => GestureDetector(
            onTap: followLink,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.diagonal3Values(
                isHovered ? 1.2 : 1.0,
                isHovered ? 1.2 : 1.0,
                1.0,
              ),
              child: FaIcon(
                icon,
                color: isHovered
                    ? context.colors.primary
                    : context.colors.textTertiary,
                size: Dimensions.iconM,
              ),
            ),
          ),
        );
      },
    );
  }
}
