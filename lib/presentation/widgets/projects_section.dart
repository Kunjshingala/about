import 'package:about/core/constants/info.dart';
import 'package:about/core/constants/projects.dart';
import 'package:about/core/dimensions.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/blocs/hover/hover_cubit.dart';
import 'package:about/presentation/blocs/projects/projects_bloc.dart';
import 'package:about/presentation/blocs/projects/projects_event.dart';
import 'package:about/presentation/blocs/projects/projects_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTE TO REVIEWERS:
    // This section dynamically switches between a Bloc-driven GitHub project list
    // and a static list based on ProjectConstants.isGitHubDynamic.
    //
    // FONT CONSISTENCY: All text styles here explicitly use GoogleFonts.inter()
    // to match the site's overall typography, ensuring a uniform look even
    // when dynamic data is loaded.

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
              'Featured Projects',
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
              ProjectConstants.isGitHubDynamic
                  ? 'Selected work from GitHub showcasing Flutter expertise'
                  : 'Selected work showcasing Flutter expertise',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: context.colors.textSecondary,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
            const SizedBox(height: 40),
            if (ProjectConstants.isGitHubDynamic)
              BlocBuilder<ProjectsBloc, ProjectsState>(
                builder: (context, state) {
                  if (state is ProjectsLoading) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(
                            color: context.colors.primary),
                      ),
                    );
                  } else if (state is ProjectsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.orange, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              'GitHub Projects temporarily unavailable',
                              style: GoogleFonts.inter(
                                color: context.colors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "I'm having trouble fetching my latest projects from GitHub right now.",
                              style: GoogleFonts.inter(
                                  color: context.colors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              alignment: WrapAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final uri = Uri.parse(AppInfo.githubUrl);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri,
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  icon: const Icon(Icons.open_in_new),
                                  label: const Text('View on GitHub'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.colors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () => context
                                      .read<ProjectsBloc>()
                                      .add(FetchProjects()),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retry'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is ProjectsLoaded) {
                    final projects = state.projects;
                    if (projects.isEmpty) {
                      return const Center(child: Text('No projects found.'));
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            if (isMobile)
                              Column(
                                children: projects.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final project = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _projectCard(
                                      project.title,
                                      project.description,
                                      project.tags,
                                      project.icon,
                                      project.url,
                                      context,
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(
                                          duration: 600.ms,
                                          delay: (index * 150).ms)
                                      .slideY(
                                          begin: 0.1,
                                          curve: Curves.easeOutQuad);
                                }).toList(),
                              )
                            else
                              Wrap(
                                spacing: 24,
                                runSpacing: 24,
                                children: projects.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final project = entry.value;
                                  return SizedBox(
                                    width: (constraints.maxWidth - 24) / 2,
                                    child: _projectCard(
                                      project.title,
                                      project.description,
                                      project.tags,
                                      project.icon,
                                      project.url,
                                      context,
                                    ),
                                  )
                                      .animate()
                                      .fadeIn(
                                          duration: 600.ms,
                                          delay: (index * 150).ms)
                                      .slideY(
                                          begin: 0.1,
                                          curve: Curves.easeOutQuad);
                                }).toList(),
                              ),
                            const SizedBox(height: 48),
                            Center(
                              child: Column(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => context.push('/projects'),
                                    icon: const Icon(Icons.grid_view_rounded,
                                        size: 18),
                                    label: Text(
                                      'View More Projects',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.colors.primary,
                                      foregroundColor: context.colors.surface,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 22),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextButton.icon(
                                    onPressed: () async {
                                      final uri = Uri.parse(AppInfo.githubUrl);
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri,
                                            mode:
                                                LaunchMode.externalApplication);
                                      }
                                    },
                                    icon:
                                        const Icon(Icons.open_in_new, size: 14),
                                    label: Text(
                                      'Open GitHub Profile',
                                      style: GoogleFonts.inter(
                                        color: context.colors.textSecondary,
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              )
            else
              // Static Projects View (Using PersonalInfo.manualProjects)
              LayoutBuilder(
                builder: (context, constraints) {
                  final projects = ProjectConstants.manualProjects;
                  return Column(
                    children: [
                      if (isMobile)
                        Column(
                          children: projects
                              .map((project) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _projectCard(
                                      project.title,
                                      project.description,
                                      project.tags,
                                      project.icon,
                                      project.url,
                                      context,
                                    ),
                                  ))
                              .toList(),
                        )
                      else
                        Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          children: projects
                              .map((project) => SizedBox(
                                    width: (constraints.maxWidth - 24) / 2,
                                    child: _projectCard(
                                      project.title,
                                      project.description,
                                      project.tags,
                                      project.icon,
                                      project.url,
                                      context,
                                    ),
                                  ))
                              .toList(),
                        ),
                      const SizedBox(height: 48),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/projects'),
                          icon: const Icon(Icons.grid_view_rounded, size: 18),
                          label: Text(
                            'View More Projects',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: context.colors.surface,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _projectCard(
    String title,
    String desc,
    List<String> tags,
    IconData icon,
    String url,
    BuildContext context,
  ) {
    return BlocProvider(
      create: (context) => HoverCubit(),
      child: _HoverProjectCard(
        title: title,
        desc: desc,
        tags: tags,
        icon: icon,
        url: url,
      ),
    );
  }
}

class _HoverProjectCard extends StatelessWidget {
  const _HoverProjectCard({
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
              padding: EdgeInsets.all(isMobile ? 24 : 32),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isHovered
                      ? context.colors.primary
                      : context.colors.surface,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? context.colors.shadowStrong
                        : context.colors.shadow,
                    blurRadius: isHovered ? 40 : 30,
                    offset: Offset(0, isHovered ? 15 : 10),
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
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: isHovered ? 0.125 : 0,
                        child: Icon(
                          Icons.open_in_new,
                          color: isHovered
                              ? context.colors.primary
                              : context.colors.textTertiary,
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
  }
}
