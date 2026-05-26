import 'package:about/core/constants/info.dart';
import 'package:about/core/dimensions.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:about/presentation/widgets/theme_toggle_button.dart';

class GlassNavbar extends StatelessWidget {
  const GlassNavbar({
    super.key,
    this.onNavTap,
    this.onMenuTap,
    this.showLogo = true,
    this.showBackButton = false,
    this.onBackTap,
    this.showNavItems = true,
  });
  final void Function(String)? onNavTap;
  final VoidCallback? onMenuTap;
  final bool showLogo;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final bool showNavItems;

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
                  GestureDetector(
                    onTap: () => onNavTap?.call('About'),
                    child: Text(
                      AppInfo.fullName,
                      style: GoogleFonts.inter(
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              if (!isMobile && showNavItems)
                Row(
                  children: [
                    _navItem('About', context),
                    const SizedBox(width: 24),
                    _navItem('Stats', context),
                    const SizedBox(width: 24),
                    _navItem('Experience', context),
                    const SizedBox(width: 24),
                    _navItem('Projects', context),
                    const SizedBox(width: 24),
                    if (AppInfo.showContact) ...[
                      _navItem('Contact', context),
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

  Widget _navItem(String title, BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onNavTap?.call(title),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: context.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
