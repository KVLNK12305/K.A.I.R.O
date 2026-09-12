import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/github_pr.dart';
import '../services/github_service.dart';

final githubServiceProvider = Provider<GitHubService>((ref) {
  return GitHubService();
});

final githubPRsProvider = FutureProvider<List<GitHubPR>>((ref) async {
  final service = ref.watch(githubServiceProvider);
  return await service.fetchActivePRs();
});
