import 'package:flutter/material.dart';
import 'dart:async';
import '../models/product.dart';
import '../services/inventory_service.dart';


// Add-on model
class AddOn {
  final String id;
  final String name;
  final double price;

  AddOn({required this.id, required this.name, required this.price});
}

// Available add-ons based on Mr. Buenaz menu
final List<AddOn> availableAddOns = [
  AddOn(id: '1', name: 'Pearl', price: 10),
  AddOn(id: '2', name: 'Crystal', price: 10),
  AddOn(id: '3', name: 'Coffee Jelly', price: 10),
  AddOn(id: '4', name: 'Popping Boba', price: 10),
  AddOn(id: '5', name: 'Crushed Oreo', price: 10),
  AddOn(id: '6', name: 'Cream Cheese', price: 15),
  AddOn(id: '7', name: 'Espresso Shot', price: 15),
  AddOn(id: '8', name: 'Whipped Cream', price: 15),
];

class ProductDetailDialog extends StatefulWidget {
  final Product product;

  const ProductDetailDialog({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailDialog> createState() => _ProductDetailDialogState();
}

class _ProductDetailDialogState extends State<ProductDetailDialog> {
  bool _isTallSelected = true;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  final Set<String> _selectedAddOns = {};
  Timer? _autoSwipeTimer;

  double get _basePrice => _isTallSelected 
      ? widget.product.priceTall 
      : widget.product.priceGrande;

  double get _addOnsTotal {
    double total = 0;
    for (final addOnId in _selectedAddOns) {
      final addOn = availableAddOns.firstWhere((a) => a.id == addOnId);
      total += addOn.price;
    }
    return total;
  }

  double get _totalPrice => _basePrice + _addOnsTotal;

  String get _smallSizeLabel => widget.product.categoryId == '7' ? 'Small' : '16oz';
  String get _largeSizeLabel => widget.product.categoryId == '7' ? 'Large' : '22oz';

  IconData _getCategoryIcon() {
    switch (widget.product.categoryId) {
      case '2': return Icons.coffee_rounded;
      case '3': return Icons.bubble_chart_rounded;
      case '4': return Icons.blender_rounded;
      case '5': return Icons.local_florist_rounded;
      case '6': return Icons.coffee_maker_rounded;
      case '7': return Icons.breakfast_dining_rounded;
      default: return Icons.local_cafe_rounded;
    }
  }

  void _toggleAddOn(String addOnId) {
    setState(() {
      if (_selectedAddOns.contains(addOnId)) {
        _selectedAddOns.remove(addOnId);
      } else {
        _selectedAddOns.add(addOnId);
      }
    });
  }

  void _startAutoSwipe() {
    _autoSwipeTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentImageIndex + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoSwipe();
  }

  @override
  void dispose() {
    _autoSwipeTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image carousel - swipable with auto-scroll
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F0EB),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 3,
                    onPageChanged: (index) {
                      setState(() => _currentImageIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getCategoryIcon(),
                              size: 40,
                              color: const Color(0xFF4A7C59).withOpacity(0.4),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A7C59).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Image ${index + 1}',
                                style: const TextStyle(
                                  color: Color(0xFF4A7C59),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Page indicators
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: _currentImageIndex == index ? 16 : 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: _currentImageIndex == index
                              ? const Color(0xFF4A7C59)
                              : const Color(0xFF4A7C59).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                ),
                // Close button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF2C1810)),
                    ),
                  ),
                ),
                // Badges
                if (widget.product.isPopular)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A7C59),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded, size: 10, color: Colors.white),
                          SizedBox(width: 2),
                          Text('Popular', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name and description
                  Text(
                    widget.product.name,
                    style: const TextStyle(color: Color(0xFF2C1810), fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 50,
                    child: SingleChildScrollView(
                      child: Text(
                        widget.product.description,
                        style: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.9), fontSize: 11, height: 1.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Size selector row
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0EB),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _isTallSelected = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _isTallSelected ? const Color(0xFF4A7C59) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _smallSizeLabel,
                                  style: TextStyle(
                                    color: _isTallSelected ? Colors.white : const Color(0xFF8B7355),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _isTallSelected = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: !_isTallSelected ? const Color(0xFF4A7C59) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _largeSizeLabel,
                                  style: TextStyle(
                                    color: !_isTallSelected ? Colors.white : const Color(0xFF8B7355),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₱${_basePrice.toInt()}',
                        style: const TextStyle(color: Color(0xFF4A7C59), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Add-ons section
                  const Text('Add-ons', style: TextStyle(color: Color(0xFF2C1810), fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: availableAddOns.map((addOn) {
                      final isSelected = _selectedAddOns.contains(addOn.id);
                      final isAddOnAvailable = inventoryService.isAddOnAvailable(addOn.id);
                      final unavailableReason = inventoryService.getAddOnUnavailableReason(addOn.id);
                      
                      return GestureDetector(
                        onTap: isAddOnAvailable ? () => _toggleAddOn(addOn.id) : null,
                        child: Opacity(
                          opacity: isAddOnAvailable ? 1.0 : 0.5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: !isAddOnAvailable 
                                  ? const Color(0xFFE0E0E0)
                                  : (isSelected ? const Color(0xFF4A7C59) : const Color(0xFFF5F0EB)),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: !isAddOnAvailable 
                                    ? const Color(0xFFBDBDBD)
                                    : (isSelected ? const Color(0xFF4A7C59) : const Color(0xFFE0D5C8)),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isAddOnAvailable) ...[
                                  const Icon(Icons.block, size: 10, color: Color(0xFF999999)),
                                  const SizedBox(width: 3),
                                ],
                                Text(
                                  !isAddOnAvailable 
                                      ? 'No ${unavailableReason ?? addOn.name}'
                                      : '${addOn.name} +₱${addOn.price.toInt()}',
                                  style: TextStyle(
                                    color: !isAddOnAvailable 
                                        ? const Color(0xFF999999)
                                        : (isSelected ? Colors.white : const Color(0xFF5A4A3A)),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    decoration: !isAddOnAvailable ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 10),

                  // Total row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _addOnsTotal > 0 ? 'Total (₱${_basePrice.toInt()} + ₱${_addOnsTotal.toInt()})' : 'Total',
                        style: const TextStyle(color: Color(0xFF8B7355), fontSize: 11),
                      ),
                      Text(
                        '₱${_totalPrice.toInt()}',
                        style: const TextStyle(color: Color(0xFF4A7C59), fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F0EB),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE0D5C8)),
                            ),
                            child: const Center(
                              child: Text('Cancel', style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            final selectedAddOnsList = availableAddOns.where((a) => _selectedAddOns.contains(a.id)).toList();
                            Navigator.pop(context, {
                              'product': widget.product,
                              'size': _isTallSelected ? 'tall' : 'grande',
                              'basePrice': _basePrice,
                              'addOns': selectedAddOnsList,
                              'addOnsTotal': _addOnsTotal,
                              'totalPrice': _totalPrice,
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A7C59),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_rounded, color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Show the product detail dialog
Future<Map<String, dynamic>?> showProductDetail(BuildContext context, Product product) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => ProductDetailDialog(product: product),
  );
}
