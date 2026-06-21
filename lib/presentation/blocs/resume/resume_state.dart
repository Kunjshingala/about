
part of 'resume_bloc.dart';

class ResumeState extends Equatable {
  const ResumeState({
    this.activeSection = Section.about,
    this.showLogo = true,
  });

  final Section activeSection;
  final bool showLogo;

  ResumeState copyWith({
    Section? activeSection,
    bool? showLogo,
  }) {
    return ResumeState(
      activeSection: activeSection ?? this.activeSection,
      showLogo: showLogo ?? this.showLogo,
    );
  }

  @override
  List<Object?> get props => [activeSection, showLogo];
}
