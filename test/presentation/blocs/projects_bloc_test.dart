import 'package:about/core/models/project.dart';
import 'package:about/core/services/github_service.dart';
import 'package:about/presentation/blocs/projects/projects_bloc.dart';
import 'package:about/presentation/blocs/projects/projects_event.dart';
import 'package:about/presentation/blocs/projects/projects_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGitHubService extends Mock implements GitHubService {}

void main() {
  group('ProjectsBloc', () {
    late MockGitHubService mockGitHubService;
    late ProjectsBloc projectsBloc;

    final tProjects = [
      Project(
        title: 'TestRepo',
        description: 'A test repository.',
        tags: const ['Dart'],
        url: 'https://github.com/user/TestRepo',
        icon: Icons.code,
      ),
    ];

    setUp(() {
      mockGitHubService = MockGitHubService();
      projectsBloc = ProjectsBloc(gitHubService: mockGitHubService);
    });

    tearDown(() {
      projectsBloc.close();
    });

    test('initial state is ProjectsInitial', () {
      expect(projectsBloc.state, isA<ProjectsInitial>());
    });

    blocTest<ProjectsBloc, ProjectsState>(
      'emits [ProjectsLoading, ProjectsLoaded] when FetchProjects succeeds',
      build: () {
        when(() => mockGitHubService.fetchProjects()).thenAnswer((_) async => tProjects);
        return projectsBloc;
      },
      act: (bloc) => bloc.add(FetchProjects()),
      expect: () => [
        isA<ProjectsLoading>(),
        isA<ProjectsLoaded>(),
      ],
      verify: (_) {
        verify(() => mockGitHubService.fetchProjects()).called(1);
      },
    );

    blocTest<ProjectsBloc, ProjectsState>(
      'loaded state contains the fetched projects merged with manual projects',
      build: () {
        when(() => mockGitHubService.fetchProjects()).thenAnswer((_) async => tProjects);
        return projectsBloc;
      },
      act: (bloc) => bloc.add(FetchProjects()),
      expect: () => [
        isA<ProjectsLoading>(),
        predicate<ProjectsState>((state) {
          if (state is ProjectsLoaded) {
            // tProjects should be in the list (manual projects list is empty in tests)
            return state.projects.any((p) => p.title == 'TestRepo');
          }
          return false;
        }),
      ],
    );

    blocTest<ProjectsBloc, ProjectsState>(
      'emits [ProjectsLoading, ProjectsError] when FetchProjects fails',
      build: () {
        when(() => mockGitHubService.fetchProjects()).thenThrow(Exception('Network error'));
        return projectsBloc;
      },
      act: (bloc) => bloc.add(FetchProjects()),
      expect: () => [
        isA<ProjectsLoading>(),
        isA<ProjectsError>(),
      ],
    );

    blocTest<ProjectsBloc, ProjectsState>(
      'ProjectsError state contains the error message',
      build: () {
        when(() => mockGitHubService.fetchProjects()).thenThrow(Exception('Network error'));
        return projectsBloc;
      },
      act: (bloc) => bloc.add(FetchProjects()),
      expect: () => [
        isA<ProjectsLoading>(),
        predicate<ProjectsState>((state) {
          if (state is ProjectsError) {
            return state.message.contains('Network error');
          }
          return false;
        }),
      ],
    );
  });
}
