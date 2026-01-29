import 'package:flutter/material.dart';
import '../models/category.dart';

class SidePanel extends StatelessWidget {
  final List<Category> categories;
  final String selectedCategoryId;
  final Function(String) onCategorySelected;
  final VoidCallback onStorageTap;

  const SidePanel({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.onStorageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Category header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE8E0D8), width: 1),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF4A7C59),
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Color(0xFF2C1810),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Category list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category.id == selectedCategoryId;
                final isSpecial = category.isSpecial;
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected 
                        ? const Color(0xFF4A7C59)
                        : isSpecial
                            ? const Color(0xFFFFF8E7)
                            : Colors.transparent,
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFF4A7C59)
                          : isSpecial
                              ? const Color(0xFFE8A850)
                              : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => onCategorySelected(category.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected 
                                    ? Colors.white
                                    : isSpecial
                                        ? const Color(0xFFE8A850)
                                        : const Color(0xFFBBB0A0),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                category.name,
                                style: TextStyle(
                                  color: isSelected 
                                      ? Colors.white
                                      : isSpecial
                                          ? const Color(0xFFD4940A)
                                          : const Color(0xFF5A4A3A),
                                  fontSize: 14,
                                  fontWeight: isSelected || isSpecial
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isSpecial && !isSelected)
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFE8A850),
                                size: 14,
                              ),
                            if (isSelected)
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Divider
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            color: const Color(0xFFE8E0D8),
          ),
          
          // Storage button at bottom
          Padding(
            padding: const EdgeInsets.all(12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onStorageTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A7C59).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF4A7C59).withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.warehouse_rounded,
                        size: 20,
                        color: Color(0xFF4A7C59),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Storage',
                          style: TextStyle(
                            color: Color(0xFF4A7C59),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Color(0xFF4A7C59),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
