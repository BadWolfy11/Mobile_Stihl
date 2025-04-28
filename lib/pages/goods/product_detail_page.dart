import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../theme/light_color.dart';
import '../../theme/theme.dart';
import '../../widgets/title_text.dart';

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
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                  color: LightColor.iconColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          SizedBox(height: 20),
          TitleText(text: product['name'], fontSize: 25),
          SizedBox(height: 10),
          Row(
            children: [
              TitleText(
                text: "${product['price']} ₽",
                fontSize: 25,
                color: LightColor.orange,
              ),
              // Spacer(),
              // Icon(Icons.star, color: LightColor.yellowColor, size: 20),
              // Icon(Icons.star, color: LightColor.yellowColor, size: 20),
              // Icon(Icons.star, color: LightColor.yellowColor, size: 20),
              // Icon(Icons.star, color: LightColor.yellowColor, size: 20),
              // Icon(Icons.star_border, color: Colors.grey, size: 20),
            ],
          ),
          SizedBox(height: 10),
          _infoItem("Описание", product['description']),
          _infoItem("Категория", product['category']),
          _infoItem("Остаток", "${product['stock']} шт."),
          SizedBox(height: 20),
          Divider(),
          SizedBox(height: 20),
          // Штрихкод

          Center(
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Центрирует по горизонтали
                children: [
                  Text(
                    'Штрихкод/QR-код:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  BarcodeWidget(
                    barcode: Barcode.code128(), // Или Barcode.qrCode()
                    data: product['barcode'],   // Генерация по твоему полю
                    width: 200,
                    height: 80,
                  ),

                ],)
          ),


        ],
      ),
    );
  }

  Widget _infoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(text: title, fontSize: 16, color: LightColor.grey),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: LightColor.orange,
        child: Icon(Icons.shopping_basket),
        onPressed: () {},
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(product['name'], style: TextStyle(color: Colors.black)),
      ),
      backgroundColor: Colors.grey[100],
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
    );
  }
}