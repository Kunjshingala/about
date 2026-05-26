import 'package:about/core/constants/stats.dart';
import 'package:about/core/dimensions.dart';
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
    const stats = Stats.stats;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: Dimensions.maxWidth),
        padding: EdgeInsets.symmetric(
            horizontal: isMobile ? width * 0.05 : Dimensions.spaceXXL),
        child: isMobile
            ? Column(
                children: stats.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stat = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _statCard(stat.value, stat.label, context),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: (index * 100).ms)
                      .slideY(begin: 0.2, curve: Curves.easeOutQuad);
                }).toList(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: stats.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stat = entry.value;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: stat == stats.last ? 0 : 24,
                      ),
                      child: _statCard(stat.value, stat.label, context),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: (index * 100).ms)
                        .slideY(begin: 0.2, curve: Curves.easeOutQuad),
                  );
                }).toList(),
              ),
      ),
    );
  }

  Widget _statCard(String value, String label, BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 12 : 13,
              fontWeight: FontWeight.w500,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
