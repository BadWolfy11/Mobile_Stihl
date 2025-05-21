import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stihl_mobile/pages/export/pdf_export.dart';

import '../../widgets/search_filter.dart';
import '../../API/expenses.dart';
import '../../API/goods.dart';
import '../../API/expense_categories.dart';
import '../../API/categories.dart';
import '../../config/user_provider.dart';
import 'expenses_export.dart';
import 'goods_export.dart';

enum ExportSource { goods, expenses }

class DocumentsExportPage extends StatefulWidget {
  @override
  _DocumentsExportPageState createState() => _DocumentsExportPageState();
}

class _DocumentsExportPageState extends State<DocumentsExportPage> {
  List<Map<String, dynamic>> _selectedGoods = [];
  List<Map<String, dynamic>> _selectedExpenses = [];
  ExportSource currentSource = ExportSource.goods;
  String? searchQuery;
  String? selectedCategory;

  List<Map<String, dynamic>> _expenses = [];
  List<Map<String, dynamic>> _goods = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndData();
  }

  Future<void> _loadCategoriesAndData() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    if (currentSource == ExportSource.goods) {
      final goodsCategoriesService = CategoriesService(token: token);
      final goodsCats = await goodsCategoriesService.getCategories();
      _categories = [{'id': null, 'name': 'Все'}, ...goodsCats];
    } else {
      final expenseCategoriesService = ExpenseCategoriesService(token: token);
      final expenseCats = await expenseCategoriesService.getExpenseCategories();
      _categories = [{'id': null, 'name': 'Все'}, ...expenseCats];
    }

    await _loadData();
  }

  Future<void> _loadData() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    final expensesService = ExpensesService(token: token);
    final goodsService = GoodsService(token: token);

    final selectedCategoryId = (selectedCategory != null && selectedCategory != 'Все')
        ? _categories.firstWhere((c) => c['name'] == selectedCategory, orElse: () => {'id': null})['id']
        : null;

    final expenses = currentSource == ExportSource.expenses
        ? await expensesService.searchExpenses(
      name: (searchQuery != null && searchQuery!.isNotEmpty) ? searchQuery : null,
      categoryId: selectedCategoryId,
      limit: 100,
      offset: 0,
    )
        : {'items': [], 'totalCount': 0};

    final goods = currentSource == ExportSource.goods
        ? await goodsService.searchGoods(
      name: (searchQuery != null && searchQuery!.isNotEmpty) ? searchQuery : null,
      categoryId: selectedCategoryId,
    )
        : [];

    setState(() {
      _expenses = List<Map<String, dynamic>>.from(expenses['items']);
      _goods = List<Map<String, dynamic>>.from(goods);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Генерация документов')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 8),
          _buildTabs(),
          const SizedBox(height: 8),
          _buildFilters(),
          const SizedBox(height: 16),
          Expanded(child: _buildContent()),
          ElevatedButton(
            onPressed: _generateDocument,
            child: const Text('Скачать документ'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ExportSource.values.map((source) {
        final isSelected = currentSource == source;
        final label = {
          ExportSource.goods: 'Товары',
          ExportSource.expenses: 'Затраты',
        }[source]!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: isSelected ? Colors.orange : Colors.grey.shade300,
              foregroundColor: isSelected ? Colors.white : Colors.black87,
            ),
            onPressed: () {
              setState(() {
                currentSource = source;
                selectedCategory = 'Все';
                searchQuery = null;
                _categories = [];
                _isLoading = true;
                _expenses = [];
                _goods = [];
                _loadCategoriesAndData();
              });
            },
            child: Text(label),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilters() {
    final categories = _categories.map((c) => c['name'].toString()).toList();

    return SearchFilterWidget(
      onSearchChanged: (val) => setState(() => searchQuery = val),
      onFilterSelected: (val) => setState(() => selectedCategory = val),
      categories: categories,
    );
  }

  Widget _buildContent() {
    final filtered = currentSource == ExportSource.goods
        ? _goods.where((g) {
      final matchesName = searchQuery == null || g['name']?.toLowerCase().contains(searchQuery!.toLowerCase()) == true;
      final matchesCategory = selectedCategory == null || selectedCategory == 'Все' ||
          g['category_id']?.toString() == _categories.firstWhere(
                (c) => c['name'] == selectedCategory,
            orElse: () => {'id': null},
          )['id']?.toString();
      return matchesName && matchesCategory;
    }).toList()
        : _expenses.where((e) {
      final matchesName = searchQuery == null || e['name']?.toLowerCase().contains(searchQuery!.toLowerCase()) == true;
      final matchesCategory = selectedCategory == null || selectedCategory == 'Все' ||
          e['expense_category_id']?.toString() == _categories.firstWhere(
                (c) => c['name'] == selectedCategory,
            orElse: () => {'id': null},
          )['id']?.toString();
      return matchesName && matchesCategory;
    }).toList();

    final selectedCount = currentSource == ExportSource.goods ? _selectedGoods.length : _selectedExpenses.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Выбрано: $selectedCount', style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton.icon(
                icon: Icon(Icons.select_all, color: Colors.white),
                label: Text("Выбрать все", style: TextStyle(color: Colors.white)),
                style: TextButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  setState(() {
                    if (currentSource == ExportSource.goods) {
                      _selectedGoods.addAll(filtered.where((item) => !_selectedGoods.contains(item)));
                    } else {
                      _selectedExpenses.addAll(filtered.where((item) => !_selectedExpenses.contains(item)));
                    }
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];
              final isSelected = currentSource == ExportSource.goods
                  ? _selectedGoods.contains(item)
                  : _selectedExpenses.contains(item);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (currentSource == ExportSource.goods) {
                      if (isSelected) {
                        _selectedGoods.remove(item);
                      } else {
                        _selectedGoods.add(item);
                      }
                    } else {
                      if (isSelected) {
                        _selectedExpenses.remove(item);
                      } else {
                        _selectedExpenses.add(item);
                      }
                    }
                  });
                },
                child: Container(
                  color: isSelected ? Colors.orange.withOpacity(0.1) : null,
                  child: currentSource == ExportSource.goods
                      ? ExportGoodsCard(goods: item)
                      : ExportExpensesCard(expense: item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _generateDocument() async {
    final selectedItems = currentSource == ExportSource.goods ? _selectedGoods : _selectedExpenses;

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Нет выбранных элементов для экспорта')),
      );
      return;
    }

    try {
      final file = currentSource == ExportSource.goods
          ? await PDFExportService.exportGoods(_selectedGoods)
          : await PDFExportService.exportExpenses(_selectedExpenses);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Документ сохранён: ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при создании PDF: $e')),
      );
    }
  }

}
