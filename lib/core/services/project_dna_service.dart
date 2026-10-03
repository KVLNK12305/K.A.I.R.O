import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaml/yaml.dart';
import '../models/project.dart';
import 'mermaid_ingestion_service.dart';
import 'architecture_drift_service.dart';

class ProjectDnaService {
  final Isar? isar;
  final MermaidIngestionService mermaidService;
  final ArchitectureDriftService driftService;

  ProjectDnaService([this.isar])
      : mermaidService = MermaidIngestionService(isar),
        driftService = ArchitectureDriftService(isar);

  /// Registers a GitHub repository or project directory as an explicit K.A.I.R.O. project.
  Future<Project> registerProject({
    required String title,
    required String description,
    required String repository,
    String branch = 'main',
  }) async {
    Project? existing;
    if (isar != null) {
      existing = await isar!.projects
          .filter()
          .titleEqualTo(title)
          .or()
          .repositoryEqualTo(repository)
          .findFirst();
    }

    final project = existing ?? Project(
      title: title,
      description: description,
      repository: repository,
      branch: branch,
      isRegisteredKairo: true,
    );

    project.title = title;
    project.description = description;
    project.repository = repository;
    project.branch = branch;
    project.isRegisteredKairo = true;

    if (isar != null) {
      await isar!.writeTxn(() async {
        await isar!.projects.put(project);
      });
    }

    return project;
  }

  /// Ingests `.kairo/manifest.yaml` and related architecture artifacts.
  /// Works both offline (with provided content or raw Mermaid snippets) and online (via GitHub API).
  Future<Project> syncProjectDna({
    required Project project,
    String? manifestYaml,
    Map<String, String>? mmdFiles,
    String? decisionsMd,
  }) async {
    String? rawManifest = manifestYaml;
    Map<String, String> architectureFiles = Map<String, String>.from(mmdFiles ?? {});
    String? rawDecisions = decisionsMd;
    final inlineSnippets = <String, String>{};

    // If manifest was not provided directly and repository is configured, attempt to fetch via GitHub
    if ((rawManifest == null || rawManifest.trim().isEmpty) && project.repository != null && project.repository!.contains('/')) {
      try {
        final fetched = await _fetchFromGitHub(project.repository!, project.branch, '.kairo/manifest.yaml');
        if (fetched != null) {
          rawManifest = fetched;
        }
      } catch (e) {
        debugPrint("Notice: Could not fetch manifest from GitHub ($e). Continuing with offline/stored state.");
      }
    }

    if (rawManifest != null && rawManifest.trim().isNotEmpty) {
      _parseAndUpdateManifest(project, rawManifest, inlineSnippets);
    }

    // Merge any inline snippets defined in manifest
    architectureFiles.addAll(inlineSnippets);

    // Ingest architecture files or snippets
    final archPaths = <String, String>{
      if (project.systemArchitecturePath != null) 'system': project.systemArchitecturePath!,
      if (project.dataFlowArchitecturePath != null) 'data_flow': project.dataFlowArchitecturePath!,
      if (project.deploymentArchitecturePath != null) 'deployment': project.deploymentArchitecturePath!,
      if (project.roadmapArchitecturePath != null) 'roadmap': project.roadmapArchitecturePath!,
    };

    // If no paths specified in manifest and no snippets provided, default standard paths
    if (archPaths.isEmpty && architectureFiles.isEmpty) {
      archPaths['system'] = '.kairo/architecture/system.mmd';
      archPaths['data_flow'] = '.kairo/architecture/data-flow.mmd';
      archPaths['deployment'] = '.kairo/architecture/deployment.mmd';
      archPaths['roadmap'] = '.kairo/architecture/roadmap.mmd';
    }

    final allTypes = {...archPaths.keys, ...architectureFiles.keys};

    for (final type in allTypes) {
      final path = archPaths[type] ?? 'inline/snippet';
      String? mmdContent = architectureFiles[type] ?? architectureFiles[path];

      // If not provided in map and repository is configured, attempt remote fetch (unless it is an inline snippet)
      if ((mmdContent == null || mmdContent.isEmpty) &&
          !path.startsWith('inline') &&
          project.repository != null &&
          project.repository!.contains('/')) {
        try {
          mmdContent = await _fetchFromGitHub(project.repository!, project.branch, path);
        } catch (e) {
          debugPrint("Notice: Could not fetch $path from GitHub: $e");
        }
      }

      if (mmdContent != null && mmdContent.trim().isNotEmpty) {
        await mermaidService.ingestArtifact(
          projectId: project.id,
          projectTitle: project.title,
          architectureType: type,
          sourcePath: path,
          rawMermaid: mmdContent,
        );
      }
    }

    // Ingest decisions.md if available
    if ((rawDecisions == null || rawDecisions.isEmpty) && project.repository != null && project.repository!.contains('/')) {
      try {
        rawDecisions = await _fetchFromGitHub(project.repository!, project.branch, '.kairo/decisions.md');
      } catch (_) {}
    }
    if (rawDecisions != null) {
      project.decisionsMarkdown = rawDecisions;
    }

    project.lastSyncedAt = DateTime.now();

    if (isar != null) {
      await isar!.writeTxn(() async {
        await isar!.projects.put(project);
      });
    }

    // Evaluate architecture drift: Intent vs Reality
    await driftService.detectDrift(project: project);

    return project;
  }

