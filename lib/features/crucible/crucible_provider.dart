import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/crucible_state.dart';
import '../../main.dart';

class CrucibleNotifier extends StateNotifier<CrucibleState> {
  CrucibleNotifier() : super(CrucibleState()) {
    _load();
  }

  Future<void> _load() async {
    var c = await isar.crucibleStates.get(1);
    if (c == null) {
      c = CrucibleState();
      c.id = 1;
      await isar.writeTxn(() async => await isar.crucibleStates.put(c!));
    }
    state = c;
  }

  Future<void> resolveProof(String proofText) async {
    await isar.writeTxn(() async {
      state.isActive = false;
      state.proofText = proofText;
      state.resolvedAt = DateTime.now();
      await isar.crucibleStates.put(state);
    });
    await _load();
  }

  Future<void> triggerManual(String commitment) async {
    await isar.writeTxn(() async {
      state.isActive = true;
      state.commitment = commitment;
      state.triggeredAt = DateTime.now();
      state.timesTriggered++;
      await isar.crucibleStates.put(state);
    });
    await _load();
  }
}

final crucibleProvider = StateNotifierProvider<CrucibleNotifier, CrucibleState>((ref) {
  return CrucibleNotifier();
});
