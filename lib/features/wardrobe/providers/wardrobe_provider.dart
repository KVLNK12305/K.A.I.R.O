import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../../../core/models/clothing_item.dart';
import '../../../main.dart';
import '../services/outfit_engine.dart';

class WardrobeState {
  final List<ClothingItem> items;
  final OutfitCombination? outfitOfTheDay;

  WardrobeState({this.items = const [], this.outfitOfTheDay});
}

class WardrobeNotifier extends StateNotifier<WardrobeState> {
  final OutfitEngine _engine = OutfitEngine();
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  WardrobeNotifier() : super(WardrobeState()) {
    loadWardrobe();
  }

  Future<void> loadWardrobe() async {
    final items = await isar.clothingItems.where().anyId().findAll();
    final outfit = _engine.generateDailyOutfit(items);
    state = WardrobeState(items: items, outfitOfTheDay: outfit);
  }

  Future<void> addClothingItem({
    required ImageSource source,
    required String name,
    required String category,
    required String primaryColor,
    List<String> tags = const [],
  }) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;

    // Save image to local app directory
    final directory = await getApplicationDocumentsDirectory();
    final ext = image.path.split('.').last;
    final fileName = '${_uuid.v4()}.$ext';
    final savedImage = await File(image.path).copy('${directory.path}/$fileName');

    final newItem = ClothingItem(
      name: name,
      localImagePath: savedImage.path,
      category: category,
      primaryColor: primaryColor,
      tags: tags,
    );

    await isar.writeTxn(() async {
      await isar.clothingItems.put(newItem);
    });

    await loadWardrobe();
  }
}

final wardrobeProvider = StateNotifierProvider<WardrobeNotifier, WardrobeState>((ref) {
  return WardrobeNotifier();
});
