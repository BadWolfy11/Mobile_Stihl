import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  final Map<String, dynamic> item;

  const EditDialog({super.key, required this.item});

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    widget.item.forEach((key, value) {
      _controllers[key] = TextEditingController(text: value?.toString() ?? '');
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveChanges() {
    final updatedItem = <String, dynamic>{};
    _controllers.forEach((key, controller) {
      updatedItem[key] = controller.text;
    });
    Navigator.pop(context, updatedItem);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Редактировать элемент'),
      content: SingleChildScrollView(
        child: Column(
          children: _controllers.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: entry.key,
                  border: const OutlineInputBorder(),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
