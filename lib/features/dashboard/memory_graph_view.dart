import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../core/models/memory_edge.dart';
import '../../main.dart';
import '../../core/services/graph_service.dart';
import '../../core/models/task.dart';
import '../../core/models/project.dart';
import '../../core/models/idea.dart';

class MemoryGraphView extends StatefulWidget {
  final String initialCollection;
  final int initialId;
  final String initialTitle;

  const MemoryGraphView({
    super.key,
    required this.initialCollection,
    required this.initialId,
    required this.initialTitle,
  });

  @override
  State<MemoryGraphView> createState() => _MemoryGraphViewState();
}

class _MemoryGraphViewState extends State<MemoryGraphView> {
  late GraphService _graphService;
  
  // Navigation stack for the graph
  final List<Map<String, dynamic>> _history = [];
  
  String? _currentCollection;
  int? _currentId;
  String? _currentTitle;

  List<MemoryEdge> _incomingEdges = [];
  List<MemoryEdge> _outgoingEdges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _graphService = GraphService(isar);
    _navigateToNode(
      collection: widget.initialCollection,
      id: widget.initialId,
      title: widget.initialTitle,
      isBack: false,
    );
  }

  Future<void> _navigateToNode({
    required String collection,
    required int id,
    required String title,
    bool isBack = false,
  }) async {
    setState(() => _isLoading = true);

    if (!isBack && _currentCollection != null) {
      _history.add({
        'collection': _currentCollection,
        'id': _currentId,
        'title': _currentTitle,
      });
    }

    _currentCollection = collection;
    _currentId = id;
    _currentTitle = title;

    final edges = await _graphService.getEdgesForNode(collection, id);

    setState(() {
      _incomingEdges = edges
          .where((e) => e.targetCollection == collection && e.targetId == id)
          .toList();
      _outgoingEdges = edges
          .where((e) => e.sourceCollection == collection && e.sourceId == id)
          .toList();
      _isLoading = false;
    });
  }

  void _goBack() {
    if (_history.isEmpty) {
      Navigator.pop(context);
      return;
    }
    final prev = _history.removeLast();
    _navigateToNode(
      collection: prev['collection'],
      id: prev['id'],
      title: prev['title'],
      isBack: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final edgePadding = screenWidth < 360 ? 12.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Memory Graph'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 600;

                final incomingList = _buildEdgeList(
                  title: 'Influenced By (Incoming)',
                  edges: _incomingEdges,
                  isIncoming: true,
                  isScrollable: isWide,
                );

                final outgoingList = _buildEdgeList(
                  title: 'Leads To (Outgoing)',
                  edges: _outgoingEdges,
                  isIncoming: false,
                  isScrollable: isWide,
                );

                Widget content;
                if (isWide) {
                  content = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCurrentNodeFocus(constraints.maxWidth),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: incomingList),
                            const SizedBox(width: 16),
                            Expanded(child: outgoingList),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  content = SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCurrentNodeFocus(constraints.maxWidth),
                        const SizedBox(height: 24),
                        incomingList,
                        const SizedBox(height: 24),
                        outgoingList,
                        // Extra bottom space so FAB doesn't cover content
                        const SizedBox(height: 80),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: EdgeInsets.all(edgePadding),
                  child: content,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_currentCollection == null || _currentId == null) return;
          final result = await showDialog<bool>(
            context: context,
            builder: (ctx) => _AddConnectionDialog(
              currentCollection: _currentCollection!,
              currentId: _currentId!,
              currentTitle: _currentTitle!,
            ),
          );
          if (result == true) {
            // Refresh without adding to history
            _navigateToNode(
              collection: _currentCollection!,
              id: _currentId!,
              title: _currentTitle!,
              isBack: true,
            );
          }
        },
        child: const Icon(Icons.add_link),
      ),
    );
  }

  Widget _buildCurrentNodeFocus(double availableWidth) {
    final isCompact = availableWidth < 360;
    final cardPadding = isCompact ? 16.0 : 24.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (_currentCollection ?? '').toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.5,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _currentTitle ?? '',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isCompact ? 18 : null,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEdgeList({
    required String title,
    required List<MemoryEdge> edges,
    required bool isIncoming,
    required bool isScrollable,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
        ),
        const Divider(),
        isScrollable
            ? Expanded(child: _buildListView(edges, isIncoming))
            : _buildListView(edges, isIncoming),
      ],
    );
  }

  Widget _buildListView(List<MemoryEdge> edges, bool isIncoming) {
    if (edges.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: Text(
            'No connections',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: edges.length,
      itemBuilder: (context, index) {
        final edge = edges[index];

        final linkedCollection =
            isIncoming ? edge.sourceCollection : edge.targetCollection;
        final linkedId = isIncoming ? edge.sourceId : edge.targetId;
        final linkedTitle =
            isIncoming ? edge.sourceTitle : edge.targetTitle;
        final relation = edge.relationType;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(linkedTitle),
            subtitle: Text('$linkedCollection • $relation'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigateToNode(
                collection: linkedCollection,
                id: linkedId,
                title: linkedTitle,
              );
            },
          ),
        );
      },
    );
  }
}

