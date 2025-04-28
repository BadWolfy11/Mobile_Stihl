import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  int _currentPage = 1;
  int _totalPages = 5;
  final List<Map<String, dynamic>> _expenses = List.generate(
    15,
        (index) => {
      'id': index + 1,
      'name': 'Расход ${index + 1}',
      'amount': (index + 1) * 100,
      'date': DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(Duration(days: index)),
      ),
      'category': 'Категория ${index % 3 + 1}',
    },
  );

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() => _currentPage--);
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() => _currentPage++);
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => _ExpenseDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedExpenses = _expenses.skip((_currentPage-1)*3).take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Прочие затраты', style: TextStyle(fontSize: 24)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: displayedExpenses.length,
              itemBuilder: (context, index) => _ExpenseCard(expense: displayedExpenses[index]),
            ),
          ),
          _PaginationBar(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPrevious: _previousPage,
            onNext: _nextPage,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: _showAddDialog,
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final Map<String, dynamic> expense;

  const _ExpenseCard({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text('${expense['date']} - ${expense['name']}'),
        subtitle: Text('${expense['amount']} руб. (${expense['category']})'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.orange),
              onPressed: () => _showEditDialog(context, expense['id']),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => _ExpenseDialog(itemId: id),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтвердить удаление'),
        content: Text('Вы точно хотите удалить этот расход?'),
        actions: [
          TextButton(
            child: Text('Отмена'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Удалить', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Расход удален (демо)')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentPage > 1)
            ElevatedButton(
              onPressed: onPrevious,
              child: Text('Назад'),
            ),
          SizedBox(width: 20),
          Text('Страница $currentPage из $totalPages'),
          SizedBox(width: 20),
          if (currentPage < totalPages)
            ElevatedButton(
              onPressed: onNext,
              child: Text('Вперед'),
            ),
        ],
      ),
    );
  }
}

class _ExpenseDialog extends StatefulWidget {
  final int? itemId;

  const _ExpenseDialog({this.itemId});

  @override
  __ExpenseDialogState createState() => __ExpenseDialogState();
}

class __ExpenseDialogState extends State<_ExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedCategory;
  final _categories = ['Категория 1', 'Категория 2', 'Категория 3'];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Для демо - заполняем поля если это редактирование
    if (widget.itemId != null) {
      _nameController.text = 'Расход ${widget.itemId}';
      _amountController.text = (widget.itemId! * 100).toString();
      _selectedCategory = 'Категория ${widget.itemId! % 3 + 1}';
      _dateController.text = DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(Duration(days: widget.itemId! - 1)),
      );
      _selectedDate = DateTime.now().subtract(Duration(days: widget.itemId! - 1));
    } else {
      _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.itemId == null ? 'Добавить расход' : 'Редактировать расход'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Название'),
                validator: (value) => value!.isEmpty ? 'Введите название' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Сумма'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Введите сумму';
                  if (int.tryParse(value) == null) return 'Введите число';
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Дата',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Категория'),
                items: _categories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) => value == null ? 'Выберите категорию' : null,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: Text('Сохранить'),
                    onPressed: _saveForm,
                  ),
                  TextButton(
                    child: Text('Отмена'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.itemId == null
              ? 'Расход добавлен (демо)'
              : 'Расход обновлен (демо)'),
        ),
      );
    }
  }
}