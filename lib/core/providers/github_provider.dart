import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/github_pr.dart';
import '../services/github_service.dart';

final githubServiceProvider = Provider<GitHubService>((ref) {
  return GitHubService();
});

final hasGitHubTokenProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('github_token') ?? '';
  return token.trim().isNotEmpty;
});

final githubPRsProvider = FutureProvider<List<GitHubPR>>((ref) async {
  final service = ref.watch(githubServiceProvider);
  return await service.fetchActivePRs();
});

final userRepositoriesProvider = FutureProvider<List<GitHubRepoItem>>((ref) async {
  final service = ref.watch(githubServiceProvider);
  return await service.fetchUserRepositories();
});
