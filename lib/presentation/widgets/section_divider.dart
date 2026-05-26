import 'package:about/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      width: 2,
      color: context.colors.border,
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}
