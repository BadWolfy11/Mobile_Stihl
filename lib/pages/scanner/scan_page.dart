import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:provider/provider.dart';

import '../../API/goods.dart';
import '../../config/user_provider.dart';
import '../goods/product_detail_page.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<ScanScreen> {
  String scanResult = "Наведите камеру на код";
  Map<String, dynamic>? foundProduct;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => scan());
  }

  Future<void> scan() async {
    setState(() {
      isSearching = true;
      foundProduct = null;
      scanResult = "Наведите камеру на код";
    });

    try {
      final result = await BarcodeScanner.scan();
      final barcode = result.rawContent;

      scanResult = barcode.isEmpty ? "Сканирование отменено" : barcode;

      final token = Provider.of<UserProvider>(context, listen: false).token;
      if (token != null && barcode.isNotEmpty) {
        final service = GoodsService(token: token);
        final results = await service.searchGoods(barcode: barcode);

        if (results.isNotEmpty) {
          setState(() {
            foundProduct = results.first;
            isSearching = false;
          });
          return;
        }
      }
    } catch (e) {
      scanResult = "Ошибка: $e";
    }

    setState(() {
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Сканер товаров"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: scan),
        ],
      ),
      body: isSearching
          ? Center(child: CircularProgressIndicator())
          : foundProduct == null
          ? Center(child: Text(scanResult))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🖼 Картинка товара
          Image.asset(
            foundProduct!['attachments'] ?? '',
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 250,
              color: Colors.grey[200],
              child: Icon(Icons.broken_image, size: 100),
            ),
          ),

          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Штрихкод:", style: TextStyle(color: Colors.grey)),
                Text(
                  scanResult,
                  style: TextStyle(fontSize: 18,),
                ),
                SizedBox(height: 12),
                Text("Наименование:", style: TextStyle(color: Colors.grey)),
                Text(
                  foundProduct!['name'] ?? '',
                  style: TextStyle(fontSize: 22,),
                ),
                SizedBox(height: 12),
                Text("Цена:", style: TextStyle(color: Colors.grey)),
                Text(
                  "${foundProduct!['price']} ₽",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 12),
                Text("Остаток:", style: TextStyle(color: Colors.grey)),
                Text(
                  "${foundProduct!['stock']} шт.",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: scan,
                icon: Icon(Icons.qr_code_scanner, color: Colors.white),
                label: Text("Сканировать снова", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: foundProduct == null
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(productId: foundProduct!['id']),
                    ),
                  );
                },
                icon: Icon(Icons.open_in_new, color: Colors.white),
                label: Text("Открыть карточку", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
