import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../widgets/product_detail_dialog.dart';
import '../widgets/cart_item_view_dialog.dart';
import '../widgets/receipt_dialog.dart';
import '../widgets/sticker_dialog.dart';
import '../services/inventory_service.dart';



class CartDialog extends StatefulWidget {
  final Cart cart;
  final Function() onClearCart;
  final Function(String) onRemoveItem;
  final Function(Order) onCheckout;

  const CartDialog({
    super.key,
    required this.cart,
    required this.onClearCart,
    required this.onRemoveItem,
    required this.onCheckout,
  });

  @override
  State<CartDialog> createState() => _CartDialogState();
}

class _CartDialogState extends State<CartDialog> {
  bool _isProcessingCheckout = false;
  final TextEditingController _customerNameController = TextEditingController();
  String? _nameErrorText;

  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String categoryId) {
    switch (categoryId) {
      case '2': return Icons.coffee_rounded;
      case '3': return Icons.bubble_chart_rounded;
      case '4': return Icons.blender_rounded;
      case '5': return Icons.local_florist_rounded;
      case '6': return Icons.coffee_maker_rounded;
      case '7': return Icons.breakfast_dining_rounded;
      default: return Icons.local_cafe_rounded;
    }
  }

  Color _getCategoryColor(String categoryId) {
    switch (categoryId) {
      case '2': return const Color(0xFF5D4037); // Coffee brown
      case '3': return const Color(0xFF5D4037); // Brown for milk tea (readable)
      case '4': return const Color(0xFFBF360C); // Deep orange
      case '5': return const Color(0xFF2E7D32); // Dark green
      case '6': return const Color(0xFF37474F); // Dark blue grey
      case '7': return const Color(0xFF8D6E63); // Brown
      default: return const Color(0xFF4A7C59);
    }
  }

  String _getSizeLabel(CartItem item) {
    if (item.product.categoryId == '7') {
      return item.size == 'tall' ? 'Small' : 'Large';
    }
    return item.size == 'tall' ? '16oz' : '22oz';
  }

  void _handleClear() {
    widget.onClearCart();
    setState(() {});
  }

  void _handleRemove(String itemId) {
    widget.onRemoveItem(itemId);
    setState(() {});
  }

  void _handleCheckout() async {
    if (widget.cart.items.isEmpty) return;
    
    // Validate customer name
    final customerName = _customerNameController.text.trim();
    if (customerName.isEmpty) {
      setState(() {
        _nameErrorText = 'Name is required';
      });
      return;
    }
    
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: customerName,
      items: List.from(widget.cart.items),
      totalAmount: widget.cart.totalAmount,
      dateTime: DateTime.now(),
    );

    setState(() => _isProcessingCheckout = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Deduct ingredients from storage after successful checkout
    inventoryService.deductForOrder(order);
    
    widget.onCheckout(order);
    setState(() => _isProcessingCheckout = false);
    
    if (mounted) {
      // Close cart dialog and return the order for receipt display
      Navigator.pop(context, order);
    }
  }





  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final groupedItems = widget.cart.groupedByProduct;
    final productIds = groupedItems.keys.toList();
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * 0.6,
        height: screenHeight * 0.6,
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
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A7C59),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shopping_cart_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Your Cart',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.cart.itemCount} item${widget.cart.itemCount != 1 ? 's' : ''}',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                // Customer Name Input
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customer Name',
                        style: TextStyle(
                          color: Color(0xFF2C1810),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _customerNameController,
                        onChanged: (value) {
                          if (_nameErrorText != null) {
                            setState(() => _nameErrorText = null);
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter name for callout',
                          hintStyle: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.5)),
                          errorText: _nameErrorText,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          fillColor: const Color(0xFFF9F6F3),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: const Color(0xFF4A7C59).withOpacity(0.2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: const Color(0xFF4A7C59).withOpacity(0.2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFF4A7C59), width: 1.5),
                          ),
                          prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFF4A7C59), size: 20),
                        ),
                      ),
                      const Divider(height: 24, color: Color(0xFFE8E0D8)),
                    ],
                  ),
                ),

                // Cart items - touch scrollable
                Expanded(
                  child: widget.cart.items.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 60, color: Color(0xFFD0C5B8)),
                              SizedBox(height: 12),
                              Text('Your cart is empty', style: TextStyle(color: Color(0xFF8B7355), fontSize: 14)),
                            ],
                          ),
                        )
                      : ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                              PointerDeviceKind.stylus,
                              PointerDeviceKind.trackpad,
                            },
                          ),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            padding: const EdgeInsets.all(12),
                            itemCount: productIds.length,
                            itemBuilder: (context, index) {
                              final productId = productIds[index];
                              final itemsForProduct = groupedItems[productId]!;
                              return _buildProductGroup(context, itemsForProduct);
                            },
                          ),
                        ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F0EB),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      if (widget.cart.items.isNotEmpty) ...[
                        GestureDetector(
                          onTap: _handleClear,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFE0D5C8)),
                            ),
                            child: const Text('Clear', style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: _handleCheckout,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A7C59),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Checkout', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                      const Spacer(),
                      const Text('Total: ', style: TextStyle(color: Color(0xFF8B7355), fontSize: 13)),
                      Text(
                        '₱${widget.cart.totalAmount.toInt()}',
                        style: const TextStyle(color: Color(0xFF4A7C59), fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Processing checkout overlay
            if (_isProcessingCheckout)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.print_rounded, size: 50, color: Color(0xFF4A7C59)),
                      SizedBox(height: 16),
                      Text(
                        'Printing Receipt...',
                        style: TextStyle(color: Color(0xFF4A7C59), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 150,
                        child: LinearProgressIndicator(
                          backgroundColor: Color(0xFFE8E0D8),
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A7C59)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGroup(BuildContext context, List<CartItem> items) {
    if (items.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _buildCartItem(context, items.first),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _buildCartItem(context, item),
        )).toList(),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    final categoryColor = _getCategoryColor(item.product.categoryId);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Item box - clickable
        Expanded(
          child: GestureDetector(
            onTap: () => showCartItemView(context, item),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F6F3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: categoryColor.withOpacity(0.3), width: 1.5),
              ),
              child: Row(
                children: [
                  // Big product image on left
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            _getCategoryIcon(item.product.categoryId),
                            size: 34,
                            color: categoryColor.withOpacity(0.7),
                          ),
                        ),
                        if (item.quantity > 1)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: categoryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${item.quantity}x',
                                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Product details - Title, Description (middle), Add-ons, Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and size
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.product.name,
                                style: const TextStyle(color: Color(0xFF2C1810), fontSize: 13, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getSizeLabel(item),
                                style: TextStyle(color: categoryColor, fontSize: 9, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Description in the MIDDLE
                        Text(
                          item.product.description,
                          style: const TextStyle(color: Color(0xFF8B7355), fontSize: 10),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Add-ons and price at bottom
                        Row(
                          children: [
                            Expanded(
                              child: item.addOns.isNotEmpty
                                  ? Wrap(
                                      spacing: 4,
                                      runSpacing: 2,
                                      children: item.addOns.map((addOn) => Text(
                                        '+${addOn.name}',
                                        style: const TextStyle(color: Color(0xFF4A7C59), fontSize: 9, fontWeight: FontWeight.w500),
                                      )).toList(),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Text(
                              '₱${(item.totalPrice * item.quantity).toInt()}',
                              style: TextStyle(color: categoryColor, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Delete button
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _handleRemove(item.id),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFD35555)),
          ),
        ),
      ],
    );
  }
}

// Show the cart dialog
Future<void> showCartDialog(BuildContext context, Cart cart, Function() onClearCart, Function(String) onRemoveItem, Function(Order) onCheckout) async {
  final result = await showDialog<Order>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => CartDialog(
      cart: cart,
      onClearCart: onClearCart,
      onRemoveItem: onRemoveItem,
      onCheckout: onCheckout,
    ),
  );
  
  // If checkout was completed
  if (result != null) {
    // 1. Show Receipt
    await showReceiptDialog(context, result);
    
    // 2. Show Cup Stickers
    await showStickerDialog(context, result);
  }
}