class SearchResult {
  final String collection;
  final int id;
  final String title;
  SearchResult(this.collection, this.id, this.title);
}

class _AddConnectionDialog extends StatefulWidget {
  final String currentCollection;
  final int currentId;
  final String currentTitle;

  const _AddConnectionDialog({
    required this.currentCollection,
    required this.currentId,
    required this.currentTitle,
  });

  @override
  State<_AddConnectionDialog> createState() => _AddConnectionDialogState();
}

class _AddConnectionDialogState extends State<_AddConnectionDialog> {
  final _searchController = TextEditingController();
  final _relationController = TextEditingController(text: 'relates_to');
  
  bool _isIncoming = false; // False = Current node Leads To target; True = Target Leads To Current node
  List<SearchResult> _results = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    final term = query.trim().toLowerCase();
    final results = <SearchResult>[];

    // Search Tasks
    final tasks = await isar.tasks.where().findAll();
    results.addAll(tasks
        .where((t) => t.title.toLowerCase().contains(term))
        .map((t) => SearchResult('Task', t.id, t.title)));

    // Search Projects
    final projects = await isar.projects.where().findAll();
    results.addAll(projects
        .where((t) => t.title.toLowerCase().contains(term))
        .map((t) => SearchResult('Project', t.id, t.title)));

    // Search Ideas
    final ideas = await isar.ideas.where().findAll();
    results.addAll(ideas
        .where((t) => t.title.toLowerCase().contains(term))
        .map((t) => SearchResult('Idea', t.id, t.title)));

    if (mounted) {
      setState(() {
        _results = results;
        _isSearching = false;
      });
    }
  }

  Future<void> _createEdge(String targetCollection, int targetId, String targetTitle) async {
    final relation = _relationController.text.trim().isEmpty ? 'relates_to' : _relationController.text.trim();
    
    final graphService = GraphService(isar);
    
    String sourceCol, targetCol, sourceTit, targetTit;
    int sourceI, targetI;

    if (_isIncoming) {
      // Target -> Current
      sourceCol = targetCollection;
      sourceI = targetId;
      sourceTit = targetTitle;
      targetCol = widget.currentCollection;
      targetI = widget.currentId;
      targetTit = widget.currentTitle;
    } else {
      // Current -> Target
      sourceCol = widget.currentCollection;
      sourceI = widget.currentId;
      sourceTit = widget.currentTitle;
      targetCol = targetCollection;
      targetI = targetId;
      targetTit = targetTitle;
    }

    await graphService.createEdge(
      sourceCollection: sourceCol,
      sourceId: sourceI,
      sourceTitle: sourceTit,
      targetCollection: targetCol,
      targetId: targetI,
      targetTitle: targetTit,
      relationType: relation,
    );

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'NEW CONNECTION',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Direction Toggle
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: !_isIncoming ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : null,
                      side: BorderSide(color: !_isIncoming ? Theme.of(context).colorScheme.primary : Colors.grey),
                    ),
                    onPressed: () => setState(() => _isIncoming = false),
                    child: const Text('Leads To \n(Outgoing)', textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _isIncoming ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : null,
                      side: BorderSide(color: _isIncoming ? Theme.of(context).colorScheme.primary : Colors.grey),
                    ),
                    onPressed: () => setState(() => _isIncoming = true),
                    child: const Text('Influenced By \n(Incoming)', textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            TextField(
              controller: _relationController,
              decoration: const InputDecoration(
                labelText: 'RELATION TYPE',
                hintText: 'e.g. depends_on, inspires, blocks',
              ),
            ),
            
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'SEARCH TARGET ENTITY',
                hintText: 'Type to search Tasks, Projects, Ideas...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _performSearch(_searchController.text),
                ),
              ),
              onSubmitted: _performSearch,
            ),
            
            const SizedBox(height: 16),
            
            if (_isSearching)
              const Center(child: CircularProgressIndicator())
            else if (_results.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final res = _results[index];
                    return ListTile(
                      title: Text(res.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(res.collection),
                      onTap: () => _createEdge(res.collection, res.id, res.title),
                    );
                  },
                ),
              )
            else if (_searchController.text.trim().isNotEmpty)
              ListTile(
                title: Text('Create Concept: "${_searchController.text.trim()}"'),
                subtitle: const Text('Concept • Abstract Node'),
                trailing: const Icon(Icons.add),
                onTap: () {
                  final title = _searchController.text.trim();
                  final id = title.toLowerCase().hashCode.abs();
                  _createEdge('Concept', id, title);
                },
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Search to connect or create a new concept.', style: TextStyle(color: Colors.grey)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
