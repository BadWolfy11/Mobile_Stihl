import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Product {
  final String code;
  final String name;
  final String? description;

  Product({required this.code, required this.name, this.description});
}

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<ScanScreen> {
  String scanResult = "Наведите камеру на код";
  String productName = "";
  List<Product> products = [
    Product(code: "4601234567890", name: "Молоко Простоквашино 1л"),
    Product(code: "4609876543210", name: "Хлеб Бородинский"),
    Product(code: "890123456789", name: "Чай Greenfield Classic"),
    Product(code: "HG620099109993J000P00000", name: "Акция: 2 пиццы по цене 1"),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => scan());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Сканер товаров"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: scan,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Индикатор сканирования
            if (scanResult == "Наведите камеру на код")
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Идёт поиск кода..."),
                ],
              ),

            // Результаты
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Считанный код:",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    scanResult,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Divider(),

            // Название товара
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "Найденный товар:",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    productName.isNotEmpty ? productName : "Не найден",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: productName.isNotEmpty && productName != "Не найден"
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            // Кнопка повторного сканирования
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text("Сканировать снова"),
                onPressed: scan,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scan() async {
    setState(() {
      scanResult = "Наведите камеру на код";
      productName = "";
    });

    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': 'Отмена',
            'flash_on': 'Вспышка вкл',
            'flash_off': 'Вспышка выкл',
          },
          restrictFormat: [],
          useCamera: -1,
        ),
      );

      // Поиск товара в списке
      Product? foundProduct;
      for (var product in products) {
        if (product.code == result.rawContent) {
          foundProduct = product;
          break;
        }
      }

      setState(() {
        scanResult = result.rawContent;
        productName = foundProduct?.name ?? "Не найден";
      });

      // Вибрация при успешном сканировании
      // HapticFeedback.vibrate();

    } on PlatformException catch (e) {
      setState(() {
        scanResult = "Ошибка: ${e.message ?? "Нет доступа к камере"}";
      });
    } on FormatException {
      // Пользователь закрыл сканер
    } catch (e) {
      setState(() {
        scanResult = "Ошибка: $e";
      });
    }
  }
}