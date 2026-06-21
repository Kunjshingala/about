import 'package:about/core/models/project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Project.fromJson', () {
    test('parses standard GitHub REST API format (html_url, string language)', () {
      final json = {
        'name': 'my-app',
        'description': 'A great app',
        'html_url': 'https://github.com/user/my-app',
        'language': 'Dart',
      };

      final project = Project.fromJson(json);

      expect(project.title, 'my-app');
      expect(project.description, 'A great app');
      expect(project.url, 'https://github.com/user/my-app');
      expect(project.tags, ['Dart']);
      expect(project.icon, Icons.code);
    });

    test('parses Pinned Repositories API format (repo, map language)', () {
      final json = {
        'name': 'weather-app',
        'description': 'A weather app',
        'repo': 'https://github.com/user/weather-app',
        'language': {'name': 'Dart', 'color': '#00B4AB'},
      };

      final project = Project.fromJson(json);

      expect(project.title, 'weather-app');
      expect(project.url, 'https://github.com/user/weather-app');
      expect(project.tags, ['Dart']);
      expect(project.icon, Icons.wb_sunny);
    });

    test('uses default description when description is null', () {
      final json = {
        'name': 'unnamed-repo',
        'description': null,
        'html_url': 'https://github.com/user/unnamed-repo',
        'language': null,
      };

      final project = Project.fromJson(json);

      expect(project.description, 'No description available.');
      expect(project.tags, isEmpty);
    });

    test('assigns calculator icon for bmi project', () {
      final json = {
        'name': 'BMI-Calculator',
        'description': 'Calculates BMI',
        'html_url': 'https://github.com/user/BMI-Calculator',
        'language': 'Dart',
      };

      final project = Project.fromJson(json);

      expect(project.icon, Icons.calculate);
    });

    test('assigns person icon for portfolio project', () {
      final json = {
        'name': 'portfolio-site',
        'description': 'My portfolio',
        'html_url': 'https://github.com/user/portfolio-site',
        'language': 'Dart',
      };

      final project = Project.fromJson(json);

      expect(project.icon, Icons.person);
    });

    test('falls back to html_url when repo key is absent', () {
      final json = {
        'name': 'test-project',
        'description': 'Test',
        'html_url': 'https://github.com/user/test-project',
      };

      final project = Project.fromJson(json);

      expect(project.url, 'https://github.com/user/test-project');
    });

    test('url is empty string when both html_url and repo are missing', () {
      final json = {
        'name': 'no-url-project',
        'description': 'No URL',
      };

      final project = Project.fromJson(json);

      expect(project.url, isEmpty);
    });
  });
}
