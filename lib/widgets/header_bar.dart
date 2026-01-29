import 'package:flutter/material.dart';

class HeaderBar extends StatefulWidget {
  final int cartItemCount;
  final VoidCallback onCartTap;
  final VoidCallback onOrdersTap;
  final Function(String) onSearch;

  const HeaderBar({
    super.key,
    required this.cartItemCount,
    required this.onCartTap,
    required this.onOrdersTap,
    required this.onSearch,
  });

  @override
  State<HeaderBar> createState() => _HeaderBarState();
}

class _HeaderBarState extends State<HeaderBar> {
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (_isSearchExpanded) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        widget.onSearch('');
        _searchFocusNode.unfocus();
      }
    });
  }

  void _onSearchChanged(String value) {
    widget.onSearch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo and Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A7C59), Color(0xFF3D6B4F)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_cafe_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MR. BUENAZ',
                    style: TextStyle(
                      color: Color(0xFF2C1810),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'Drop by and have a taste!',
                    style: TextStyle(
                      color: Color(0xFF8B7355),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const Spacer(),
          
          // Action Buttons
          Row(
            children: [
              // Search bar - expandable
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isSearchExpanded ? 250 : 100,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0EB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isSearchExpanded ? const Color(0xFF4A7C59) : const Color(0xFFE0D5C8),
                    width: _isSearchExpanded ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Search icon button
                    GestureDetector(
                      onTap: _toggleSearch,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          _isSearchExpanded ? Icons.close_rounded : Icons.search_rounded,
                          color: const Color(0xFF4A7C59),
                          size: 20,
                        ),
                      ),
                    ),
                    // Search text field
                    Expanded(
                      child: _isSearchExpanded
                          ? TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onChanged: _onSearchChanged,
                              style: const TextStyle(
                                color: Color(0xFF2C1810),
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search products...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF8B7355),
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                            )
                          : GestureDetector(
                              onTap: _toggleSearch,
                              child: const Text(
                                'Search',
                                style: TextStyle(
                                  color: Color(0xFF5A4A3A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildHeaderButton(
                icon: Icons.receipt_long_rounded,
                label: 'Orders',
                onTap: widget.onOrdersTap,
              ),
              const SizedBox(width: 12),
              _buildHeaderButton(
                icon: Icons.shopping_cart_rounded,
                label: 'Cart',
                badgeCount: widget.cartItemCount,
                onTap: widget.onCartTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String label,
    int? badgeCount,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F0EB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE0D5C8),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    color: const Color(0xFF4A7C59),
                    size: 20,
                  ),
                  if (badgeCount != null && badgeCount > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A7C59),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF5A4A3A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
