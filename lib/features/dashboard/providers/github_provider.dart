import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/github_pr.dart';
import '../../../core/services/github_service.dart';

final githubServiceProvider = Provider<GitHubService>((ref) {
  return GitHubService();
});

final githubPRsProvider = FutureProvider<List<GitHubPR>>((ref) async {
  final service = ref.watch(githubServiceProvider);
  return await service.fetchActivePRs();
});
