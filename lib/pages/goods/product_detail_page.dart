import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';

import '../../API/goods.dart';
import '../../config/user_provider.dart';
import '../../theme/light_color.dart';
import '../../theme/theme.dart';
import '../../widgets/barcode_copy.dart';
import '../../widgets/title_text.dart';
import 'good_actions.dart';
import 'goods_dialog.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic>? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    if (token == null) return;

    final service = GoodsService(token: token);
    final result = await service.getGoodsById(widget.productId);
    print('attachments: ${result!['attachments']}');

    setState(() {
      product = result;
      isLoading = false;
      print('attachments: ${product!['attachments']} 1');
    });
  }

  Widget _productImage(dynamic imagePath) {
    final path = (imagePath is String && imagePath.trim().isNotEmpty)
        ? imagePath.trim()
        : null;

    print('attachments: ${product!['attachments']}2');
    if (path == null) {
      return Container(
        width: double.infinity,
        height: 250,
        color: Colors.grey[200],
        child: const Icon(Icons.image, size: 100, color: Colors.grey),
      );
    }

    return Image.asset(
      path,
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: double.infinity,
        height: 250,
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, size: 100, color: Colors.grey),
      ),
    );
  }



  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: LightColor.grey, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Удалить товар"),
        content: Text("Вы уверены, что хотите удалить этот товар?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Отмена"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Товар удалён (демо)')),
              );
            },
            child: Text("Удалить", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Не удалось загрузить товар")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(product!['name'], style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _productImage(product!['attachments']),
            Expanded(
              child: SingleChildScrollView(
                padding: AppTheme.padding.copyWith(top: 16, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(text: product!['name'], fontSize: 25),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "${product!['price']} ₽",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product!['stock'] > 0 ? 'в наличии' : 'нет в наличии',
                          style: TextStyle(
                            color: product!['stock'] > 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _infoRow("Описание", product!['description']),
                    _infoRow("Категория", "${product!['category']}" ?? 'Без категории'),
                    _infoRow("Остаток", "${product!['stock']} шт."),
                    const SizedBox(height: 20),
                    Center(
                      child: BarcodeWithCopyButton(data: product!['barcode']),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text("Изменить", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => GoodsDialog(itemId: product!['id']),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text("Удалить", style: TextStyle(color: Colors.white)),
                  onPressed: () => showDeleteGoodsDialog(context, product!['id'], () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
