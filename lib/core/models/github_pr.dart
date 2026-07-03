class GitHubPR {
  final int number;
  final String title;
  final String htmlUrl;
  final String repoName;
  final DateTime createdAt;

  GitHubPR({
    required this.number,
    required this.title,
    required this.htmlUrl,
    required this.repoName,
    required this.createdAt,
  });

  factory GitHubPR.fromJson(Map<String, dynamic> json) {
    // repository_url is like "https://api.github.com/repos/owner/repo"
    final repoUrl = json['repository_url'] as String? ?? '';
    final repoParts = repoUrl.split('/');
    final repoName = repoParts.length >= 2 
        ? '${repoParts[repoParts.length - 2]}/${repoParts.last}' 
        : 'Unknown Repo';

    return GitHubPR(
      number: json['number'] ?? 0,
      title: json['title'] ?? 'Unknown',
      htmlUrl: json['html_url'] ?? '',
      repoName: repoName,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}
