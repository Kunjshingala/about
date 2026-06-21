import 'package:about/core/constants/info.dart';
import 'package:about/core/enums/section.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/blocs/resume/resume_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key, required this.onNavTap});
  final void Function(Section) onNavTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '${AppInfo.firstName.toUpperCase()} ${AppInfo.lastName.toUpperCase()}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Divider(color: context.colors.borderLight),
          BlocBuilder<ResumeBloc, ResumeState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _drawerItem(Section.about, state.activeSection == Section.about, context),
                  _drawerItem(Section.stats, state.activeSection == Section.stats, context),
                  _drawerItem(Section.experience, state.activeSection == Section.experience, context),
                  _drawerItem(Section.projects, state.activeSection == Section.projects, context),
                  if (AppInfo.showTestimonials)
                    _drawerItem(Section.testimonials, state.activeSection == Section.testimonials, context),
                  if (AppInfo.showContact)
                    _drawerItem(Section.contact, state.activeSection == Section.contact, context),
                ],
              );
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '© ${AppInfo.copyrightYear} ${AppInfo.fullName}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: context.colors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(Section section, bool isActive, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? context.colors.primary.withValues(alpha: 0.1) : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: isActive ? context.colors.primary : Colors.transparent,
            width: 4,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(section.icon, color: isActive ? context.colors.primary : context.colors.textSecondary, size: 20),
        title: Text(
          section.title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? context.colors.primary : context.colors.textPrimary,
          ),
        ),
        onTap: () => onNavTap(section),
      ),
    );
  }
}
