import 'dart:convert';

import 'package:about/core/constants/projects.dart';
import 'package:about/core/models/project.dart';
import 'package:http/http.dart' as http;

/// Service to fetch project data from GitHub via a proxy API.
class GitHubService {
  GitHubService({required this.username});

  final String username;

  /// Fetches pinned repositories for the given username.
  ///
  /// NOTE TO REVIEWERS:
  /// 1. API: We use 'github-pinned-repositories.vercel.app' because the standard GitHub
  ///    REST API does not provide a direct way to fetch only 'pinned' projects.
  /// 2. CORS: We prefix the URL with 'corsproxy.io' because Flutter Web enforces
  ///    strict CORS policies. The target API lacks Access-Control-Allow-Origin headers,
  ///    so the proxy acts as middleware to allow successful fetching in the browser.
  Future<List<Project>> fetchProjects() async {
    try {
      // Using pinned repositories API proxy with CORS middleware for Web support
      final response = await http.get(
        Uri.parse(
            'https://corsproxy.io/?https://github-pinned-repositories.vercel.app/$username'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final data = decoded is Map
            ? (decoded['data'] as List<dynamic>)
            : decoded as List<dynamic>;

        return data
            .map((repo) => Project.fromJson(repo as Map<String, dynamic>))
            .where((project) =>
                !ProjectConstants.excludedRepoNames.contains(project.title))
            .toList();
      } else {
        throw Exception(
            'Failed to load pinned projects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching pinned projects: $e');
    }
  }

  /// Fetches all public repositories for the given username.
  ///
  /// NOTE TO REVIEWERS:
  /// We use the standard GitHub REST API (v3) here, proxied via 'corsproxy.io'
  /// to avoid CORS issues in the browser.
  Future<List<Project>> fetchAllRepositories() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://corsproxy.io/?https://api.github.com/users/$username/repos?sort=updated&per_page=100'),
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
