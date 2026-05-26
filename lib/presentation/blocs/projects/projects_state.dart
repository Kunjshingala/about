import 'package:about/core/models/project.dart';
import 'package:equatable/equatable.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object> get props => [];
}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  const ProjectsLoaded(this.projects);

  final List<Project> projects;

  @override
  List<Object> get props => [projects];
}

class ProjectsError extends ProjectsState {
  const ProjectsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
