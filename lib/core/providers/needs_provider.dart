import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../models/need.dart';
import '../services/need_service.dart';
import '../services/microsoft_todo_service.dart';

final needServiceProvider = Provider<NeedService>((ref) {
  return NeedService(isar);
});

final microsoftTodoServiceProvider = Provider<MicrosoftTodoService>((ref) {
  return MicrosoftTodoService(isar);
});

final needsSummaryProvider = FutureProvider<NeedsSummary>((ref) async {
  final service = ref.watch(needServiceProvider);
  return await service.getNeedsSummary();
});

class NeedsFilterState {
  final NeedStatus? status;
  final NeedType? type;
  final String category;
  final NeedUrgency? urgency;
  final String searchQuery;

  const NeedsFilterState({
    this.status,
    this.type,
    this.category = 'All',
    this.urgency,
    this.searchQuery = '',
  });

  NeedsFilterState copyWith({
    NeedStatus? Function()? status,
    NeedType? Function()? type,
    String? category,
    NeedUrgency? Function()? urgency,
    String? searchQuery,
  }) {
    return NeedsFilterState(
      status: status != null ? status() : this.status,
      type: type != null ? type() : this.type,
      category: category ?? this.category,
      urgency: urgency != null ? urgency() : this.urgency,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

final needsFilterProvider = StateProvider<NeedsFilterState>((ref) {
  return const NeedsFilterState();
});

final filteredNeedsProvider = FutureProvider<List<Need>>((ref) async {
  final service = ref.watch(needServiceProvider);
  final filter = ref.watch(needsFilterProvider);

  final list = await service.getNeeds(
    status: filter.status,
    type: filter.type,
    category: filter.category == 'All' ? null : filter.category,
    urgency: filter.urgency,
  );

  if (filter.searchQuery.trim().isEmpty) {
    return list;
  }

  final q = filter.searchQuery.trim().toLowerCase();
  return list.where((n) {
    return n.title.toLowerCase().contains(q) ||
        n.description.toLowerCase().contains(q) ||
        n.currentSolution.toLowerCase().contains(q) ||
        n.category.toLowerCase().contains(q);
  }).toList();
});
