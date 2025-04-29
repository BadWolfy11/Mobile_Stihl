import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../theme/light_color.dart';
import '../../theme/theme.dart';
import '../../widgets/barcode_copy.dart';
import '../../widgets/title_text.dart';
import 'goods_dialog.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  Widget _productImage(String imagePath) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 250,
          color: Colors.grey[100],  // Добавляем серый фон
        ),
        Align(
        alignment: Alignment.topCenter,
        child:
          FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.topCenter,
                child: TitleText(
                  text: "STIHL",
                  fontSize: 160,
                  color: LightColor.lightGrey,
                ),
              ),
          ),
        Image.asset(
          imagePath,
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 250,
            color: Colors.grey[200],
            child: Icon(Icons.image, size: 100),
          ),
        ),
      ],
    );
  }

  Widget _detailSection(BuildContext context) {
    return Container(
      padding: AppTheme.padding.copyWith(top: 16, bottom: 0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TitleText(
                  text: product['name'],
                  fontSize: 25,
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${product['price']}",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " ₽",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text("${product['id']}",
              style: TextStyle(color: LightColor.grey, fontSize: 18, fontWeight: FontWeight.w500)),


              // Spacer(),
              // Icon(Icons.star, color: LightColor.yellowColor, size: 20),
              // Icon(Icons.star, color: LightColor.yellowColor, size: 20),
              // Icon(Icons.star, color: LightColor.yellowColor, size: 20),
              // Icon(Icons.star, color: LightColor.yellowColor, size: 20),
              // Icon(Icons.star_border, color: Colors.grey, size: 20),

          SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: product['stock'] > 0 ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  product['stock'] > 0 ? 'ЕСТЬ В НАЛИЧИИ' : 'НЕТ В НАЛИЧИИ',
                  style: TextStyle(
                    color: product['stock'] > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _infoRow("Описание", product['description']),
          _infoRow("Категория", product['category']),
          _infoRow("Остаток", "${product['stock']} шт."),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          // Штрихкод

          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BarcodeWithCopyButton(data: product['barcode']),
              ],
            ),
          ),

          SizedBox(height: 20)


        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: LightColor.grey, fontWeight: FontWeight.w800))),
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Удалить товар"),
          content: Text("Вы уверены, что хотите удалить этот товар?"),
          actions: [
            TextButton(
              child: Text("Отмена"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Удалить"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Закрыть карточку товара
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Товар удалён (демо)')),
                );
              },
            ),
          ],
        );
      },
    );
  }


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(product['name'], style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _productImage(product['image']),
            Expanded(
              child: SingleChildScrollView(
                child: _detailSection(context),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text('Изменить', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => GoodsDialog(itemId: product['id']),
                  );
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text('Удалить', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _showDeleteConfirmation(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
