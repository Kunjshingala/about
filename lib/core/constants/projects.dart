import 'package:about/core/models/project.dart';

class ProjectConstants {
  ProjectConstants._();

  // Appearance
  // Feature flag to toggle between dynamic GitHub projects and static hardcoded ones.
  static const bool isGitHubDynamic = true;

  /// List of GitHub repository names to exclude from the portfolio.
  /// Use the exact repository name as shown in the URL (e.g., 'portfolio-test').
  static const List<String> excludedRepoNames = [
    'WLF-Patterns',
    'Kunjshingala',
    'GetX',
    'Flutter-Counter-Redux',
    'Flutter-Grocery-BloC',
    'Android-Task-1',
    'about',
    'Flutter-Counter-BloC',
    // Add more repository names here to hide them
  ];

  /// Manual projects that you want to highlight or that are not on GitHub.
  /// These will be merged with your GitHub projects when dynamic loading is enabled.
  static final List<Project> manualProjects = [
    // Project(
    //   title: 'BMI Calculator',
    //   description:
    //       'A BMI calculator application (Android/iOS) that calculates Body Mass Index from user input with a clean and intuitive UI for a smooth user experience.',
    //   tags: ['Flutter', 'Material Design'],
    //   url: bmiCalculatorUrl,
    //   icon: Icons.calculate,
    // ),
    // Project(
    //   title: 'Weather App',
    //   description:
    //       'A weather mobile application (Android/iOS) that displays real-time conditions based on city name or user location using OpenWeather One Call API 3.0.',
    //   tags: ['Flutter', 'Material Design', 'API Integration'],
    //   url: weatherAppUrl,
    //   icon: Icons.wb_sunny,
    // ),
  ];
}
