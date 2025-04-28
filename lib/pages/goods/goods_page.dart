import 'package:flutter/material.dart';

import 'product_detail_page.dart';

import 'goods_card.dart';
import 'goods_dialog.dart';
import 'pagination_bar.dart';

class GoodsPage extends StatefulWidget {
  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  int _currentPage = 1;
  int _totalPages = 5;
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
      'image': '/assets/images/products/product1.jpg', // 5 разных изображений
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
    final displayedGoods = _goods.skip((_currentPage-1)*3).take(5).toList();

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
          Expanded(
            child: ListView.builder(
              itemCount: displayedGoods.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => _showProductDetail(displayedGoods[index]),
                child: GoodsCard(goods: displayedGoods[index]),
              ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: _showAddDialog,
      ),
    );
  }
}