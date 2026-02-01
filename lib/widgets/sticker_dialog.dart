import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/cart.dart';

class StickerDialog extends StatefulWidget {
  final Order order;

  const StickerDialog({super.key, required this.order});

  @override
  State<StickerDialog> createState() => _StickerDialogState();
}

class _StickerDialogState extends State<StickerDialog> {
  // Flatten cart items to individual cups (e.g. 2x Latte -> 2 separate stickers)
  List<CartItem> get _individualItems {
    final List<CartItem> individualItems = [];
    for (var item in widget.order.items) {
      for (int i = 0; i < item.quantity; i++) {
        // Create a copy with quantity 1 for each sticker
        individualItems.add(CartItem(
          id: '${item.id}_$i',
          product: item.product,
          size: item.size,
          basePrice: item.basePrice,
          addOns: item.addOns,
          addOnsTotal: item.addOnsTotal,
          totalPrice: item.totalPrice, // Price per unit
          quantity: 1,
        ));
      }
    }
    return individualItems;
  }

  @override
  Widget build(BuildContext context) {
    final items = _individualItems;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * 0.7,
        height: screenHeight * 0.8,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F0EB),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sticky_note_2_rounded, color: Color(0xFF4A7C59), size: 28),
                SizedBox(width: 12),
                Text(
                  'Cup Stickers Printing...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C1810),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Printing ${items.length} stickers for ${widget.order.customerName}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8B7355),
              ),
            ),
            const SizedBox(height: 24),

            // Stickers Grid
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: items.map((item) => _buildSticker(item, items.indexOf(item) + 1, items.length)).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Close button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A7C59),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Done Printing',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSticker(CartItem item, int index, int total) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0D5C8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Logo and Count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mr. Buenaz',
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C1810),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C1810),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$index/$total',
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16, thickness: 1),
          
          // Customer Name
          const Text(
            'CUSTOMER',
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: 8,
              color: Color(0xFF8B7355),
            ),
          ),
          Text(
            widget.order.customerName.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Product Name
          Text(
            item.product.name,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
          ),
          
          // Size and Base Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.product.categoryId == '7' 
                    ? (item.size == 'tall' ? 'Small' : 'Large')
                    : (item.size == 'tall' ? '16oz' : '22oz'),
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A7C59),
                ),
              ),
              Text(
                '₱${item.basePrice.toInt()}',
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 12,
                  color: Color(0xFF5A4A3A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Add-ons with prices
          if (item.addOns.isNotEmpty) ...[
            const Text(
              'ADD-ONS:',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 8,
                color: Color(0xFF8B7355),
              ),
            ),
            ...item.addOns.map((addOn) => Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '+ ${addOn.name}',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 10,
                      color: Color(0xFF2C1810),
                    ),
                  ),
                  Text(
                    '₱${addOn.price.toInt()}',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 10,
                      color: Color(0xFF5A4A3A),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 8),
          ],

          // Dashed line
          Row(
            children: List.generate(
              30,
              (index) => Expanded(
                child: Container(
                  height: 1,
                  color: index.isEven ? const Color(0xFFD0C5B8) : Colors.transparent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),


          // Date & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.order.formattedDate,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 10,
                  color: Color(0xFF8B7355),
                ),
              ),
              Text(
                '₱${item.totalPrice.toInt()}',
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C1810),
                ),
              ),
            ],
          ),
           Text(
            widget.order.formattedTime,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 10,
              color: Color(0xFF8B7355),
            ),
          ),
        ],
      ),
    );
  }
}

// Show sticker dialog
Future<void> showStickerDialog(BuildContext context, Order order) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => StickerDialog(order: order),
  );
}
