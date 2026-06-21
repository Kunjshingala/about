import 'package:about/core/constants/info.dart';
import 'package:about/core/constants/projects.dart';
import 'package:about/core/dimensions.dart';
import 'package:about/core/models/project.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/services/github_service.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/widgets/glass_navbar.dart';
import 'package:about/presentation/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AllProjectsScreen extends StatefulWidget {
  const AllProjectsScreen({super.key});

  @override
  State<AllProjectsScreen> createState() => _AllProjectsScreenState();
}

class _AllProjectsScreenState extends State<AllProjectsScreen> {
  late Future<List<Project>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  void _loadProjects() {
    if (ProjectConstants.isGitHubDynamic) {
      final username = AppInfo.githubUrl.split('/').last;
      _projectsFuture = GitHubService(username: username)
          .fetchAllRepositories()
          .then((githubProjects) {
        // Merge manual projects with GitHub projects
        return [...ProjectConstants.manualProjects, ...githubProjects];
      });
    } else {
      // Show only manual projects if dynamic loading is disabled
      _projectsFuture = Future.value(ProjectConstants.manualProjects);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.screenWidth(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(height: 100), // Height for sticky navbar
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: Dimensions.maxWidth),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? width * 0.05 : Dimensions.spaceXXL,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All Projects',
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Explore all my open-source contributions and personal projects fetched directly from GitHub.',
                          style: GoogleFonts.inter(
                            color: context.colors.textSecondary,
                            fontSize: isMobile ? 14 : 16,
                          ),
                        ),
                        const SizedBox(height: 60),
                        FutureBuilder<List<Project>>(
                          future: _projectsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 80),
                                  child: CircularProgressIndicator(
                                      color: context.colors.primary),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return _buildErrorState();
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No projects found.'));
                            }

                            final projects = snapshot.data!;
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                if (isMobile) {
                                  return Column(
                                    children:
                                        projects.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final project = entry.value;
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
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
                                              delay: (index * 50).ms)
                                          .slideY(
                                              begin: 0.1,
                                              curve: Curves.easeOutQuad);
                                    }).toList(),
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      for (int i = 0;
                                          i < projects.length;
                                          i += 2)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: i + 2 < projects.length
                                                  ? 24
                                                  : 0),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                  child: ProjectCard(
                                                    title: projects[i].title,
                                                    desc:
                                                        projects[i].description,
                                                    tags: projects[i].tags,
                                                    icon: projects[i].icon,
                                                    url: projects[i].url,
                                                  )
                                                      .animate()
                                                      .fadeIn(
                                                          duration: 600.ms,
                                                          delay: (i * 50).ms)
                                                      .slideY(
                                                          begin: 0.1,
                                                          curve: Curves
                                                              .easeOutQuad),
                                                ),
                                                const SizedBox(width: 24),
                                                if (i + 1 < projects.length)
                                                  Expanded(
                                                    child: ProjectCard(
                                                      title:
                                                          projects[i + 1].title,
                                                      desc: projects[i + 1]
                                                          .description,
                                                      tags:
                                                          projects[i + 1].tags,
                                                      icon:
                                                          projects[i + 1].icon,
                                                      url: projects[i + 1].url,
                                                    )
                                                        .animate()
                                                        .fadeIn(
                                                            duration: 600.ms,
                                                            delay:
                                                                ((i + 1) * 50)
                                                                    .ms)
                                                        .slideY(
                                                            begin: 0.1,
                                                            curve: Curves
                                                                .easeOutQuad),
                                                  )
                                                else
                                                  const Expanded(
                                                      child: SizedBox()),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassNavbar(
              showNavItems: false,
              showBackButton: true,
              onBackTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.orange, size: 60),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'I was unable to load the full project list at this time.',
              style: GoogleFonts.inter(color: context.colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _loadProjects();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.surface,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
