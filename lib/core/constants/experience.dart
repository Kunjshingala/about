import 'package:about/core/models/experience.dart';

class ExperienceInfo {
  ExperienceInfo._();

  static const List<Experience> experiences = [
    Experience(
      title: 'Flutter Developer',
      company: 'White Label Fox',
      date: 'Jul 2024 — Present',
      bulletPoints: [
        'Built 3–4 apps per month across delivery, transport, healthcare, and home services — learning to ship fast without writing throwaway code.',
        'Designed the Step Module for a 4-step carpooling flow; it\'s since been reused in 9-step and 14-step products because it was built to be copied, not customized.',
        'Built Deep Linking as a plug-and-play module — now integrated into 3+ client projects with zero rework.',
        'Own the full App Store release pipeline end-to-end; apps pass review on the first try 80% of the time.',
        'Shipped a 3-app medicine delivery suite solo in 8 weeks, from architecture to deployment.',
        'Pioneered live notifications for real-time order tracking that work on both iOS and Android lock screens.',
        'Touched 40+ production apps total, making architectural decisions that survive tight deadlines and changing requirements.',
      ],
      tags: [
        'Flutter',
        'Dart',
        'BLoC',
        'RxDart',
        'Hive',
        'Firebase',
        'GoRouter',
        'GetIt',
        'WebSocket',
        'Platform Channels',
        'Google Maps',
        'Payment Gateways',
      ],
    ),
    Experience(
      title: 'Flutter Developer Intern',
      company: 'White Label Fox',
      date: 'Nov 2023 — Jun 2024',
      bulletPoints: [
        'Contributed to 2 production apps within 6 months — going from classroom Dart to code that got merged into client projects.',
        'Built Firebase backends from scratch — Auth, Firestore, Storage, and FCM — learning the difference between demo code and production code.',
        'Learned state management, HTTP internals, and debugging workflows from senior developers through hands-on mentorship, not hand-holding.',
        'Earned a full-time hire by the end of the internship — stopped writing intern code and started writing code that shipped to real users.',
      ],
      tags: ['Flutter', 'Dart', 'Firebase', 'REST API', 'Dio/HTTP'],
    ),
  ];
}
