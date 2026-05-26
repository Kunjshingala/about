import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:about/core/theme/app_colors.dart';
import 'package:about/presentation/blocs/theme/theme_cubit.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return IconButton(
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            size: 20,
          ),
          color: context.colors.textPrimary,
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme(context);
          },
        );
      },
    );
  }
}
