import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stihl_mobile/theme/light_color.dart';

import '../../API/expenses.dart';
import '../../API/expense_categories.dart';
import '../../config/user_provider.dart';
import '../../widgets/pagination_bar.dart';
import '../../widgets/search_filter.dart';
import 'expenses_card.dart';
import 'expenses_dialog.dart';
import 'expenses_detail_page.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  String _searchQuery = '';
  String? _selectedCategoryName;

  List<Map<String, dynamic>> _expenses = [];
  List<Map<String, dynamic>> _categories = [];
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndExpenses();
  }

  Future<void> _loadCategoriesAndExpenses() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    final expensesCategories = ExpenseCategoriesService(token: token);

    final fetchedCategories = await expensesCategories.getExpenseCategories();
    _categories = [{'id': null, 'name': 'Все'}, ...fetchedCategories];

    await _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    final service = ExpensesService(token: token);
    final offset = (_currentPage - 1) * _itemsPerPage;

    final selectedCategory = _categories.firstWhere(
          (c) => c['name'] == _selectedCategoryName,
      orElse: () => {'id': null},
    );

    final data = await service.searchExpenses(
      name: _searchQuery,
      categoryId: selectedCategory['id'],
      limit: _itemsPerPage,
      offset: offset,
    );

    setState(() {
      _expenses = List<Map<String, dynamic>>.from(data['items']);
      _totalCount = data['totalCount'] ?? 0;
    });
  }

  int get _totalPages => (_totalCount / _itemsPerPage).ceil();

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() => _currentPage--);
      _loadExpenses();
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() => _currentPage++);
      _loadExpenses();
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => ExpensesDialog(),
    );
  }

  void _showExpenseDetail(Map<String, dynamic> expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpensesDetailPage(expense: expense),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedExpenses = _expenses;

    return Scaffold(
      appBar: AppBar(
        title: Text('Прочие затраты', style: TextStyle(fontSize: 24)),
      ),
      body: Column(
        children: [
          SearchFilterWidget(
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
                _currentPage = 1;
              });
              _loadExpenses();
            },
            onFilterSelected: (categoryName) {
              setState(() {
                _selectedCategoryName = categoryName;
                _currentPage = 1;
              });
              _loadExpenses();
            },
            categories: _categories.map((c) => c['name'].toString()).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedExpenses.length,
              itemBuilder: (context, index) {
                return ExpensesCard(
                  expense: displayedExpenses[index],
                  onTap: () => _showExpenseDetail(displayedExpenses[index]),
                );
              },
            ),
          ),
          PaginationBar(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPrevious: _previousPage,
            onNext: _nextPage,
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          backgroundColor: LightColor.orange,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: _showAddDialog,
        ),
      ),
    );
  }
}
