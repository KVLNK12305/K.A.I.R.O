import 'package:flutter_test/flutter_test.dart';
import 'package:kairo/core/models/project.dart';
import 'package:kairo/core/models/architecture_artifact.dart';
import 'package:kairo/core/services/mermaid_ingestion_service.dart';
import 'package:kairo/core/services/project_dna_service.dart';
import 'package:kairo/core/services/architecture_drift_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group('Mermaid Ingestion Tests', () {
    test('Parses Mermaid graph direction, nodes, labels, and shapes correctly', () {
      final service = MermaidIngestionService();

      const mmd = '''
graph LR
    CloudTrail[AWS CloudTrail Logs] --> Kafka[Kafka Pipeline]
    Kafka --> Processor[Timeline Engine]
    Processor --> DB[(MongoDB Storage)]
''';

      final parsed = service.parseMermaid(mmd);

      expect(parsed.direction, 'LR');
      expect(parsed.nodes.length, 4);

      final nodeLabels = parsed.nodes.map((n) => n.label).toList();
      expect(nodeLabels, contains('AWS CloudTrail Logs'));
      expect(nodeLabels, contains('Kafka Pipeline'));
      expect(nodeLabels, contains('Timeline Engine'));
      expect(nodeLabels, contains('MongoDB Storage'));

      final dbNode = parsed.nodes.firstWhere((n) => n.id == 'DB');
      expect(dbNode.shape, 'database');

      expect(parsed.edges.length, 3);
      expect(parsed.edges[0].from, 'CloudTrail');
      expect(parsed.edges[0].to, 'Kafka');
      expect(parsed.edges[1].from, 'Kafka');
      expect(parsed.edges[1].to, 'Processor');
      expect(parsed.edges[2].from, 'Processor');
      expect(parsed.edges[2].to, 'DB');
    });

    test('Gracefully parses flowcharts with comments and subgraphs', () {
      final service = MermaidIngestionService();

      const mmd = '''
flowchart TD
    %% Ingestion Pipeline
    A([Client Device]) --> B{Load Balancer}
    B --> C[API Server]
''';

      final parsed = service.parseMermaid(mmd);
      expect(parsed.direction, 'TD');
      expect(parsed.nodes.length, 3);

      final clientNode = parsed.nodes.firstWhere((n) => n.id == 'A');
      expect(clientNode.shape, 'round');

      final lbNode = parsed.nodes.firstWhere((n) => n.id == 'B');
      expect(lbNode.shape, 'diamond');
    });
  });

  group('Project DNA Manifest Ingestion Tests', () {
    test('Parses manifest YAML into Project model capabilities and constraints', () async {
      final service = ProjectDnaService();

      const manifestYaml = '''
project: KlaudTrace
version: "0.4"
status: active

architecture:
  system: .kairo/architecture/system.mmd
  data_flow: .kairo/architecture/data-flow.mmd
  deployment: .kairo/architecture/deployment.mmd
  roadmap: .kairo/architecture/roadmap.mmd

capabilities:
  implemented:
    - cloudtrail_parser
    - identity_tracking
    - timeline_engine
  partial:
    - blast_radius
    - fintech_classifier
  planned:
    - realtime_ingestion
    - kafka_pipeline
  blocked:
    - live_aws_stream

constraints:
  - offline_first
  - no_mock_data

kairo:
  enabled: true
  project_id: klaudtrace
''';

      final project = Project(
        title: 'Initial',
        description: 'Test project',
        repository: 'kushal/klaudtrace',
      );

      // Ingest manifest
      await service.syncProjectDna(
        project: project,
        manifestYaml: manifestYaml,
      );

      expect(project.title, 'KlaudTrace');
      expect(project.manifestVersion, '0.4');
      expect(project.status, 'active');
      expect(project.systemArchitecturePath, '.kairo/architecture/system.mmd');
      expect(project.implementedCapabilities, ['cloudtrail_parser', 'identity_tracking', 'timeline_engine']);
      expect(project.partialCapabilities, ['blast_radius', 'fintech_classifier']);
      expect(project.plannedCapabilities, ['realtime_ingestion', 'kafka_pipeline']);
      expect(project.blockedCapabilities, ['live_aws_stream']);
      expect(project.constraints, ['offline_first', 'no_mock_data']);
    });

    test('Parses inline Mermaid snippet inside manifest YAML directly without .mmd file', () async {
      final service = ProjectDnaService();

      const manifestWithInlineSnippet = '''
project: SnippetProject
version: "1.0"
status: active

architecture:
  system: |
    graph LR
      Ingestion[Raw Logs] --> Queue[Kafka Queue]
      Queue --> Worker[Processing Worker]
      Worker --> Storage[(PostgreSQL)]

capabilities:
  implemented:
    - raw_logs
    - processing_worker
  planned:
    - kafka_queue
''';

      final project = Project(
        title: 'SnippetProject',
        description: 'Testing inline snippets',
      );

      await service.syncProjectDna(
        project: project,
        manifestYaml: manifestWithInlineSnippet,
      );

      expect(project.title, 'SnippetProject');
      expect(project.systemArchitecturePath, 'inline/manifest.yaml');
    });

    test('isMermaidSnippet correctly identifies raw diagram code versus file paths', () {
      expect(ProjectDnaService.isMermaidSnippet('.kairo/architecture/system.mmd'), false);
      expect(ProjectDnaService.isMermaidSnippet('architecture/data-flow.mmd'), false);
      expect(ProjectDnaService.isMermaidSnippet('graph LR\n  A --> B'), true);
      expect(ProjectDnaService.isMermaidSnippet('flowchart TD\n  Start --> Stop'), true);
      expect(ProjectDnaService.isMermaidSnippet('Client --> Server'), true);
    });
  });

  group('Architecture Drift Tests', () {
    test('Detects Intent != Reality discrepancy and classifies as PLANNED / NOT IMPLEMENTED', () async {
      final driftService = ArchitectureDriftService();

      final project = Project(
        title: 'KlaudTrace',
        description: 'Security Lake',
        repository: 'kushal/klaudtrace',
      )
        ..implementedCapabilities = ['cloudtrail_parser', 'timeline_engine']
        ..plannedCapabilities = ['kafka_pipeline'];

      final artifact = ArchitectureArtifact()
        ..projectId = project.id
        ..projectTitle = project.title
        ..architectureType = 'system'
        ..sourcePath = 'inline/snippet'
        ..rawMermaid = 'graph LR\nCloudTrail --> Kafka Pipeline --> Processor'
        ..declaredNodes = ['CloudTrail', 'Kafka Pipeline', 'Processor']
        ..declaredEdges = ['CloudTrail -> Kafka Pipeline', 'Kafka Pipeline -> Processor'];

      final drifts = await driftService.detectDrift(
        project: project,
        artifacts: [artifact],
      );

      expect(drifts.isNotEmpty, true);
      final drift = drifts.first;
      expect(drift.missing, contains('Kafka Pipeline'));
      expect(drift.classification, 'PLANNED / NOT IMPLEMENTED');
    });
  });
}

