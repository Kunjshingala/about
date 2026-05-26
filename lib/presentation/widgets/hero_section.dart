import 'package:about/core/constants/info.dart';
import 'package:about/core/dimensions.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/blocs/hover/hover_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = Responsive.screenWidth(context);
    final isMobile = Responsive.isMobile(context);

    final headerSize = Dimensions.getResponsiveSize(
      width,
      factor: 0.08,
      min: 28,
      max: 48,
    );

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: Dimensions.maxWidth),
        padding: EdgeInsets.symmetric(
            horizontal: isMobile ? width * 0.05 : Dimensions.spaceXXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Dimensions.getResponsiveSize(
                    width,
                    factor: 0.1,
                    min: 0,
                    max: 100,
                  ) +
                  80,
            ),

            // "Hi, I'm" text
            RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: headerSize,
                  fontWeight: FontWeight.w400,
                  color: context.colors.textPrimary,
                  height: 1.3,
                ),
                children: [
                  const TextSpan(text: "Hi, I'm "),
                  TextSpan(
                    text: AppInfo.firstName,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w800, // Extra bold to stand out
                      color: context.colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),

            const SizedBox(height: Dimensions.spaceM),

            // Role
            Text(
              AppInfo.jobTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.w500,
                color: context.colors.textSecondary,
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 200.ms),

            const SizedBox(height: Dimensions.spaceL),

            // Bio
            Text(
              AppInfo.bio,
              style: GoogleFonts.inter(
                fontSize: isMobile ? 14 : 16,
                color: context.colors.textSecondary,
                height: 1.7,
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 400.ms),

            const SizedBox(height: Dimensions.spaceXXL),

            // Action buttons
            Wrap(
              spacing: Dimensions.spaceM,
              runSpacing: Dimensions.spaceM / 1.33, // approx 12
              children: [
                _ctaButton(
                  'Download CV/Resume',
                  true,
                  AppInfo.resumeDownloadUrl,
                  context: context,
                ),
                _ctaButton(
                  'View CV/Resume',
                  false,
                  AppInfo.resumeViewUrl,
                  context: context,
                ),
              ],
            ).animate().fadeIn(duration: 800.ms, delay: 600.ms),

            const SizedBox(height: Dimensions.spaceXXL),

            // Social icons
            Wrap(
              spacing: Dimensions.spaceL,
              runSpacing: Dimensions.spaceM,
              children: [
                if (AppInfo.showGithub)
                  _socialIcon(FontAwesomeIcons.github, AppInfo.githubUrl),
                if (AppInfo.showLinkedIn)
                  _socialIcon(
                    FontAwesomeIcons.linkedin,
                    AppInfo.linkedinUrl,
                  ),
                if (AppInfo.showTwitter)
                  _socialIcon(
                    FontAwesomeIcons.xTwitter,
                    AppInfo.twitterUrl,
                  ),
                _socialIcon(
                  FontAwesomeIcons.envelope,
                  AppInfo.emailAddress,
                ),
              ],
            ).animate().fadeIn(duration: 800.ms, delay: 800.ms),
          ],
        ),
      ),
    );
  }

  Widget _ctaButton(
    String title,
    bool isPrimary,
    String url, {
    required BuildContext context,
  }) {
    return BlocProvider(
      create: (context) => HoverCubit(),
      child: _HoverCTAButton(title: title, isPrimary: isPrimary, url: url),
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return BlocProvider(
      create: (context) => HoverCubit(),
      child: _HoverSocialIcon(icon: icon, url: url),
    );
  }
}

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

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => context.read<HoverCubit>().setHovered(true),
      onExit: (_) => context.read<HoverCubit>().setHovered(false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: BlocBuilder<HoverCubit, bool>(
          builder: (context, isHovered) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? Dimensions.spaceL : Dimensions.spaceXL,
                vertical: isMobile
                    ? Dimensions.spaceM / 1.33
                    : Dimensions.spaceM / 1.14, // approx 12, 14
              ),
              decoration: BoxDecoration(
                color:
                    isPrimary ? context.colors.primary : context.colors.surface,
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
            );
          },
        ),
      ),
    );
  }
}

class _HoverSocialIcon extends StatelessWidget {
  const _HoverSocialIcon({required this.icon, required this.url});
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => context.read<HoverCubit>().setHovered(true),
      onExit: (_) => context.read<HoverCubit>().setHovered(false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: BlocBuilder<HoverCubit, bool>(
          builder: (context, isHovered) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              transform: Matrix4.diagonal3Values(
                isHovered ? 1.2 : 1.0,
                isHovered ? 1.2 : 1.0,
                1.0,
              ),
              child: Icon(
                icon,
                color: isHovered
                    ? context.colors.primary
                    : context.colors.textTertiary,
                size: Dimensions.iconM,
              ),
            );
          },
        ),
      ),
    );
  }
}
