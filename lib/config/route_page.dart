import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stihl_mobile/pages/goods/goods_page.dart';
import 'package:stihl_mobile/pages/main_page.dart';

import '../pages/export/document_export.dart';
import '../widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import '../pages/expenses/expenses_page.dart';
import '../config/user_provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    final roleId = Provider.of<UserProvider>(context).roleId;

    List<Widget> allowedPages = [MainPage(), GoodsPage()];
    List<NavigationRailDestination> allowedDestinations = [
      NavigationRailDestination(icon: Icon(Icons.home), label: Text('Главная')),
      NavigationRailDestination(icon: Icon(Icons.shopping_cart), label: Text('Товары')),
    ];

    if (roleId != 1001) {
      // если не консультант, добавляем остальные вкладки
      allowedPages.addAll([ExpensesPage(), DocumentsExportPage()]);
      allowedDestinations.addAll([
        NavigationRailDestination(icon: Icon(Icons.edit_document), label: Text('Документы')),
        NavigationRailDestination(icon: Icon(Icons.all_inbox_rounded), label: Text('Остальные')),
      ]);
    }

    if (selectedIndex >= allowedPages.length) selectedIndex = 0;
    final page = allowedPages[selectedIndex];

    final mainArea = ColoredBox(
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
                    onIconPressed: (int index) {
                      if (index < allowedPages.length) {
                        setState(() {
                          selectedIndex = index;
                        });
                      }
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
                    destinations: allowedDestinations,
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
