import 'package:about/presentation/blocs/hover/hover_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HoverCubit', () {
    late HoverCubit hoverCubit;

    setUp(() {
      hoverCubit = HoverCubit();
    });

    tearDown(() {
      hoverCubit.close();
    });

    test('initial state is false (not hovered)', () {
      expect(hoverCubit.state, isFalse);
    });

    blocTest<HoverCubit, bool>(
      'emits [true] when setHovered(true) is called',
      build: () => hoverCubit,
      act: (cubit) => cubit.setHovered(true),
      expect: () => [true],
    );

    blocTest<HoverCubit, bool>(
      'emits [false] when setHovered(false) is called after true',
      build: () => hoverCubit,
      seed: () => true,
      act: (cubit) => cubit.setHovered(false),
      expect: () => [false],
    );

    blocTest<HoverCubit, bool>(
      'emits [true, false] when setHovered is toggled',
      build: () => hoverCubit,
      act: (cubit) {
        cubit..setHovered(true)
        ..setHovered(false);
      },
      expect: () => [true, false],
    );
  });
}
