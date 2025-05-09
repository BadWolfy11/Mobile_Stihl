import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stihl_mobile/theme/light_color.dart';

import '../../API/expenses.dart';
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
  String? _selectedCategory;

  List<Map<String, dynamic>> _expenses = [];
  int _totalCount = 0;


  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    final service = ExpensesService(token: token);
    final offset = (_currentPage - 1) * _itemsPerPage;

    final data = await service.searchExpenses(
      name: _searchQuery,
      categoryId: _selectedCategory != null && _selectedCategory != 'Все'
          ? int.tryParse(_selectedCategory!)
          : null,
      limit: _itemsPerPage,
      offset: offset,
    );

    setState(() {
      _expenses = List<Map<String, dynamic>>.from(data['items']);
      _totalCount = data['totalCount'] ?? 0;
    });
  }




  int get _totalPages => (_totalCount / _itemsPerPage).ceil();
  List<Map<String, dynamic>> get _filteredExpenses => _expenses;


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
    final displayedExpenses = _filteredExpenses;


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
          SearchFilterWidget(
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
                _currentPage = 1;
              });
            },
            onFilterSelected: (selectedCategory) {
              setState(() {
                _selectedCategory = selectedCategory;
                _currentPage = 1;
              });
            },
            categories: ['Все', 'Категория 1', 'Категория 2', 'Категория 3'],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                return ExpensesCard(
                  expense: _expenses[index],
                  onTap: () => _showExpenseDetail(_expenses[index]),
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
