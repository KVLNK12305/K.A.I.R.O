import 'package:flutter/material.dart';
import '../../core/models/memory_edge.dart';
import '../../main.dart';
import '../../core/services/graph_service.dart';

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
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () {
            // TODO: Open dialog to create a new connection to an existing node
          },
          child: const Icon(Icons.add_link),
        ),
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
