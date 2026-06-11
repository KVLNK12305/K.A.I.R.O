import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/scratchpad_service.dart';

final commandCenterProvider = AsyncNotifierProvider<CommandCenterNotifier, String>(() {
  return CommandCenterNotifier();
});

class CommandCenterNotifier extends AsyncNotifier<String> {
  Timer? _debounce;

  @override
  FutureOr<String> build() async {
    return await ref.watch(scratchpadServiceProvider).readTodayNotes();
  }

  void updateNotes(String content) {
    state = AsyncValue.data(content);
    
    // Debounce the save operation to avoid writing to disk on every keystroke
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(scratchpadServiceProvider).saveTodayNotes(content);
    });
  }
}
