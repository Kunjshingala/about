import 'package:about/core/responsive.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/widgets/hover_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.title,
    required this.desc,
    required this.tags,
    required this.icon,
    required this.url,
  });

  final String title;
  final String desc;
  final List<String> tags;
  final IconData icon;
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
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              tween: Tween<double>(begin: 0.0, end: isHovered ? 1.0 : 0.0),
              builder: (context, hoverT, _) {
                return Container(
                  padding: EdgeInsets.all(isMobile ? 24 : 32),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color.lerp(context.colors.surface, context.colors.primary, hoverT)!,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.lerp(context.colors.shadow, context.colors.shadowStrong, hoverT)!,
                        blurRadius: 30 + (10 * hoverT),
                        offset: Offset(0, 10 + (5 * hoverT)),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: context.colors.fieldBackground,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              icon,
                              color: context.colors.textPrimary,
                              size: isMobile ? 20 : 24,
                            ),
                          ),
                          Transform.rotate(
                            angle: hoverT * (0.125 * 2 * 3.1415926535),
                            child: Icon(
                              Icons.open_in_new,
                              color: Color.lerp(context.colors.textTertiary, context.colors.primary, hoverT),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    desc,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: context.colors.textSecondary,
                      fontSize: isMobile ? 14 : 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Divider(color: context.colors.borderLight),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: tags
                        .map(
                          (t) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.tagBackground,
                              border: Border.all(color: context.colors.border),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              t,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textTertiary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
      },
    );
  }
}
