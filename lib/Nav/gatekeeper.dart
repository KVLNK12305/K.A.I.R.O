import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main_scaffold.dart';

/// K.A.I.R.O. V2 Gatekeeper:
/// The hostile lockout / punishment architecture has been deprecated.
/// K.A.I.R.O. operates as an objective mirror and guide — never a punisher.
class Gatekeeper extends ConsumerWidget {
  const Gatekeeper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MainScaffold();
  }
}

