import 'package:about/core/constants/info.dart';
import 'package:about/core/constants/projects.dart';
import 'package:about/core/navigation/app_router.dart';
import 'package:about/core/services/github_service.dart';
import 'package:about/core/theme/app_theme.dart';
import 'package:about/presentation/blocs/projects/projects_bloc.dart';
import 'package:about/presentation/blocs/projects/projects_event.dart';
import 'package:about/presentation/blocs/resume/resume_bloc.dart';
import 'package:about/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => ResumeBloc()),
        BlocProvider(
          create: (context) {
            final bloc = ProjectsBloc(
              gitHubService:
                  GitHubService(username: AppInfo.githubUrl.split('/').last),
            );
            if (ProjectConstants.isGitHubDynamic) {
              bloc.add(FetchProjects());
            }
            return bloc;
          },
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppInfo.fullName,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
