import 'dart:convert';

import 'package:about/core/constants/projects.dart';
import 'package:about/core/models/project.dart';
import 'package:http/http.dart' as http;

/// Service to fetch project data from the GitHub REST API.
class GitHubService {
  GitHubService({required this.username});

  final String username;

  /// Fetches the featured repositories for the given username.
  ///
  /// NOTE TO REVIEWERS:
  /// The REST API has no endpoint for 'pinned' repositories (that needs the
  /// GraphQL API and an auth token), and the third-party pinned-repos API we
  /// used before has no CORS headers, so it needed a CORS proxy that has since
  /// stopped serving anonymous requests. Instead we fetch the public repos
  /// directly (api.github.com sends `Access-Control-Allow-Origin: *`) and keep
  /// the ones listed in [ProjectConstants.featuredRepoNames], in that order.
  /// If that list is empty, all public repositories are returned.
  Future<List<Project>> fetchProjects() async {
    final projects = await fetchAllRepositories();
    const featured = ProjectConstants.featuredRepoNames;
    if (featured.isEmpty) return projects;

    final byName = {for (final project in projects) project.title: project};
    return [
      for (final name in featured)
        if (byName[name] != null) byName[name]!,
    ];
  }

  /// Fetches all public, non-fork repositories for the given username.
  Future<List<Project>> fetchAllRepositories() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.github.com/users/$username/repos?sort=updated&per_page=100'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;

        // Filter out forks and map to Project model
        return data
            .where((repo) => repo['fork'] == false)
            .map((repo) => Project.fromJson(repo as Map<String, dynamic>))
            .where((project) =>
                !ProjectConstants.excludedRepoNames.contains(project.title))
            .toList();
      } else {
        throw Exception(
            'Failed to load all repositories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching all repositories: $e');
    }
  }
}
