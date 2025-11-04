import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final Function(String) onCategorySelected;

  const CategoryFilter({
    Key? key,
    required this.selectedCategory,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: categories.map((category) {
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onCategorySelected(category),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primaryColor : AppColors.gray100,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      isSelected ? null : Border.all(color: AppColors.gray300),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color:
                          isSelected ? AppColors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
