import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesDialog extends StatefulWidget {
  final Map<String, dynamic>? expense;

  const ExpensesDialog({super.key, this.expense});

  @override
  State<ExpensesDialog> createState() => _ExpensesDialogState();
}

class _ExpensesDialogState extends State<ExpensesDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Категория 1';
  IconData _selectedIcon = Icons.shopping_cart;

  final List<String> _categories = ['Категория 1', 'Категория 2', 'Категория 3'];
  final List<IconData> _iconOptions = [
    Icons.shopping_cart,
    Icons.restaurant,
    Icons.directions_car,
    Icons.home,
    Icons.flight,
    Icons.medical_services,
    Icons.pets,
    Icons.school,
    Icons.sports_soccer,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      final e = widget.expense!;
      _titleController.text = e['name'] ?? '';
      _descController.text = e['description'] ?? '';
      _amountController.text = e['amount']?.toString() ?? '';
      _selectedCategory = e['category'] ?? _selectedCategory;
      _selectedDate = e['date'] != null ? DateTime.parse(e['date']) : _selectedDate;
      if (e['icon'] != null) {
        _selectedIcon = IconData(e['icon'], fontFamily: 'MaterialIcons');
      }
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newExpense = {
        'name': _titleController.text,
        'description': _descController.text,
        'amount': double.tryParse(_amountController.text) ?? 0.0,
        'category': _selectedCategory,
        'date': _selectedDate.toIso8601String(),
        'icon': _selectedIcon.codePoint,
      };

      Navigator.of(context).pop(newExpense);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.expense == null
              ? 'Расход добавлен (демо)'
              : 'Расход обновлён (демо)'),
        ),
      );


    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.expense == null ? 'Добавить расход' : 'Редактировать расход'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) => value == null || value.isEmpty ? 'Введите название' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Описание'),
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Сумма'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Введите сумму' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
                decoration: const InputDecoration(labelText: 'Категория'),
              ),
              const SizedBox(height: 10),
              Text('Дата: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}'),
              TextButton(
                onPressed: _pickDate,
                child: const Text('Выбрать дату'),
              ),
              const SizedBox(height: 10),
              const Text('Выберите иконку:'),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _iconOptions.map((iconData) {
                  final isSelected = _selectedIcon == iconData;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = iconData),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.orange.shade100 : Colors.grey.shade200,
                        border: Border.all(
                          color: isSelected ? Colors.orange : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(iconData, size: 28, color: Colors.orange),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              onPressed: _save, // твоя логика сохранения
              child: const Text('Сохранить'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
          ],
        ),
      ],
    );
  }
}
