import 'package:flutter/material.dart';
import 'package:stihl_mobile/theme/light_color.dart';

import '../../widgets/pagination_bar.dart';
import '../../widgets/search_filter.dart';
import 'product_detail_page.dart';

import 'goods_card.dart';
import 'goods_dialog.dart';

class GoodsPage extends StatefulWidget {
  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  int _currentPage = 1;
  int _totalPages = 5;
  String _searchQuery = '';
  String? _selectedCategory;

  final List<Map<String, dynamic>> _goods = List.generate(
    15,
        (index) => {
      'id': index + 1,
      'name': 'Товар ${index + 1}',
      'description': 'Описание товара ${index + 1}',
      'barcode': '460${1000000000 + index}',
      'price': (index + 1) * 1000,
      'category': 'Категория ${index % 3 + 1}',
      'stock': index * 5,
      'image': 'assets/images/products/product1.jpg',
    },
  );

  List<Map<String, dynamic>> get _filteredGoods {
    return _goods.where((product) {
      final matchesSearch = product['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product['description'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || _selectedCategory == 'Все' ||
          product['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

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
      builder: (context) => GoodsDialog(),
    );
  }

  void _showProductDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedGoods = _filteredGoods.skip((_currentPage - 1) * 3).take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Товары', style: TextStyle(fontSize: 24)),
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
              itemCount: displayedGoods.length,
              itemBuilder: (context, index) {
                return GoodsCard(
                  goods: displayedGoods[index],
                  onTap: () => _showProductDetail(displayedGoods[index]),
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
        padding: const EdgeInsets.only(bottom: 60.0), // выше пагинации
        child: FloatingActionButton(
          backgroundColor: LightColor.orange,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: _showAddDialog,
        ),
      ),
    );
  }
}
