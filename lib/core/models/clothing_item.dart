import 'package:isar/isar.dart';

part 'clothing_item.g.dart';

@collection
class ClothingItem {
  Id id = Isar.autoIncrement;

  String name;
  String localImagePath;
  String category; // Top, Bottom, Shoes, Outerwear
  String primaryColor;
  List<String> tags; // e.g., Casual, Formal, Gym
  DateTime addedAt = DateTime.now();

  ClothingItem({
    required this.name,
    required this.localImagePath,
    required this.category,
    required this.primaryColor,
    this.tags = const [],
  });
}
