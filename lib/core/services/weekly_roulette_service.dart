import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/weekly_roulette.dart';
import '../../main.dart';

class WeeklyRouletteService {
  final Isar isar;
  WeeklyRouletteService(this.isar);

  static final List<Map<String, String>> _curiosityBank = [
    {
      'title': 'How Linux Namespaces Isolate Containers',
      'category': 'Systems Architecture',
      'summary': 'Containers are not virtual machines. Linux namespaces partition kernel resources: PID isolates processes, NET isolates routing, and MNT isolates filesystems. Understanding this demystifies Docker and Kubernetes fundamentally.',
    },
    {
      'title': 'The Byzantine Generals Problem & Distributed Consensus',
      'category': 'Distributed Systems',
      'summary': 'How do independent nodes agree on a single truth over an unreliable network when some nodes may be faulty or malicious? Lamport\'s 1982 paper established the impossibility bounds that modern Raft, Paxos, and Blockchains solve.',
    },
    {
      'title': 'The Lindy Effect & Technological Longevity',
      'category': 'Philosophy of Technology',
      'summary': 'The future life expectancy of a non-perishable technology is proportional to its current age. SQL (1974), C (1972), and Unix pipes (1973) will likely outlive today\'s newest JavaScript frameworks. Build on enduring primitives.',
    },
    {
      'title': 'Opportunity Cost & The Broken Window Fallacy',
      'category': 'Economics',
      'summary': 'Bastiat\'s classic parable illustrates that destruction does not stimulate an economy; it merely diverts capital from unmade progress to repair work. In personal productivity, fixing trivial bugs creates an illusion of work while high-leverage outcomes are neglected.',
    },
    {
      'title': 'Memory Hierarchy & CPU Cache Lines',
      'category': 'Computer Architecture',
      'summary': 'L1 cache access takes ~1 nanosecond, while main memory takes ~100 nanoseconds. Modern software is rarely compute-bound; it is memory-bandwidth bound. Data-oriented design aligns struct arrays to 64-byte cache lines for 10x throughput.',
    },
  ];

  Future<WeeklyRoulette> getThisWeekRoulette() async {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));

    var current = await isar.weeklyRoulettes
        .filter()
        .assignedDateGreaterThan(weekStart)
        .findFirst();

    if (current == null) {
      final weekIndex = (now.millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24 * 7)) % _curiosityBank.length;
      final seed = _curiosityBank[weekIndex];

      current = WeeklyRoulette()
        ..topicTitle = seed['title']!
        ..category = seed['category']!
        ..summary = seed['summary']!
        ..assignedDate = weekStart;

      await isar.writeTxn(() async {
        await isar.weeklyRoulettes.put(current!);
      });
    }

    return current;
  }

  Future<void> saveTakeaway(int id, String? takeaway) async {
    final item = await isar.weeklyRoulettes.get(id);
    if (item != null) {
      item.explored = true;
      item.userTakeaway = takeaway?.trim();
      await isar.writeTxn(() async {
        await isar.weeklyRoulettes.put(item);
      });
    }
  }
}

final weeklyRouletteServiceProvider = Provider<WeeklyRouletteService>((ref) {
  return WeeklyRouletteService(isar);
});

final thisWeekRouletteProvider = FutureProvider<WeeklyRoulette>((ref) async {
  final service = ref.watch(weeklyRouletteServiceProvider);
  return await service.getThisWeekRoulette();
});
