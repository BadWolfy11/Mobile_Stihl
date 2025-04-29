import 'package:flutter/material.dart';

class SearchFilterWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onFilterSelected;

  const SearchFilterWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onFilterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Поиск продуктов",
                  hintStyle: TextStyle(fontSize: 12),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black54),
            onPressed: onFilterSelected,
          ),
        ],
      ),
    );
  }
}
