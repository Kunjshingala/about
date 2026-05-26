import 'package:about/core/constants/projects.dart';
import 'package:about/core/services/github_service.dart';
import 'package:about/presentation/blocs/projects/projects_event.dart';
import 'package:about/presentation/blocs/projects/projects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc({required this.gitHubService}) : super(ProjectsInitial()) {
    on<FetchProjects>((event, emit) async {
      emit(ProjectsLoading());
      try {
        final projects = await gitHubService.fetchProjects();
        // Merge manual projects with dynamic ones
        final combined = [
          ...projects,
          ...ProjectConstants.manualProjects,
        ];
        emit(ProjectsLoaded(combined));
      } catch (e) {
        emit(ProjectsError(e.toString()));
      }
    });
  }

  final GitHubService gitHubService;
}
