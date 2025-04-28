import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stihl_mobile/pages/scan_Page.dart';

// import '../widgets/big_card.dart';
// import '../widgets/history_list.dart';

class ScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget page;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Первый лейбл
          Text(
            'Сканер',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),

          // Второй лейбл
          Text(
            'номер штрихкода',
            style: TextStyle(fontSize: 20),
          ),

          // Кнопка по центру
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScanScreen()));
                  print('Кнопка нажата');
            },
            child: Text('Открыть камеру'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
          SizedBox(height: 20),


        ],
      ),
    );
  }
}