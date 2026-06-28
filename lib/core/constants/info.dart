class AppInfo {
  AppInfo._();

  // Name
  static const String firstName = 'Kunj';
  static const String lastName = 'Shingala';
  static const String fullName = '$firstName $lastName';

  // Professional Title
  static const String jobTitle = 'Application Developer';

  // Bio/About
  static const String bio =
      '''I build mobile apps that actually ship.\n\nOver the past two years at an agency, I've worked on 40+ production apps across delivery, transport, healthcare, and home services. Most projects have tight deadlines and zero room for over-engineering - which taught me to write code that's clean enough to maintain, modular enough to reuse, and simple enough to hand off.\n\nI use Flutter because, yeah it easy to solve real problems in one shot without rebuilding everything twice, unless it needs has specific reason to move native.\n\nI believe in architecture that scales, but I care more about shipping something people can use.''';

  static const String whyFlutterText =
      '''This portfolio is built with Flutter Web - not because it's the easiest choice, but because it's the best way to learn.\n\nI wanted hands-on experience with Flutter's web target beyond just reading docs. This page gave me a sandbox to experiment. I learned how responsive design works across desktop browsers, why some animations stutter on web but not mobile, and how to optimize bundle size when you can't just tell users to "download the app."\n\nBuilding this forced me to deal with:\n• Responsive design across desktop breakpoints\n• Browser-specific differences\n• Bundle size optimization for web\n• Routing in a web context\n• Performance differences between mobile and browser runtimes\n\nIt's also proof that I don't just build for Android and iOS. this page is experiment for Flutter on the web.\n\nCould I have built this faster with HTML? Absolutely. But I wouldn't have learned nearly as much.''';

  // Contact Information
  static const String email = 'kunjshingala.p@gmail.com';
  static const String emailAddress = 'mailto:$email';
  static const String location = 'Rajkot, Gujarat, India';

  // Social Media Links
  static const String githubUrl = 'https://github.com/Kunjshingala';
  static const String linkedinUrl =
      'https://www.linkedin.com/in/kunjshingala03/';
  static const String twitterUrl = 'https://x.com/kunj_shingala0';

  // Social Media Visibility Flags
  static const bool showTwitter = true;
  static const bool showGithub = true;
  static const bool showLinkedIn = true;

  // Section Visibility Flags
  static const bool showTestimonials = false;
  static const bool showContact = false;

  // Year for copyright
  static const String copyrightYear = '2026';
  static int currentYear = DateTime.now().year;

  // Resume/CV URLs
  static const String resumeDownloadUrl =
      'https://drive.google.com/file/d/1dCymZgFFZfs_5U8R1QH7jD_E9rqZks3L';
  static const String resumeViewUrl =
      'https://drive.google.com/file/d/1dCymZgFFZfs_5U8R1QH7jD_E9rqZks3L/view';
}
