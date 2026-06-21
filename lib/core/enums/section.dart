import 'package:flutter/material.dart';

enum Section {
  about('About', Icons.person_outline),
  stats('Stats', Icons.bar_chart),
  experience('Experience', Icons.work_outline),
  skills('Skills', Icons.psychology_outlined),
  projects('Projects', Icons.code),
  testimonials('Testimonials', Icons.chat_bubble_outline),
  contact('Contact', Icons.email_outlined);

  const Section(this.title, this.icon);
  
  final String title;
  final IconData icon;
}
