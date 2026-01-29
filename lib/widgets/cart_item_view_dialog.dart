import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../widgets/product_detail_dialog.dart';

// View-only dialog for cart item details
class CartItemViewDialog extends StatelessWidget {
  final CartItem cartItem;

  const CartItemViewDialog({super.key, required this.cartItem});

  IconData _getCategoryIcon() {
    switch (cartItem.product.categoryId) {
      case '2': return Icons.coffee_rounded;
      case '3': return Icons.bubble_chart_rounded;
      case '4': return Icons.blender_rounded;
      case '5': return Icons.local_florist_rounded;
      case '6': return Icons.coffee_maker_rounded;
      case '7': return Icons.breakfast_dining_rounded;
      default: return Icons.local_cafe_rounded;
    }
  }

  String get _sizeLabel {
    if (cartItem.product.categoryId == '7') {
      return cartItem.size == 'tall' ? 'Small' : 'Large';
    }
    return cartItem.size == 'tall' ? '16oz' : '22oz';
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
            // Image section
            Container(
              height: 140,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F0EB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getCategoryIcon(),
                          size: 50,
                          color: const Color(0xFF4A7C59).withOpacity(0.4),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A7C59).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _sizeLabel,
                            style: const TextStyle(
                              color: Color(0xFF4A7C59),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Close button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, size: 16, color: Color(0xFF2C1810)),
                      ),
                    ),
                  ),
                  // Quantity badge
                  if (cartItem.quantity > 1)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7C59),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${cartItem.quantity}x',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    cartItem.product.name,
                    style: const TextStyle(color: Color(0xFF2C1810), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  // Description
                  Container(
                    height: 60,
                    child: SingleChildScrollView(
                      child: Text(
                        cartItem.product.description,
                        style: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.9), fontSize: 12, height: 1.4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Add-ons (highlighted)
                  if (cartItem.addOns.isNotEmpty) ...[
                    const Text('Add-ons', style: TextStyle(color: Color(0xFF2C1810), fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: cartItem.addOns.map((addOn) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A7C59),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '${addOn.name} +₱${addOn.price.toInt()}',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Price breakdown
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0EB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Base Price ($_sizeLabel)', style: TextStyle(color: const Color(0xFF8B7355), fontSize: 12)),
                            Text('₱${cartItem.basePrice.toInt()}', style: const TextStyle(color: Color(0xFF5A4A3A), fontSize: 12)),
                          ],
                        ),
                        if (cartItem.addOns.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Add-ons', style: TextStyle(color: Color(0xFF8B7355), fontSize: 12)),
                              Text('₱${cartItem.addOnsTotal.toInt()}', style: const TextStyle(color: Color(0xFF5A4A3A), fontSize: 12)),
                            ],
                          ),
                        ],
                        if (cartItem.quantity > 1) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Quantity', style: TextStyle(color: Color(0xFF8B7355), fontSize: 12)),
                              Text('x${cartItem.quantity}', style: const TextStyle(color: Color(0xFF5A4A3A), fontSize: 12)),
                            ],
                          ),
                        ],
                        const Divider(height: 16, color: Color(0xFFE0D5C8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(color: Color(0xFF2C1810), fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(
                              '₱${(cartItem.totalPrice * cartItem.quantity).toInt()}',
                              style: const TextStyle(color: Color(0xFF4A7C59), fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
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

// Show view-only cart item dialog
Future<void> showCartItemView(BuildContext context, CartItem cartItem) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => CartItemViewDialog(cartItem: cartItem),
  );
}
