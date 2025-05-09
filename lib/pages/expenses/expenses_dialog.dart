import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../API/expenses.dart';
import '../../API/expense_categories.dart';
import '../../config/user_provider.dart';

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
  String? _selectedCategoryName;
  IconData _selectedIcon = Icons.shopping_cart;

  List<Map<String, dynamic>> _categories = [];
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
    _loadCategories().then((_) {
      if (widget.expense != null) {
        final e = widget.expense!;
        print(e);
        _titleController.text = e['name'] ?? '';
        _descController.text = e['description'] ?? '';
        _amountController.text = e['amount']?.toString() ?? '';
        _selectedCategoryName = e['category'];
        _selectedDate = e['date'] != null ? DateTime.parse(e['date']) : _selectedDate;
        if (e['attachments'] != null) {
          _selectedIcon = IconData(int.parse(e['attachments']), fontFamily: 'MaterialIcons');
        }
      } else {
        _selectedCategoryName = _categories.isNotEmpty ? _categories.first['name'] : null;
      }
      setState(() {});
    });
  }

  Future<void> _loadCategories() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;
    final service = ExpenseCategoriesService(token: token);
    _categories = await service.getExpenseCategories();
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    final category = _categories.firstWhere(
          (c) => c['name'] == _selectedCategoryName,
      orElse: () => {'id': null},
    );

    final data = {
      'name': _titleController.text,
      'description': _descController.text,
      'amount': int.tryParse(_amountController.text) ?? 0,
      'data': _selectedDate.toIso8601String(),
      'expense_category_id': category['id'],
      'attachments': _selectedIcon.codePoint.toString(),
    };

    final service = ExpensesService(token: token);
    bool success;

    if (widget.expense == null) {
      success = await service.createExpense(data);
    } else {
      success = await service.updateExpense(widget.expense!['id'], data);
    }

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.expense == null ? 'Расход добавлен' : 'Расход обновлён')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при сохранении')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.expense == null ? 'Добавить расход' : 'Редактировать расход'),
      content: _categories.isEmpty
          ? const CircularProgressIndicator()
          : Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (v) => v == null || v.isEmpty ? 'Введите название' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Описание'),
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Сумма'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Введите сумму' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategoryName,
                items: _categories
                    .map<DropdownMenuItem<String>>(
                      (cat) => DropdownMenuItem<String>(
                    value: cat['name'] as String,
                    child: Text(cat['name']),
                  ),
                )
                    .toList(),

                onChanged: (value) => setState(() => _selectedCategoryName = value!),
                decoration: const InputDecoration(labelText: 'Категория'),
              ),
              const SizedBox(height: 10),
              Text('Дата: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}'),
              TextButton(onPressed: _pickDate, child: const Text('Выбрать дату')),
              const SizedBox(height: 10),
              const Text('Выберите иконку:'),
              Wrap(
                spacing: 10,
                children: _iconOptions.map((icon) {
                  final selected = icon == _selectedIcon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selected ? Colors.orange.shade100 : Colors.grey.shade200,
                        border: Border.all(
                            color: selected ? Colors.orange : Colors.transparent, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.orange),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          onPressed: _save,
          child: const Text('Сохранить'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}
