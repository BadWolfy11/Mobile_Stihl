
import 'package:flutter/material.dart';

import '../../theme/light_color.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onIconPressed;

  const CustomBottomNavigationBar({Key? key, required this.onIconPressed}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    widget.onIconPressed(index);
  }

  Widget _buildIcon(IconData icon, int index) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: isSelected ? 50 : 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? LightColor.orange : Colors.white,
            shape: BoxShape.circle,
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Color(0xfffeece2),
                blurRadius: 10,
                spreadRadius: 5,
                offset: Offset(3, 3),
              )
            ]
                : [],
          ),
          child: Icon(
            icon,
            color: isSelected ? LightColor.background : Colors.black54,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIcon(Icons.home, 0),
          _buildIcon(Icons.search, 1),
          _buildIcon(Icons.shopping_cart, 2),
          _buildIcon(Icons.edit_document, 3),
        ],
      ),
    );
  }
}
