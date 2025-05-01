import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stihl_mobile/theme/light_color.dart';

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
  final int _itemsPerPage = 10;
  String _searchQuery = '';
  String? _selectedCategory;

  final List<Map<String, dynamic>> _expenses = List.generate(
    43,
        (index) => {
      'id': index + 1,
      'name': 'Расход ${index + 1}',
      'amount': (index + 1) * 100,
      'date': DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(Duration(days: index)),
      ),
      'category': 'Категория ${index % 3 + 1}',
      'attachments': 'assets/images/products/product1.jpg', // или null
    },
  );


  List<Map<String, dynamic>> get _filteredExpenses {
    return _expenses.where((expense) {
      final matchesSearch = expense['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || _selectedCategory == 'Все' || expense['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  int get _totalPages => (_filteredExpenses.length / _itemsPerPage).ceil();

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
    final displayedExpenses = _filteredExpenses
        .skip((_currentPage - 1) * _itemsPerPage)
        .take(_itemsPerPage)
        .toList();

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
