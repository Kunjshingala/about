import 'package:about/core/constants/info.dart';
import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/blocs/resume/resume_bloc.dart';
import 'package:about/presentation/widgets/contact_section.dart';
import 'package:about/presentation/widgets/experience_section.dart';
import 'package:about/presentation/widgets/footer.dart';
import 'package:about/presentation/widgets/glass_navbar.dart';
import 'package:about/presentation/widgets/hero_section.dart';
import 'package:about/presentation/widgets/mobile_drawer.dart';
import 'package:about/presentation/widgets/projects_section.dart';
import 'package:about/presentation/widgets/skills_section.dart';
import 'package:about/presentation/widgets/stats_section.dart';
import 'package:about/presentation/widgets/testimonials_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _statsKey = GlobalKey();
  final GlobalKey _expKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final box = context.findRenderObject()! as RenderBox;
      final viewport = RenderAbstractViewport.of(box);

      // Calculate target: reveal offset - navbar height (approx 80px)
      final target = viewport.getOffsetToReveal(box, 0.0).offset - 80;

      _scrollController.animateTo(
        target < 0 ? 0 : target,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutQuart,
      );
    }
  }

  void _onNavTap(String section) {
    if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      Navigator.pop(context);
    }

    switch (section) {
      case 'About':
        _scrollToSection(_aboutKey);
        break;
      case 'Stats':
        _scrollToSection(_statsKey);
        break;
      case 'Experience':
        _scrollToSection(_expKey);
        break;
      case 'Skills':
        _scrollToSection(_skillsKey);
        break;
      case 'Projects':
        _scrollToSection(_projectsKey);
        break;
      case 'Testimonials':
        _scrollToSection(_testimonialsKey);
        break;
      case 'Contact':
        _scrollToSection(_contactKey);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShowLogo = _scrollController.offset <= 50;
    if (shouldShowLogo != context.read<ResumeBloc>().state.showLogo) {
      context
          .read<ResumeBloc>()
          .add(LogoVisibilityChanged(showLogo: shouldShowLogo));
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.colors.background,
      endDrawer: MobileDrawer(onNavTap: _onNavTap),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(key: _aboutKey),
                const SizedBox(height: 100),
                StatsSection(key: _statsKey),
                const SizedBox(height: 120),
                ExperienceSection(key: _expKey),
                const SizedBox(height: 120),
                SkillsSection(key: _skillsKey),
                const SizedBox(height: 120),
                ProjectsSection(key: _projectsKey),
                if (AppInfo.showTestimonials) ...[
                  const SizedBox(height: 120),
                  TestimonialsSection(key: _testimonialsKey),
                ],
                if (AppInfo.showContact) ...[
                  const SizedBox(height: 120),
                  ContactSection(key: _contactKey),
                ],
                const Footer(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BlocBuilder<ResumeBloc, ResumeState>(
              buildWhen: (previous, current) =>
                  previous.showLogo != current.showLogo,
              builder: (context, state) {
                return GlassNavbar(
                  showLogo: state.showLogo,
                  onNavTap: _onNavTap,
                  onMenuTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
