import 'package:about/core/constants/info.dart';
import 'package:about/core/enums/section.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  State<ResumeScreen> createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  List<MapEntry<Section?, Widget>> _getSections() {
    return [
      const MapEntry(Section.about, RepaintBoundary(child: HeroSection())),
      const MapEntry(Section.stats, Padding(padding: EdgeInsets.only(top: 100), child: RepaintBoundary(child: StatsSection()))),
      const MapEntry(Section.experience, Padding(padding: EdgeInsets.only(top: 120), child: RepaintBoundary(child: ExperienceSection()))),
      const MapEntry(Section.skills, Padding(padding: EdgeInsets.only(top: 120), child: RepaintBoundary(child: SkillsSection()))),
      const MapEntry(Section.projects, Padding(padding: EdgeInsets.only(top: 120), child: RepaintBoundary(child: ProjectsSection()))),
      if (AppInfo.showTestimonials)
        const MapEntry(Section.testimonials, Padding(padding: EdgeInsets.only(top: 120), child: RepaintBoundary(child: TestimonialsSection()))),
      if (AppInfo.showContact)
        const MapEntry(Section.contact, Padding(padding: EdgeInsets.only(top: 120), child: RepaintBoundary(child: ContactSection()))),
      const MapEntry(null, Padding(padding: EdgeInsets.only(top: 120), child: RepaintBoundary(child: Footer()))),
    ];
  }

  void _onNavTap(Section section) {
    if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      Navigator.pop(context);
    }
    final sections = _getSections();
    final index = sections.indexWhere((e) => e.key == section);
    if (index != -1 && _itemScrollController.isAttached) {
      _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutQuart,
        alignment: 0.1, // Scroll slightly below the navbar
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  void _onScroll() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final firstItem = positions.cast<ItemPosition?>().firstWhere((p) => p!.index == 0, orElse: () => null);
    final shouldShowLogo = firstItem == null || firstItem.itemLeadingEdge < -0.1;

    if (shouldShowLogo != context.read<ResumeBloc>().state.showLogo) {
      context.read<ResumeBloc>().add(LogoVisibilityChanged(showLogo: shouldShowLogo));
    }

    // Determine active section by finding the most prominent section on screen
    Section? activeSection;
    final sections = _getSections();
    
    ItemPosition? bestPosition;
    for (final pos in positions) {
      if (pos.itemLeadingEdge <= 0.4 && pos.itemTrailingEdge > 0.1) {
        if (bestPosition == null || pos.itemLeadingEdge.abs() < bestPosition.itemLeadingEdge.abs()) {
          bestPosition = pos;
        }
      }
    }
    
    if (bestPosition != null) {
      final key = sections[bestPosition.index].key;
      if (key != null) {
        activeSection = key;
      }
    }

    if (activeSection != null &&
        activeSection != context.read<ResumeBloc>().state.activeSection) {
      context.read<ResumeBloc>().add(SectionChanged(activeSection));
    }
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sections = _getSections();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.colors.background,
      endDrawer: MobileDrawer(onNavTap: _onNavTap),
      body: Stack(
        children: [
          ScrollablePositionedList.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) => sections[index].value,
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BlocBuilder<ResumeBloc, ResumeState>(
              buildWhen: (previous, current) =>
                  previous.showLogo != current.showLogo ||
                  previous.activeSection != current.activeSection,
              builder: (context, state) {
                return GlassNavbar(
                  showLogo: state.showLogo,
                  activeSection: state.activeSection,
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
