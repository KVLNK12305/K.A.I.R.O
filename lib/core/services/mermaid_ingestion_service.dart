import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../models/architecture_artifact.dart';

class MermaidNode {
  final String id;
  final String label;
  final String shape; // 'box', 'round', 'database', 'circle', 'default'

  const MermaidNode({
    required this.id,
    required this.label,
    this.shape = 'box',
  });
}

class MermaidEdge {
  final String from;
  final String to;
  final String? label;

  const MermaidEdge({
    required this.from,
    required this.to,
    this.label,
  });
}

class ParsedMermaid {
  final String direction; // 'TD', 'LR', 'TB', etc.
  final List<MermaidNode> nodes;
  final List<MermaidEdge> edges;
  final String rawSource;

  const ParsedMermaid({
    this.direction = 'TD',
    required this.nodes,
    required this.edges,
    required this.rawSource,
  });
}

class MermaidIngestionService {
  final Isar? isar;
  MermaidIngestionService([this.isar]);

  /// Parses raw Mermaid `.mmd` syntax and extracts high-level structural metadata.
  ParsedMermaid parseMermaid(String rawSource) {
    String direction = 'TD';
    final Map<String, MermaidNode> nodeMap = {};
    final List<MermaidEdge> edges = [];

    final lines = rawSource.split('\n');

    final dirRegex = RegExp(r'^\s*(?:graph|flowchart)\s+([A-Za-z]+)', caseSensitive: false);
    // Regex for edge connections like: A --> B, A["label"] -->|desc| B[(db)], A --> B --> C
    final edgeRegex = RegExp(r'([A-Za-z0-9_\-\.]+)(?:\[[^\]]*\]|\([^\)]*\)|\{[^\}]*\}|\(\([^\)]*\)\))?\s*(?:--[A-Za-z0-9_\-\.\s]*-->|-->|-.->|==>)\s*(?:\|[^\|]*\|\s*)?([A-Za-z0-9_\-\.]+)(?:\[[^\]]*\]|\([^\)]*\)|\{[^\}]*\}|\(\([^\)]*\)\))?');
    // Regex for node definitions: NodeId[(Database)], NodeId([Rounded]), NodeId((Circle)), NodeId{{Hex}}, NodeId{Diamond}, NodeId[Box], NodeId(Round)
    final nodeDefRegex = RegExp(r'([A-Za-z0-9_\-\.]+)\s*(\[\(|\(\[|\(\(|\{\{|\[|\{|\()([^\n\]\}\)]+?)(\)\]|\]\)|\)\)|\}\}|\]|\}|\))');

    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('%%')) continue; // Skip comments and empty lines

      // 1. Detect graph direction
      final dirMatch = dirRegex.firstMatch(line);
      if (dirMatch != null) {
        direction = dirMatch.group(1)?.toUpperCase() ?? 'TD';
        continue;
      }

      // 2. Extract node definitions with custom labels
      for (final match in nodeDefRegex.allMatches(line)) {
        final id = match.group(1)!.trim();
        final openBracket = match.group(2)!;
        var label = match.group(3)!.trim();
        // Remove surrounding quotes if present
        if ((label.startsWith('"') && label.endsWith('"')) || (label.startsWith("'") && label.endsWith("'"))) {
          label = label.substring(1, label.length - 1);
        }

        String shape = 'box';
        if (openBracket.contains('[(')) {
          shape = 'database';
        } else if (openBracket.contains('([')) {
          shape = 'round';
        } else if (openBracket.contains('{')) {
          shape = 'diamond';
        } else if (openBracket.contains('((')) {
          shape = 'circle';
        }

        nodeMap[id] = MermaidNode(id: id, label: label.isNotEmpty ? label : id, shape: shape);
      }

      // 3. Extract edges
      for (final match in edgeRegex.allMatches(line)) {
        final fromId = match.group(1)!.trim();
        final toId = match.group(2)!.trim();

        // If nodes haven't been explicitly declared with label, add default
        nodeMap.putIfAbsent(fromId, () => MermaidNode(id: fromId, label: fromId));
        nodeMap.putIfAbsent(toId, () => MermaidNode(id: toId, label: toId));

        edges.add(MermaidEdge(from: fromId, to: toId));
      }
    }

    return ParsedMermaid(
      direction: direction,
      nodes: nodeMap.values.toList(),
      edges: edges,
      rawSource: rawSource,
    );
  }

  /// Stores or updates an architecture artifact for a project.
  Future<ArchitectureArtifact> ingestArtifact({
    required int projectId,
    required String projectTitle,
    required String architectureType,
    required String sourcePath,
    required String rawMermaid,
  }) async {
    final parsed = parseMermaid(rawMermaid);
    ArchitectureArtifact? existing;
    if (isar != null) {
      existing = await isar!.architectureArtifacts
          .filter()
          .projectIdEqualTo(projectId)
          .and()
          .architectureTypeEqualTo(architectureType)
          .findFirst();
    }

    final artifact = existing ?? ArchitectureArtifact()
      ..projectId = projectId
      ..projectTitle = projectTitle
      ..architectureType = architectureType;

    artifact.sourcePath = sourcePath;
    artifact.rawMermaid = rawMermaid;
    artifact.declaredNodes = parsed.nodes.map((n) => n.label.isNotEmpty ? n.label : n.id).toList();
    artifact.declaredEdges = parsed.edges.map((e) => '${e.from} -> ${e.to}').toList();
    artifact.lastSyncedAt = DateTime.now();

    if (isar != null) {
      await isar!.writeTxn(() async {
        await isar!.architectureArtifacts.put(artifact);
      });
    }

    debugPrint("Ingested Architecture Artifact: [$architectureType] for $projectTitle (${parsed.nodes.length} nodes, ${parsed.edges.length} edges)");
    return artifact;
  }
}
