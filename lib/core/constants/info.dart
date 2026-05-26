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
      'I build mobile apps that actually ship.\n\n'
      'Over the past two years at an agency, I\'ve worked on 40+ production apps across delivery, '
      'transport, healthcare, and home services. Most projects have tight deadlines and zero room '
      'for over-engineering — which taught me to write code that\'s clean enough to maintain, '
      'modular enough to reuse, and simple enough to hand off.\n\n'
      'I got into Flutter because I wanted to solve real problems without rebuilding everything twice. '
      'Now I\'m the person my team calls when something needs to work across Android, iOS, and '
      'actually make it through App Store review on the first try.\n\n'
      'I care about architecture that scales, but I care more about shipping something people can use.';

  // Contact Information
  static const String email = 'kunjshingala.p@gmail.com';
  static const String emailAddress = 'mailto:$email';
  static const String location = 'Rajkot, Gujarat, India';

  // Social Media Links
  static const String githubUrl = 'https://github.com/Kunjshingala';
  static const String linkedinUrl = 'https://www.linkedin.com/in/kunjshingala03/';
  static const String twitterUrl = 'https://twitter.com/kunjshingala';

  // Social Media Visibility Flags
  static const bool showTwitter = false;
  static const bool showGithub = true;
  static const bool showLinkedIn = true;

  // Section Visibility Flags
  static const bool showTestimonials = false;

  // Year for copyright
  static const String copyrightYear = '2026';
  static int currentYear = DateTime.now().year;

  // Resume/CV URLs
  static const String resumeDownloadUrl = 'https://drive.google.com/file/d/1dCymZgFFZfs_5U8R1QH7jD_E9rqZks3L';
  static const String resumeViewUrl = 'https://drive.google.com/file/d/1dCymZgFFZfs_5U8R1QH7jD_E9rqZks3L/view';
}
