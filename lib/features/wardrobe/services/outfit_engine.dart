import '../../../core/models/clothing_item.dart';
import 'dart:math';

class OutfitCombination {
  final ClothingItem top;
  final ClothingItem bottom;
  final ClothingItem? shoes;
  final ClothingItem? outerwear;

  OutfitCombination({required this.top, required this.bottom, this.shoes, this.outerwear});
}

class OutfitEngine {
  /// Generates a logical outfit combination from the provided wardrobe.
  /// Returns null if there are no tops or bottoms.
  OutfitCombination? generateDailyOutfit(List<ClothingItem> wardrobe) {
    final tops = wardrobe.where((i) => i.category == "Top").toList();
    final bottoms = wardrobe.where((i) => i.category == "Bottom").toList();
    final shoes = wardrobe.where((i) => i.category == "Shoes").toList();
    final outerwear = wardrobe.where((i) => i.category == "Outerwear").toList();

    if (tops.isEmpty || bottoms.isEmpty) return null;

    final random = Random();

    // 1. Pick a random bottom to start the anchor
    final bottom = bottoms[random.nextInt(bottoms.length)];

    // 2. Filter tops based on rules
    // Rule A: Don't mix black and navy (basic style rule)
    var validTops = tops.where((t) {
      if ((bottom.primaryColor.toLowerCase() == "navy" && t.primaryColor.toLowerCase() == "black") ||
          (bottom.primaryColor.toLowerCase() == "black" && t.primaryColor.toLowerCase() == "navy")) {
        return false;
      }
      return true;
    }).toList();

    // Fallback if rule filters everything out
    if (validTops.isEmpty) validTops = tops;

    final top = validTops[random.nextInt(validTops.length)];

    // 3. Pick Shoes
    ClothingItem? shoe;
    if (shoes.isNotEmpty) {
      shoe = shoes[random.nextInt(shoes.length)];
    }

    // 4. Pick Outerwear (20% chance if available)
    ClothingItem? jacket;
    if (outerwear.isNotEmpty && random.nextDouble() > 0.8) {
      jacket = outerwear[random.nextInt(outerwear.length)];
    }

    return OutfitCombination(top: top, bottom: bottom, shoes: shoe, outerwear: jacket);
  }
}
