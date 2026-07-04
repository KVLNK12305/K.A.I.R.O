import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'providers/wardrobe_provider.dart';
import '../../core/theme/app_theme.dart';

class WardrobePage extends ConsumerStatefulWidget {
  const WardrobePage({super.key});

  @override
  ConsumerState<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends ConsumerState<WardrobePage> {
  String _selectedCategory = "ALL";

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        side: BorderSide(color: AppTheme.border, width: 1),
      ),
      builder: (ctx) => const _AddItemForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wardrobeProvider);
    final filteredItems = _selectedCategory == "ALL"
        ? state.items
        : state.items.where((item) => item.category.toUpperCase() == _selectedCategory.toUpperCase()).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          children: [
            Text(
              "AESTHETIC ARMOR",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "DIGITAL WARDROBE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ─── CATEGORY FILTER PILLS ─────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: ["ALL", "TOP", "BOTTOM", "SHOES", "OUTERWEAR"].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.accent : Colors.black,
                        border: Border.all(
                          color: isSelected ? AppTheme.accent : AppTheme.border,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(color: AppTheme.border, height: 1),
          // ─── INVENTORY GRID ────────────────────────────────────────────
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.checkroom, size: 48, color: Colors.white24),
                        const SizedBox(height: 16),
                        Text(
                          _selectedCategory == "ALL"
                              ? "NO ARMOR cataloged yet.\nTap + to ingest garments."
                              : "NO GARMENTS IN CATEGORY: $_selectedCategory",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                            letterSpacing: 1.5,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, i) {
                      final item = filteredItems[i];
                      final file = File(item.localImagePath);
                      final fileExists = file.existsSync();

                      return Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppTheme.border, width: 1),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (fileExists)
                              Image.file(file, fit: BoxFit.cover)
                            else
                              Container(
                                color: Colors.black26,
                                child: const Center(
                                  child: Icon(Icons.broken_image, color: Colors.white24, size: 32),
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.85),
                                  border: const Border(top: BorderSide(color: AppTheme.border, width: 1)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.category.toUpperCase(),
                                          style: const TextStyle(
                                            color: AppTheme.accent,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        Text(
                                          item.primaryColor.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.accent,
        foregroundColor: Colors.black,
        onPressed: () => _showAddDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text(
          "CATALOG ITEM",
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 11),
        ),
      ),
    );
  }
}

class _AddItemForm extends ConsumerStatefulWidget {
  const _AddItemForm();

  @override
  ConsumerState<_AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends ConsumerState<_AddItemForm> {
  final _nameCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  String _category = "Top";
  ImageSource _source = ImageSource.camera;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ["Top", "Bottom", "Shoes", "Outerwear"];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "CATALOG NEW ARMOR",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameCtrl,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              labelText: "ITEM NAME",
              hintText: "e.g. Heavyweight Black Hoodie",
              labelStyle: const TextStyle(color: Colors.white54, fontSize: 11, letterSpacing: 1),
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.border)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accent)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _colorCtrl,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              labelText: "PRIMARY COLOR",
              hintText: "e.g. Obsidian Black",
              labelStyle: const TextStyle(color: Colors.white54, fontSize: 11, letterSpacing: 1),
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.border)),
              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accent)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "CATEGORY",
            style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final isSel = _category == cat;
              return InkWell(
                onTap: () => setState(() => _category = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSel ? Colors.white : Colors.black,
                    border: Border.all(color: isSel ? Colors.white : AppTheme.border),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    cat.toUpperCase(),
                    style: TextStyle(
                      color: isSel ? Colors.black : Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          const Text(
            "IMAGE SOURCE",
            style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _source = ImageSource.camera),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _source == ImageSource.camera ? AppTheme.accent.withValues(alpha: 0.15) : Colors.black,
                      border: Border.all(color: _source == ImageSource.camera ? AppTheme.accent : AppTheme.border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 16, color: _source == ImageSource.camera ? AppTheme.accent : Colors.white54),
                        const SizedBox(width: 8),
                        Text(
                          "CAMERA",
                          style: TextStyle(
                            color: _source == ImageSource.camera ? AppTheme.accent : Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _source = ImageSource.gallery),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _source == ImageSource.gallery ? AppTheme.accent.withValues(alpha: 0.15) : Colors.black,
                      border: Border.all(color: _source == ImageSource.gallery ? AppTheme.accent : AppTheme.border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library, size: 16, color: _source == ImageSource.gallery ? AppTheme.accent : Colors.white54),
                        const SizedBox(width: 8),
                        Text(
                          "GALLERY",
                          style: TextStyle(
                            color: _source == ImageSource.gallery ? AppTheme.accent : Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () {
              if (_nameCtrl.text.trim().isEmpty || _colorCtrl.text.trim().isEmpty) return;
              ref.read(wardrobeProvider.notifier).addClothingItem(
                source: _source,
                name: _nameCtrl.text.trim(),
                category: _category,
                primaryColor: _colorCtrl.text.trim(),
              );
              Navigator.pop(context);
            },
            child: const Text(
              "CAPTURE & INGEST ITEM",
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
