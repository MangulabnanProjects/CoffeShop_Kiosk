import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../models/order.dart';
import '../models/cart.dart';
import '../widgets/product_detail_dialog.dart';

class OrdersDialog extends StatefulWidget {
  final OrderHistory orderHistory;

  const OrdersDialog({super.key, required this.orderHistory});

  @override
  State<OrdersDialog> createState() => _OrdersDialogState();
}

class _OrdersDialogState extends State<OrdersDialog> {
  final Set<String> _expandedOrders = {};

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

  String _getSizeLabel(CartItem item) {
    if (item.product.categoryId == '7') {
      return item.size == 'tall' ? 'Small' : 'Large';
    }
    return item.size == 'tall' ? '16oz' : '22oz';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * 0.7,
        height: screenHeight * 0.7,
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
                  const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Order History',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${widget.orderHistory.orders.length} transaction${widget.orderHistory.orders.length != 1 ? 's' : ''}',
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

            // Orders list
            Expanded(
              child: widget.orderHistory.orders.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 60, color: Color(0xFFD0C5B8)),
                          SizedBox(height: 12),
                          Text('No orders yet', style: TextStyle(color: Color(0xFF8B7355), fontSize: 14)),
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
                        padding: const EdgeInsets.all(16),
                        itemCount: widget.orderHistory.orders.length,
                        itemBuilder: (context, index) {
                          final order = widget.orderHistory.orders[index];
                          return _buildOrderCard(order);
                        },
                      ),
                    ),
            ),

            // Footer summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F0EB),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today: ${widget.orderHistory.todayOrders.length} orders',
                        style: const TextStyle(color: Color(0xFF8B7355), fontSize: 11),
                      ),
                      Text(
                        'This Week: ${widget.orderHistory.thisWeekOrders.length} orders',
                        style: const TextStyle(color: Color(0xFF8B7355), fontSize: 11),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Total Sales', style: TextStyle(color: Color(0xFF8B7355), fontSize: 11)),
                      Text(
                        '₱${widget.orderHistory.orders.fold<double>(0, (sum, o) => sum + o.totalAmount).toInt()}',
                        style: const TextStyle(color: Color(0xFF4A7C59), fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildOrderCard(Order order) {
    final isExpanded = _expandedOrders.contains(order.id);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6F3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E0D8)),
      ),
      child: Column(
        children: [
          // Order header (clickable to expand)
          GestureDetector(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedOrders.remove(order.id);
                } else {
                  _expandedOrders.add(order.id);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isExpanded ? const Color(0xFF4A7C59).withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(12),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A7C59).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.receipt_rounded,
                      size: 20,
                      color: const Color(0xFF4A7C59).withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id.substring(order.id.length - 6)}',
                          style: const TextStyle(color: Color(0xFF2C1810), fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${order.formattedDate} • ${order.formattedTime}',
                          style: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.8), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₱${order.totalAmount.toInt()}',
                        style: const TextStyle(color: Color(0xFF4A7C59), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${order.items.fold<int>(0, (sum, i) => sum + i.quantity)} item${order.items.fold<int>(0, (sum, i) => sum + i.quantity) != 1 ? 's' : ''}',
                        style: const TextStyle(color: Color(0xFF8B7355), fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF8B7355),
                  ),
                ],
              ),
            ),
          ),
          // Expanded order items
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 16, color: Color(0xFFE8E0D8)),
                  Text(
                    order.fullDateString,
                    style: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.7), fontSize: 10),
                  ),
                  const SizedBox(height: 8),
                  ...order.items.map((item) => _buildOrderItem(item)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0EB),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getCategoryIcon(item.product.categoryId),
              size: 18,
              color: const Color(0xFF4A7C59).withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 10),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (item.quantity > 1) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7C59),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${item.quantity}x',
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      item.product.name,
                      style: const TextStyle(color: Color(0xFF2C1810), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getSizeLabel(item),
                      style: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.7), fontSize: 10),
                    ),
                  ],
                ),
                if (item.addOns.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.addOns.map((a) => a.name).join(', '),
                    style: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.6), fontSize: 9),
                  ),
                ],
              ],
            ),
          ),
          // Price
          Text(
            '₱${(item.totalPrice * item.quantity).toInt()}',
            style: const TextStyle(color: Color(0xFF4A7C59), fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Show the orders dialog
Future<void> showOrdersDialog(BuildContext context, OrderHistory orderHistory) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => OrdersDialog(orderHistory: orderHistory),
  );
}
