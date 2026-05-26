import 'package:about/core/dimensions.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

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
              'Testimonials',
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
              'What people say about my work',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: context.colors.textSecondary,
                  fontSize: isMobile ? 12 : 13),
            ),
            const SizedBox(height: 40),
            if (isMobile) ...[
              _testimonialCard(
                'Working with Alex was a game-changer for our project. His Flutter expertise and attention to detail resulted in a beautiful, performant app.',
                'Sarah Chen',
                'Product Manager at TechCorp',
                5,
                context,
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 100.ms)
                  .slideX(begin: 0.1),
              const SizedBox(height: 16),
              _testimonialCard(
                'Alex delivered our MVP ahead of schedule with exceptional quality. His code is clean, well-documented, and maintainable.',
                'Michael Rodriguez',
                'CTO at StartupXYZ',
                5,
                context,
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideX(begin: 0.1),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _testimonialCard(
                      'Working with Alex was a game-changer for our project. His Flutter expertise and attention to detail resulted in a beautiful, performant app.',
                      'Sarah Chen',
                      'Product Manager at TechCorp',
                      5,
                      context,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 100.ms)
                        .slideX(begin: 0.1),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _testimonialCard(
                      'Alex delivered our MVP ahead of schedule with exceptional quality. His code is clean, well-documented, and maintainable.',
                      'Michael Rodriguez',
                      'CTO at StartupXYZ',
                      5,
                      context,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .slideX(begin: 0.1),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _testimonialCard(String quote, String name, String role, int rating,
      BuildContext context) {
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
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Star rating
          Row(
            children: List.generate(
              5,
              (index) => Icon(index < rating ? Icons.star : Icons.star_border,
                  color: const Color(0xFFFFA500), size: 16),
            ),
          ),
          const SizedBox(height: 16),

          // Quote
          Text(
            '"$quote"',
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 14 : 15,
              color: context.colors.textPrimary,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),

          // Divider
          Divider(color: context.colors.borderLight),
          const SizedBox(height: 16),

          // Name and role
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 14 : 15,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                    fontSize: isMobile ? 12 : 13,
                    color: context.colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