  /// Determines if a string is a raw Mermaid diagram snippet rather than a file path.
  static bool isMermaidSnippet(String text) {
    final trimmed = text.trim();
    if (trimmed.contains('\n')) return true;
    final lower = trimmed.toLowerCase();
    return lower.startsWith('graph ') ||
        lower.startsWith('flowchart ') ||
        lower.startsWith('sequencediagram') ||
        lower.startsWith('statediagram') ||
        lower.startsWith('classdiagram') ||
        lower.startsWith('erdiagram') ||
        lower.startsWith('gitgraph') ||
        lower.startsWith('pie') ||
        lower.contains('-->') ||
        lower.contains('->');
  }

  void _parseAndUpdateManifest(Project project, String yamlStr, [Map<String, String>? inlineSnippets]) {
    try {
      final doc = loadYaml(yamlStr);
      if (doc is! Map) return;

      if (doc['project'] != null) {
        project.title = doc['project'].toString();
      }
      if (doc['version'] != null) {
        project.manifestVersion = doc['version'].toString();
      }
      if (doc['status'] != null) {
        project.status = doc['status'].toString();
      }

      // Architecture paths or inline snippets
      final arch = doc['architecture'];
      if (arch is Map) {
        void processArchEntry(String key, void Function(String?) setPath) {
          final val = arch[key]?.toString();
          if (val == null) return;
          if (isMermaidSnippet(val)) {
            inlineSnippets?[key] = val;
            setPath('inline/manifest.yaml');
          } else {
            setPath(val);
          }
        }

        processArchEntry('system', (p) => project.systemArchitecturePath = p);
        processArchEntry('data_flow', (p) => project.dataFlowArchitecturePath = p);
        processArchEntry('deployment', (p) => project.deploymentArchitecturePath = p);
        processArchEntry('roadmap', (p) => project.roadmapArchitecturePath = p);
      }

      // Capabilities
      final caps = doc['capabilities'];
      if (caps is Map) {
        project.implementedCapabilities = _extractStringList(caps['implemented']);
        project.partialCapabilities = _extractStringList(caps['partial']);
        project.plannedCapabilities = _extractStringList(caps['planned']);
        project.blockedCapabilities = _extractStringList(caps['blocked']);
      }

      // Constraints
      final constraints = doc['constraints'];
      if (constraints is List) {
        project.constraints = _extractStringList(constraints);
      }
    } catch (e) {
      debugPrint("Error parsing manifest YAML: $e");
    }
  }

  List<String> _extractStringList(dynamic val) {
    if (val is List) {
      return val.map((e) => e.toString().trim()).where((s) => s.isNotEmpty).toList();
    }
    return [];
  }

  Future<String?> _fetchFromGitHub(String repo, String branch, String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('github_token') ?? '';

    final cleanPath = filePath.startsWith('/') ? filePath.substring(1) : filePath;
    final url = Uri.parse('https://api.github.com/repos/$repo/contents/$cleanPath?ref=$branch');

    final headers = <String, String>{
      'Accept': 'application/vnd.github.v3.raw',
    };
    if (token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final resp = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
    if (resp.statusCode == 200) {
      return resp.body;
    } else if (resp.statusCode == 404) {
      // Try raw.githubusercontent.com fallback
      final rawUrl = Uri.parse('https://raw.githubusercontent.com/$repo/$branch/$cleanPath');
      final rawResp = await http.get(rawUrl).timeout(const Duration(seconds: 10));
      if (rawResp.statusCode == 200) return rawResp.body;
    }
    return null;
  }
}
