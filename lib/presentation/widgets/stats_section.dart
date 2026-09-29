import 'package:about/core/constants/stats.dart';
import 'package:about/core/dimensions.dart';
import 'package:about/core/models/stat.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = Responsive.screenWidth(context);
    final isMobile = Responsive.isMobile(context);

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: Dimensions.maxWidth),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? width * 0.05 : Dimensions.spaceXXL,
        ),
        child: isMobile
            ? const _MobileStatBand(stats: Stats.stats)
            : const _DesktopStatBand(stats: Stats.stats),
      ),
    );
  }
}

// ─── Desktop: horizontal row with VerticalDividers ────────────────────────────

class _DesktopStatBand extends StatelessWidget {
  const _DesktopStatBand({required this.stats});
  final List<Stat> stats;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    for (var i = 0; i < stats.length; i++) {
      final stat = stats[i];

      items.add(
        Expanded(
          child: _StatBlock(
            value: stat.value,
            label: stat.label,
            index: i,
            isMobile: false,
          ),
        ),
      );

      // Hairline vertical divider between blocks (not after the last one)
      if (i < stats.length - 1) {
        items.add(
          SizedBox(
            height: 64,
            child: VerticalDivider(
              width: Dimensions.spaceXXL,
              thickness: 1,
              color: context.colors.border,
            ),
          ),
        );
      }
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
      ),
    );
  }
}

// ─── Mobile: vertical stack with Dividers ─────────────────────────────────────

class _MobileStatBand extends StatelessWidget {
  const _MobileStatBand({required this.stats});
  final List<Stat> stats;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    for (var i = 0; i < stats.length; i++) {
      final stat = stats[i];

      items.add(
        _StatBlock(
          value: stat.value,
          label: stat.label,
          index: i,
          isMobile: true,
        ),
      );

      // Hairline horizontal divider between blocks (not after the last one)
      if (i < stats.length - 1) {
        items.add(
          Divider(
            height: Dimensions.spaceXXL,
            thickness: 1,
            color: context.colors.border,
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }
}

// ─── Single stat block — number + label, magazine pull-stat style ─────────────

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.value,
    required this.label,
    required this.index,
    required this.isMobile,
  });

  final String value;
  final String label;
  final int index;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMobile
          ? const EdgeInsets.symmetric(vertical: Dimensions.spaceM)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Large, bold number — the "pull-stat" weight
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 40 : 52,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
              height: 1.0,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: Dimensions.spaceXS + 2), // ~6
          // Small, gray label underneath
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 12 : 13,
              fontWeight: FontWeight.w500,
              color: context.colors.textTertiary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: (index * 120).ms)
        .slideY(begin: 0.15, curve: Curves.easeOutQuad);
  }
}
