import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../API/goods.dart';
import '../../API/categories.dart';
import '../../config/user_provider.dart';
import '../../widgets/pagination_bar.dart';
import '../../widgets/search_filter.dart';
import '../../theme/light_color.dart';
import 'product_detail_page.dart';
import 'goods_card.dart';
import 'goods_dialog.dart';

class GoodsPage extends StatefulWidget {
  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  String _searchQuery = '';
  int? _selectedCategoryId;
  List<Map<String, dynamic>> _goods = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    final goodsService = GoodsService(token: token);
    final categoriesService = CategoriesService(token: token);

    final goods = await goodsService.searchGoods();
    final cats = await categoriesService.getCategories();

    setState(() {
      _goods = goods;
      _categories = [{'id': null, 'name': 'Все'}, ...cats];
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredGoods {
    return _goods.where((product) {
      final matchesSearch = product['name']?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false ||
          product['description']?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
      //поиск товара по категории
      final matchesCategory = _selectedCategoryId == null ||
          product['category_id'] == _selectedCategoryId;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  //Работа с пагинацией страницы
  int get _totalPages => (_filteredGoods.length / _itemsPerPage).ceil();

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


  //Открытие виджета создания нового товара
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => GoodsDialog(),
    );
  }
  //Открытие страницы детальной информации о продукте
  void _showProductDetail(int productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(productId: productId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleId = Provider.of<UserProvider>(context).roleId;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final displayedGoods = _filteredGoods
        .skip((_currentPage - 1) * _itemsPerPage)
        .take(_itemsPerPage)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Товары', style: TextStyle(fontSize: 24)),
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
            onFilterSelected: (categoryName) {
              //записываются ищется выбранная категория по названию
              final matchedCategory = _categories.firstWhere(
                    (cat) => cat['name'] == categoryName,
                orElse: () => {'id': null},
              );
              //фильтр обновляется
              setState(() {
                _selectedCategoryId = matchedCategory['id'];
                _currentPage = 1;
              });
            },
            categories: _categories.map((c) => c['name'].toString()).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedGoods.length,
              itemBuilder: (context, index) {
                return GoodsCard(
                  goods: displayedGoods[index],
                  onTap: () => _showProductDetail(displayedGoods[index]['id']),
                );
              },
            ),
          ),
          //класс пагинации страницы
          PaginationBar(
            currentPage: _currentPage,
            totalPages: _totalPages,
            onPrevious: _previousPage,
            onNext: _nextPage,
          ),
        ],
      ),
      // Работа с ролью ипользователя, если пользователь не работник торогового зала, то ему доступна функция создания роли
      floatingActionButton: roleId != 1001
          ? Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          backgroundColor: LightColor.orange,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: _showAddDialog,
        ),
      )
          : null,
    );
  }
}
