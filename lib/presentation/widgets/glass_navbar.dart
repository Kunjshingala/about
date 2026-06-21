import 'package:about/core/constants/info.dart';
import 'package:about/core/dimensions.dart';
import 'package:about/core/enums/section.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/widgets/hover_wrapper.dart';
import 'package:about/presentation/widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

class GlassNavbar extends StatelessWidget {
  const GlassNavbar({
    super.key,
    this.onNavTap,
    this.onMenuTap,
    this.showLogo = true,
    this.showBackButton = false,
    this.onBackTap,
    this.showNavItems = true,
    this.activeSection = Section.about,
  });
  final void Function(Section)? onNavTap;
  final VoidCallback? onMenuTap;
  final bool showLogo;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final bool showNavItems;
  final Section activeSection;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      decoration: BoxDecoration(color: context.colors.navBackground),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: Dimensions.maxWidth),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 24,
            vertical: isMobile ? 12 : 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showBackButton)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 20),
                        color: context.colors.textPrimary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: onBackTap,
                      ),
                    ),
                  HoverWrapper(
                    builder: (context, isHovered) {
                      return Link(
                        uri: Uri.parse('/'),
                        builder: (context, followLink) => GestureDetector(
                          onTap: () => onNavTap?.call(Section.about),
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 12 : 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              color: isHovered
                                  ? context.colors.primary
                                  : context.colors.textPrimary,
                            ),
                            child: const Text(AppInfo.fullName),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              if (!isMobile && showNavItems)
                Row(
                  children: [
                    _navItem(Section.about, context),
                    const SizedBox(width: 24),
                    _navItem(Section.stats, context),
                    const SizedBox(width: 24),
                    _navItem(Section.experience, context),
                    const SizedBox(width: 24),
                    _navItem(Section.projects, context),
                    const SizedBox(width: 24),
                    if (AppInfo.showContact) ...[
                      _navItem(Section.contact, context),
                      const SizedBox(width: 24),
                    ],
                    const ThemeToggleButton(),
                  ],
                )
              else if (isMobile && onMenuTap != null)
                Row(
                  children: [
                    const ThemeToggleButton(),
                    IconButton(
                      icon: const Icon(Icons.menu),
                      color: context.colors.primary,
                      iconSize: 20,
                      onPressed: onMenuTap,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(Section section, BuildContext context) {
    final isActive = activeSection == section;
    return HoverWrapper(
      builder: (context, isHovered) {
        return Link(
          uri: Uri.parse('/#${section.name}'),
          builder: (context, followLink) => GestureDetector(
            onTap: () => onNavTap?.call(section),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive || isHovered
                        ? context.colors.primary
                        : context.colors.textSecondary,
                  ),
                  child: Text(section.title),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  height: 2,
                  width: isActive ? 20 : 0,
                  decoration: BoxDecoration(
                    color: context.colors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
