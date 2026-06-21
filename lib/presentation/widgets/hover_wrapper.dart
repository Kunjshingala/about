import 'package:about/presentation/blocs/hover/hover_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HoverWrapper extends StatelessWidget {
  const HoverWrapper({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, bool isHovered) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HoverCubit(),
      child: Builder(
        builder: (context) {
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => context.read<HoverCubit>().setHovered(true),
            onExit: (_) => context.read<HoverCubit>().setHovered(false),
            child: BlocBuilder<HoverCubit, bool>(
              builder: (context, isHovered) {
                return builder(context, isHovered);
              },
            ),
          );
        },
      ),
    );
  }
}
