import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/models/clothing_item.dart';
import '../../main.dart';
import 'package:isar/isar.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Tops', 'Bottoms', 'Footwear', 'Outerwear'];

  void _showAddClothingModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final colorCtrl = TextEditingController();
    String category = 'Tops';
    String? imagePath;
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      backgroundColor: KairoTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(KairoTheme.radiusLg)),
        side: BorderSide(color: KairoTheme.border),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: KairoTheme.xl,
                right: KairoTheme.xl,
                top: KairoTheme.xl,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + KairoTheme.xl,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "INGEST CLOTHING ARMOR",
                          style: TextStyle(
                            color: KairoTheme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            letterSpacing: 1.2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: KairoTheme.textMuted, size: 18),
                          onPressed: () => Navigator.pop(ctx),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: KairoTheme.md),
                    TextField(
                      controller: nameCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "ITEM NAME",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "e.g. Heavyweight Obsidian Tee",
                        hintStyle: const TextStyle(color: KairoTheme.textFaint),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm), borderSide: const BorderSide(color: KairoTheme.border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm), borderSide: const BorderSide(color: KairoTheme.border)),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    TextField(
                      controller: colorCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "PRIMARY COLOR",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "e.g. Matte Black",
                        hintStyle: const TextStyle(color: KairoTheme.textFaint),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm), borderSide: const BorderSide(color: KairoTheme.border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm), borderSide: const BorderSide(color: KairoTheme.border)),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.md),
                    const Text("CATEGORY", style: TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                    const SizedBox(height: KairoTheme.xs),
                    Wrap(
                      spacing: 8,
                      children: ['Tops', 'Bottoms', 'Footwear', 'Outerwear'].map((cat) {
                        final isSel = category == cat;
                        return ChoiceChip(
                          label: Text(cat.toUpperCase(), style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: isSel ? Colors.black : KairoTheme.textSecondary)),
                          selected: isSel,
                          selectedColor: Colors.white,
                          backgroundColor: KairoTheme.surfaceElevated,
                          side: BorderSide(color: isSel ? Colors.white : KairoTheme.border),
                          onSelected: (_) => setModalState(() => category = cat),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: KairoTheme.md),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await picker.pickImage(source: ImageSource.camera);
                              if (picked != null) setModalState(() => imagePath = picked.path);
                            },
                            icon: const Icon(Icons.camera_alt_outlined, size: 16, color: Colors.white),
                            label: const Text("CAMERA", style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'monospace')),
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: KairoTheme.border)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await picker.pickImage(source: ImageSource.gallery);
                              if (picked != null) setModalState(() => imagePath = picked.path);
                            },
                            icon: const Icon(Icons.photo_library_outlined, size: 16, color: Colors.white),
                            label: const Text("GALLERY", style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'monospace')),
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: KairoTheme.border)),
                          ),
                        ),
                      ],
                    ),
                    if (imagePath != null) ...[
                      const SizedBox(height: 8),
                      Text("Attached photo: ${imagePath!.split('/').last}", style: const TextStyle(color: KairoTheme.success, fontSize: 10, fontFamily: 'monospace')),
                    ],
                    const SizedBox(height: KairoTheme.lg),
                    KairoButton(
                      text: "COMMIT ARMOR TO WARDROBE",
                      isPrimary: true,
                      isFullWidth: true,
                      onPressed: () async {
                        if (nameCtrl.text.trim().isEmpty) return;
                        final item = ClothingItem(
                          name: nameCtrl.text.trim(),
                          category: category,
                          primaryColor: colorCtrl.text.trim().isEmpty ? 'Black' : colorCtrl.text.trim(),
                          localImagePath: imagePath ?? '',
                        );

                        await isar.writeTxn(() async {
                          await isar.clothingItems.put(item);
                        });

                        setState(() {});
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showOutfitRecommendation(BuildContext context, List<ClothingItem> items) {
    final tops = items.where((i) => i.category == 'Tops').toList();
    final bottoms = items.where((i) => i.category == 'Bottoms').toList();
    final shoes = items.where((i) => i.category == 'Footwear').toList();

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    final top = tops.isNotEmpty ? tops[dayOfYear % tops.length] : null;
    final bottom = bottoms.isNotEmpty ? bottoms[dayOfYear % bottoms.length] : null;
    final shoe = shoes.isNotEmpty ? shoes[dayOfYear % shoes.length] : null;

    showModalBottomSheet(
      context: context,
      backgroundColor: KairoTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(KairoTheme.radiusLg)),
        side: BorderSide(color: KairoTheme.border),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(KairoTheme.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("ZERO-DECISION OUTFIT", style: TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
                  IconButton(icon: const Icon(Icons.close, color: KairoTheme.textMuted, size: 18), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 4),
              const Text("Eliminate morning cognitive drain: Pre-selected daily capsule combination.", style: TextStyle(color: KairoTheme.textSecondary, fontSize: 11)),
              const SizedBox(height: KairoTheme.lg),
              _buildOutfitSlot("TOP", top?.name ?? "Any standard top", top?.primaryColor ?? "Black"),
              const SizedBox(height: KairoTheme.sm),
              _buildOutfitSlot("BOTTOM", bottom?.name ?? "Any standard trousers", bottom?.primaryColor ?? "Dark Slate"),
              const SizedBox(height: KairoTheme.sm),
              _buildOutfitSlot("FOOTWEAR", shoe?.name ?? "Standard daily trainers", shoe?.primaryColor ?? "Monochrome"),
              const SizedBox(height: KairoTheme.xl),
              KairoButton(text: "ACCEPT COMBINATION", isPrimary: true, isFullWidth: true, onPressed: () => Navigator.pop(ctx)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOutfitSlot(String slot, String name, String color) {
    return Container(
      padding: const EdgeInsets.all(KairoTheme.md),
      decoration: BoxDecoration(
        color: KairoTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
        border: Border.all(color: KairoTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(slot, style: const TextStyle(color: KairoTheme.recommended, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$name ($color)",
              textAlign: TextAlign.end,
              style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KairoTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: KairoTheme.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "CAPSULE WARDROBE // ZERO DECISION",
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            color: KairoTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ClothingItem>>(
        future: isar.clothingItems.where().sortByAddedAtDesc().findAll(),
        builder: (ctx, snap) {
          final allItems = snap.data ?? [];
          final filteredItems = _selectedCategory == 'All'
              ? allItems
              : allItems.where((i) => i.category == _selectedCategory).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(KairoTheme.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Zero Decision Daily Outfit Button
                KairoButton(
                  text: "GENERATE ZERO-DECISION OUTFIT",
                  icon: Icons.checkroom_rounded,
                  isPrimary: true,
                  isFullWidth: true,
                  onPressed: () => _showOutfitRecommendation(context, allItems),
                ),
                const SizedBox(height: KairoTheme.md),

                // 2. Ingest Item Action
                KairoButton(
                  text: "+ INGEST ARMOR ITEM",
                  icon: Icons.add,
                  isPrimary: false,
                  isFullWidth: true,
                  onPressed: () => _showAddClothingModal(context),
                ),
                const SizedBox(height: KairoTheme.lg),

                // 3. Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      final isSel = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            cat.toUpperCase(),
                            style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: isSel ? Colors.black : KairoTheme.textSecondary),
                          ),
                          selected: isSel,
                          selectedColor: Colors.white,
                          backgroundColor: KairoTheme.surfaceElevated,
                          side: BorderSide(color: isSel ? Colors.white : KairoTheme.border),
                          onSelected: (_) => setState(() => _selectedCategory = cat),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: KairoTheme.lg),

                // 4. Catalog Grid
                if (filteredItems.isEmpty)
                  const KairoEmptyState(
                    title: "NO ITEMS IN CATALOG",
                    description: "Catalog your essential clothing pieces to eliminate daily outfit decision fatigue.",
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (ctx, index) {
                      final item = filteredItems[index];
                      final hasImg = item.localImagePath.isNotEmpty && File(item.localImagePath).existsSync();

                      return KairoCard(
                        padding: const EdgeInsets.all(KairoTheme.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: KairoTheme.surfaceElevated,
                                  borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                ),
                                child: hasImg
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                        child: Image.file(File(item.localImagePath), fit: BoxFit.cover),
                                      )
                                    : const Icon(Icons.checkroom_rounded, color: KairoTheme.textFaint, size: 36),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.name,
                              style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11, fontWeight: FontWeight.w800),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.category.toUpperCase(), style: const TextStyle(color: KairoTheme.textMuted, fontSize: 8, fontFamily: 'monospace')),
                                Text(item.primaryColor, style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 8)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
