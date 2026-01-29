import 'package:flutter/material.dart';

class StorageSidePanel extends StatelessWidget {
  final String selectedItem;
  final Function(String) onItemSelected;
  final VoidCallback onMenuTap;

  const StorageSidePanel({
    super.key,
    required this.selectedItem,
    required this.onItemSelected,
    required this.onMenuTap,
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
          // Header
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
                  Icons.settings_rounded,
                  color: Color(0xFF4A7C59),
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  'Settings',
                  style: TextStyle(
                    color: Color(0xFF2C1810),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildNavItem(
                    icon: Icons.warehouse_rounded,
                    label: 'Storage',
                    isSelected: selectedItem == 'storage',
                    onTap: () => onItemSelected('storage'),
                  ),
                  const SizedBox(height: 6),
                  _buildNavItem(
                    icon: Icons.edit_note_rounded,
                    label: 'Change Menu',
                    isSelected: selectedItem == 'change_menu',
                    onTap: () => onItemSelected('change_menu'),
                  ),
                  const SizedBox(height: 6),
                  _buildNavItem(
                    icon: Icons.calculate_rounded,
                    label: 'Calculator',
                    isSelected: selectedItem == 'calculator',
                    onTap: () => onItemSelected('calculator'),
                  ),
                ],
              ),
            ),
          ),
          
          // Divider
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            color: const Color(0xFFE8E0D8),
          ),
          
          // Menu button at bottom
          Padding(
            padding: const EdgeInsets.all(12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onMenuTap,
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
                        Icons.menu_book_rounded,
                        size: 20,
                        color: Color(0xFF4A7C59),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Menu',
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

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4A7C59) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : const Color(0xFF8B7355),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF5A4A3A),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
