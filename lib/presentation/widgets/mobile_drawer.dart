import 'package:about/core/constants/info.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key, required this.onNavTap});
  final void Function(String) onNavTap;

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
          _drawerItem('About', Icons.person_outline, context),
          _drawerItem('Stats', Icons.bar_chart, context),
          _drawerItem('Experience', Icons.work_outline, context),
          _drawerItem('Projects', Icons.code, context),
          _drawerItem('Contact', Icons.email_outlined, context),
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

  Widget _drawerItem(String title, IconData icon, BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      leading: Icon(icon, color: context.colors.textSecondary, size: 20),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: context.colors.textPrimary,
        ),
      ),
      onTap: () => onNavTap(title),
    );
  }
}
