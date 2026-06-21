import 'package:about/core/enums/section.dart';
import 'package:about/presentation/blocs/resume/resume_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResumeBloc', () {
    late ResumeBloc resumeBloc;

    setUp(() {
      resumeBloc = ResumeBloc();
    });

    tearDown(() {
      resumeBloc.close();
    });

    test('initial state is ResumeState(activeSection: Section.about)', () {
      expect(resumeBloc.state, const ResumeState(activeSection: Section.about));
    });

    blocTest<ResumeBloc, ResumeState>(
      'emits [ResumeState(activeSection: Section.about)] when SectionChanged(Section.about) is added',
      build: () => resumeBloc,
      act: (bloc) => bloc.add(const SectionChanged(Section.about)),
      expect: () => [
        const ResumeState(activeSection: Section.about),
      ],
    );

    blocTest<ResumeBloc, ResumeState>(
      'emits [ResumeState(activeSection: Section.projects)] when SectionChanged(Section.projects) is added',
      build: () => resumeBloc,
      act: (bloc) => bloc.add(const SectionChanged(Section.projects)),
      expect: () => [
        const ResumeState(activeSection: Section.projects),
      ],
    );
  });
}
