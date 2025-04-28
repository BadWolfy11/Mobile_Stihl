import 'package:flutter/material.dart';

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
      builder: (context) => _GoodsDialog(),
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
                child: _GoodsCard(goods: displayedGoods[index]),
              ),
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

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${product['id']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Описание: ${product['description']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Штрихкод: ${product['barcode']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Цена: ${product['price']} руб.', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Категория: ${product['category']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Остаток: ${product['stock']} шт.', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoodsCard extends StatelessWidget {
  final Map<String, dynamic> goods;

  const _GoodsCard({required this.goods});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text('${goods['id']} - ${goods['name']}'),
        subtitle: Text(goods['description']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.orange),
              onPressed: () => _showEditDialog(context, goods['id']),
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
      builder: (context) => _GoodsDialog(itemId: id),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Подтвердить удаление'),
        content: Text('Вы точно хотите удалить этот товар?'),
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
                SnackBar(content: Text('Товар удален (демо)')),
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

class _GoodsDialog extends StatefulWidget {
  final int? itemId;

  const _GoodsDialog({this.itemId});

  @override
  __GoodsDialogState createState() => __GoodsDialogState();
}

class __GoodsDialogState extends State<_GoodsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _barcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Для демо - заполняем поля если это редактирование
    if (widget.itemId != null) {
      _nameController.text = 'Товар ${widget.itemId}';
      _descriptionController.text = 'Описание товара ${widget.itemId}';
      _barcodeController.text = '460${1000000000 + (widget.itemId! - 1)}';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.itemId == null ? 'Добавить товар' : 'Редактировать товар'),
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
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Описание'),
              ),
              TextFormField(
                controller: _barcodeController,
                decoration: InputDecoration(labelText: 'Штрихкод'),
                keyboardType: TextInputType.number,
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
              ? 'Товар добавлен (демо)'
              : 'Товар обновлен (демо)'),
        ),
      );
    }
  }
}