import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';


class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.category,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(category),
        onSelected: (bool selected) {
          // Handle category selection
        },
        backgroundColor: Theme.of(context).cardColor,
        selectedColor: AppPalette.gradient2,
      ),
    );
  }
}