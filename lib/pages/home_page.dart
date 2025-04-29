import 'package:flutter/material.dart';
import 'package:stihl_mobile/pages/expenses_page.dart';
import 'package:stihl_mobile/pages/goods/goods_page.dart';
import 'package:stihl_mobile/pages/scanner/scanner_page.dart';

import '../widgets/BottomNavigationBar/bottom_navigation_bar.dart';


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = ScannerPage();
        break;
      case 1:
        page = GoodsPage();
        break;
      case 2:
        page = ExpensesPage();
        break;
      case 3:
        page = Center(child: Text("Остальные затраты")); // Заменить на нужную страницу
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.secondary,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: CustomBottomNavigationBar(
                    onIconPresedCallback: (int index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    selectedIconTheme: IconThemeData(color: Colors.orange),
                    unselectedIconTheme: IconThemeData(color: Colors.white70),
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Главная'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.shopping_cart),
                        label: Text('Товары'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.edit_document),
                        label: Text('Документы'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.all_inbox_rounded),
                        label: Text('Остальные'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
