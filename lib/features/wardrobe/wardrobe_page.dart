import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'providers/wardrobe_provider.dart';

class WardrobePage extends ConsumerWidget {
  const WardrobePage({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      isScrollControlled: true,
      builder: (ctx) => const _AddItemForm(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wardrobeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("DIGITAL WARDROBE", style: TextStyle(letterSpacing: 2, fontSize: 14)),
        centerTitle: true,
      ),
      body: state.items.isEmpty
          ? const Center(
              child: Text("Wardrobe is empty.\nTap + to add clothes.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white38)),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
              ),
              itemCount: state.items.length,
              itemBuilder: (context, i) {
                final item = state.items[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(item.localImagePath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                      ),
                      child: Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add, color: Colors.black),
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
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("ADD TO WARDROBE", style: TextStyle(color: Colors.white, letterSpacing: 2, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Item Name (e.g. Black Hoodie)")),
          const SizedBox(height: 10),
          TextField(controller: _colorCtrl, decoration: const InputDecoration(labelText: "Primary Color (e.g. Black)")),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _category,
            items: ["Top", "Bottom", "Shoes", "Outerwear"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _category = v!),
            decoration: const InputDecoration(labelText: "Category"),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Image Source: "),
              Radio<ImageSource>(value: ImageSource.camera, groupValue: _source, onChanged: (v) => setState(() => _source = v!)),
              const Text("Camera"),
              Radio<ImageSource>(value: ImageSource.gallery, groupValue: _source, onChanged: (v) => setState(() => _source = v!)),
              const Text("Gallery"),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_nameCtrl.text.isEmpty || _colorCtrl.text.isEmpty) return;
              ref.read(wardrobeProvider.notifier).addClothingItem(
                source: _source,
                name: _nameCtrl.text,
                category: _category,
                primaryColor: _colorCtrl.text,
              );
              Navigator.pop(context);
            },
            child: const Text("CAPTURE & SAVE"),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
