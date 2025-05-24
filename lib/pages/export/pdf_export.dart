import 'dart:io';
import 'dart:math';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart' show rootBundle;

class PDFExportService {
  static String _randomFileName(String prefix) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    return '$prefix-$timestamp-$random.pdf';
  }

  static Future<File> exportGoods(List<Map<String, dynamic>> goods) async {
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: await pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Regular.ttf")),
      ),
    );
    double totalQuantity = 0;
    double totalUnitPrice = 0;
    double totalPrice = 0;

    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Text(
          'Отчёт по товарам',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        build: (context) {
          final List<pw.Widget> content = [];

          for (var item in goods) {
            final name = item['name'] ?? '—';
            final quantity = (item['stock'] ?? 0).toDouble();
            final price = (item['price'] ?? 0).toDouble();

            totalQuantity += quantity;
            totalUnitPrice += price;
            totalPrice += quantity * price;

            content.add(pw.Text('Товар: $name — Кол-во: $quantity — Цена за шт: $price — Итого: ${quantity * price}'));
            content.add(pw.Divider());
          }

          content.add(pw.SizedBox(height: 20));
          content.add(pw.Text('Итого товаров: ${goods.length}'));
          content.add(pw.Text('Общее количество: $totalQuantity'));
          content.add(pw.Text('Общая стоимость за единицу: $totalUnitPrice'));
          content.add(pw.Text('Общая стоимость: $totalPrice'));

          return content;
        },
      ),
    );


    final output = await getDownloadsDirectory();
    final fileName = _randomFileName('goods_export');
    final file = File('${output?.path}/$fileName');

    await file.writeAsBytes(await pdf.save());
    _tryOpenFile(file);
    return file;
  }

  static Future<File> exportExpenses(List<Map<String, dynamic>> expenses) async {
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: await pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Regular.ttf")),
      ),
    );
    double totalExpenses = 0;

    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Text(
          'Отчёт по товарам',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        build: (context) {
          final List<pw.Widget> content = [];

          for (var item in expenses) {
            final name = item['name'] ?? '—';
            final amount = (item['amount'] ?? 0).toDouble();
            totalExpenses += amount;

            content.add(pw.Text('Затрата: $name — Сумма: $amount'));
            content.add(pw.Divider());
          }

          content.add(pw.SizedBox(height: 20));
          content.add(pw.Text('Итого затрат: ${expenses.length}'));
          content.add(pw.Text('Общая сумма затрат: $totalExpenses'));

          return content;
        },
      ),
    );

    final output = await getDownloadsDirectory();
    final fileName = _randomFileName('expenses_export');
    final file = File('${output?.path}/$fileName');

    await file.writeAsBytes(await pdf.save());
    _tryOpenFile(file);
    return file;
  }

  static Future<void> _tryOpenFile(File file) async {
    try {
      await OpenFile.open(file.path);
    } catch (e) {
      print('Ошибка при открытии файла: $e');
    }
  }
}
