import 'package:flutter/material.dart';

class SearchFilterWidget extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterSelected;
  final List<String> categories;
  final bool needDropdown;

  const SearchFilterWidget({
    Key? key,
    required this.onSearchChanged,
    required this.onFilterSelected,
    required this.categories,
    this.needDropdown = true, // значение по умолчанию
  }) : super(key: key);

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categories.isNotEmpty
        ? widget.categories.first
        : 'Все';
  }

  @override
  Widget build(BuildContext context) {
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
                    onChanged: widget.onSearchChanged,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Поиск",
                      hintStyle: TextStyle(fontSize: 12),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      prefixIcon: Icon(Icons.search, color: Colors.black54),
                    ),
                  ),
                ),
              ),
              SizedBox(width: (widget.needDropdown && widget.categories.isNotEmpty ? 20.0 : 0.0) ),
              if (widget.needDropdown && widget.categories.isNotEmpty)
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                      });
                      widget.onFilterSelected(value);
                    }
                  },
                  items: widget.categories
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
