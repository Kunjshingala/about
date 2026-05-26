import 'package:about/core/constants/info.dart';
import 'package:about/core/constants/projects.dart';
import 'package:about/core/dimensions.dart';
import 'package:about/core/models/project.dart';
import 'package:about/core/responsive.dart';
import 'package:about/core/services/github_service.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/blocs/hover/hover_cubit.dart';
import 'package:about/presentation/widgets/glass_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
      _projectsFuture = GitHubService(username: username).fetchAllRepositories().then((githubProjects) {
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
                    constraints: const BoxConstraints(maxWidth: Dimensions.maxWidth),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? width * 0.05 : Dimensions.spaceXXL,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Complete Portfolio',
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
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 80),
                                  child: CircularProgressIndicator(color: context.colors.primary),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return _buildErrorState();
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No projects found.'));
                            }

                            final projects = snapshot.data!;
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                if (isMobile) {
                                  return Column(
                                    children: projects.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final project = entry.value;
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: _projectCard(project, context),
                                      )
                                          .animate()
                                          .fadeIn(duration: 600.ms, delay: (index * 50).ms)
                                          .slideY(begin: 0.1, curve: Curves.easeOutQuad);
                                    }).toList(),
                                  );
                                } else {
                                  return Wrap(
                                    spacing: 24,
                                    runSpacing: 24,
                                    children: projects.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final project = entry.value;
                                      return SizedBox(
                                        width: (constraints.maxWidth - 24) / 2,
                                        child: _projectCard(project, context),
                                      )
                                          .animate()
                                          .fadeIn(duration: 600.ms, delay: (index * 50).ms)
                                          .slideY(begin: 0.1, curve: Curves.easeOutQuad);
                                    }).toList(),
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
              onBackTap: () => context.pop(),
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
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _projectCard(Project project, BuildContext context) {
    return BlocProvider(
      create: (context) => HoverCubit(),
      child: _HoverProjectCard(
        title: project.title,
        desc: project.description,
        tags: project.tags,
        icon: project.icon,
        url: project.url,
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
                  color: isHovered ? context.colors.primary : context.colors.surface,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isHovered ? context.colors.shadowStrong : context.colors.shadow,
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
                          color: isHovered ? context.colors.primary : context.colors.textTertiary,
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
