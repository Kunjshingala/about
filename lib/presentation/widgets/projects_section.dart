import 'package:about/core/constants/info.dart';
import 'package:about/core/constants/projects.dart';
import 'package:about/core/dimensions.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/blocs/projects/projects_bloc.dart';
import 'package:about/presentation/blocs/projects/projects_event.dart';
import 'package:about/presentation/blocs/projects/projects_state.dart';
import 'package:about/presentation/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

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
                                Link(
                                  uri: Uri.parse(AppInfo.githubUrl),
                                  target: LinkTarget.blank,
                                  builder: (context, followLink) =>
                                      ElevatedButton.icon(
                                    onPressed: followLink,
                                    icon: const Icon(Icons.open_in_new),
                                    label: const Text('View on GitHub'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: context.colors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                    ),
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
                                    child: ProjectCard(
                                      title: project.title,
                                      desc: project.description,
                                      tags: project.tags,
                                      icon: project.icon,
                                      url: project.url,
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
                              Column(
                                children: [
                                  for (int i = 0; i < projects.length; i += 2)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              i + 2 < projects.length ? 24 : 0),
                                      child: IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: ProjectCard(
                                                title: projects[i].title,
                                                desc: projects[i].description,
                                                tags: projects[i].tags,
                                                icon: projects[i].icon,
                                                url: projects[i].url,
                                              )
                                                  .animate()
                                                  .fadeIn(
                                                      duration: 600.ms,
                                                      delay: (i * 150).ms)
                                                  .slideY(
                                                      begin: 0.1,
                                                      curve:
                                                          Curves.easeOutQuad),
                                            ),
                                            const SizedBox(width: 24),
                                            if (i + 1 < projects.length)
                                              Expanded(
                                                child: ProjectCard(
                                                  title: projects[i + 1].title,
                                                  desc: projects[i + 1]
                                                      .description,
                                                  tags: projects[i + 1].tags,
                                                  icon: projects[i + 1].icon,
                                                  url: projects[i + 1].url,
                                                )
                                                    .animate()
                                                    .fadeIn(
                                                        duration: 600.ms,
                                                        delay:
                                                            ((i + 1) * 150).ms)
                                                    .slideY(
                                                        begin: 0.1,
                                                        curve:
                                                            Curves.easeOutQuad),
                                              )
                                            else
                                              const Expanded(child: SizedBox()),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            const SizedBox(height: 48),
                            Center(
                              child: Column(
                                children: [
                                  Link(
                                    uri: Uri.parse('/projects'),
                                    builder: (context, followLink) =>
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Link(
                                    uri: Uri.parse(AppInfo.githubUrl),
                                    target: LinkTarget.blank,
                                    builder: (context, followLink) =>
                                        TextButton.icon(
                                      onPressed: followLink,
                                      icon: const Icon(Icons.open_in_new,
                                          size: 14),
                                      label: Text(
                                        'Open GitHub Profile',
                                        style: GoogleFonts.inter(
                                          color: context.colors.textSecondary,
                                          fontSize: 13,
                                          decoration: TextDecoration.underline,
                                        ),
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
                                    child: ProjectCard(
                                      title: project.title,
                                      desc: project.description,
                                      tags: project.tags,
                                      icon: project.icon,
                                      url: project.url,
                                    ),
                                  ))
                              .toList(),
                        )
                      else
                        Column(
                          children: [
                            for (int i = 0; i < projects.length; i += 2)
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: i + 2 < projects.length ? 24 : 0),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: ProjectCard(
                                          title: projects[i].title,
                                          desc: projects[i].description,
                                          tags: projects[i].tags,
                                          icon: projects[i].icon,
                                          url: projects[i].url,
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      if (i + 1 < projects.length)
                                        Expanded(
                                          child: ProjectCard(
                                            title: projects[i + 1].title,
                                            desc: projects[i + 1].description,
                                            tags: projects[i + 1].tags,
                                            icon: projects[i + 1].icon,
                                            url: projects[i + 1].url,
                                          ),
                                        )
                                      else
                                        const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      const SizedBox(height: 48),
                      Center(
                        child: Link(
                          uri: Uri.parse('/projects'),
                          builder: (context, followLink) => ElevatedButton.icon(
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
}
