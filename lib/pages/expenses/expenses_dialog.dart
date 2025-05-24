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
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  IconData _selectedIcon = Icons.shopping_cart;

  List<Map<String, dynamic>> _categories = [];
  int? _selectedCategoryIndex;

  bool _isInitialized = false;

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
    _initializeDialog();
  }

  Future<void> _initializeDialog() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    final categoryService = ExpenseCategoriesService(token: token);
    _categories = await categoryService.getExpenseCategories();

    if (widget.expense != null) {
      final e = widget.expense!;
      _titleController.text = e['name'] ?? '';
      _amountController.text = e['amount']?.toString() ?? '';
      _selectedDate = e['data'] != null ? DateTime.parse(e['data']) : _selectedDate;

      final catIndex = _categories.indexWhere((c) => c['id'] == e['expense_category_id']);
      _selectedCategoryIndex = catIndex != -1 ? catIndex : null;

      if (e['attachments'] != null) {
        _selectedIcon = IconData(int.parse(e['attachments']), fontFamily: 'MaterialIcons');
      }
    } else {
      _selectedCategoryIndex = _categories.isNotEmpty ? 0 : null;
    }

    setState(() => _isInitialized = true);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
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
    if (token == null || _selectedCategoryIndex == null) return;

    final categoryId = _categories[_selectedCategoryIndex!]['id'];

    final data = {
      'name': _titleController.text,
      'amount': int.tryParse(_amountController.text) ?? 0,
      'data': _selectedDate.toIso8601String(),
      'expense_category_id': categoryId,
      'attachments': _selectedIcon.codePoint.toString(),
    };

    final service = ExpensesService(token: token);
    final success = widget.expense == null
        ? await service.createExpense(data)
        : await service.updateExpense(widget.expense!['id'], data);

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
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.expense == null ? 'Добавить расход' : 'Редактировать расход'),
      content: !_isInitialized
          ? const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()))
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
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Сумма'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Введите сумму' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _selectedCategoryIndex,
                decoration: const InputDecoration(labelText: 'Категория'),
                items: List.generate(_categories.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(_categories[index]['name']),
                  );
                }),
                onChanged: (value) => setState(() => _selectedCategoryIndex = value),
                validator: (v) => v == null ? 'Выберите категорию' : null,
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
      actions: !_isInitialized
          ? []
          : [
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
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
