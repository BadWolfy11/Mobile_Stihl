import 'package:flutter/material.dart';

class SearchFilterWidget extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterSelected;
  final List<String> categories;

  const SearchFilterWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onFilterSelected,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String selectedCategory = categories.first;

    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
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
                      hintText: "Поиск",
                      hintStyle: TextStyle(fontSize: 12),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      prefixIcon: Icon(Icons.search, color: Colors.black54),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                    onFilterSelected(value);
                  }
                },
                items: categories
                    .map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}