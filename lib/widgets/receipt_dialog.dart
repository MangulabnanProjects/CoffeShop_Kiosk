import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/order.dart';
import '../models/cart.dart';


class ReceiptDialog extends StatelessWidget {
  final Order order;

  const ReceiptDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * 0.35,
        constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF5), // Receipt paper color
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Receipt content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ===== HEADER =====
                    // Store name
                    const Text(
                      'Mr. Buenaz',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1810),
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Address
                    const Text(
                      'Located at Brgy. Buenavista\nMagdalena, Laguna',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 11,
                        color: Color(0xFF5A4A3A),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'beside Gupit Tope Barber Shop',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 10,
                        color: Color(0xFF8B7355),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 6),
                    
                    // Phone number
                    const Text(
                      'Tel: 0917-123-4567',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 11,
                        color: Color(0xFF5A4A3A),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Dashed line
                    _buildDashedLine(),
                    
                    const SizedBox(height: 8),
                    
                    // Order info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #${order.id.substring(order.id.length - 6)}',
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 10,
                            color: Color(0xFF5A4A3A),
                          ),
                        ),
                        Text(
                          order.formattedTime,
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 10,
                            color: Color(0xFF5A4A3A),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      order.fullDateString,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 10,
                        color: Color(0xFF8B7355),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Customer Name for Callout
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFD0C5B8), style: BorderStyle.none),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'CUSTOMER:',
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 10,
                              color: Color(0xFF5A4A3A),
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            order.customerName.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C1810),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 8),

                    
                    // Dashed line
                    _buildDashedLine(),
                    
                    const SizedBox(height: 12),
                    
                    // ===== ORDER ITEMS =====
                    ...order.items.map((item) => _buildReceiptItem(item)),
                    
                    const SizedBox(height: 8),
                    
                    // Dashed line
                    _buildDashedLine(),
                    
                    const SizedBox(height: 12),
                    
                    // ===== TOTAL =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C1810),
                          ),
                        ),
                        Text(
                          '₱${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C1810),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Dashed line
                    _buildDashedLine(),
                    
                    const SizedBox(height: 16),
                    
                    // ===== FOOTER =====
                    const Text(
                      '~ drop by and have a taste! ~',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                        color: Color(0xFF4A7C59),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A7C59).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF4A7C59).withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'DAILY OPEN 2:00PM - 10:00PM',
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A7C59),
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // QR Code to Facebook
                    const Text(
                      'Follow us on Facebook!',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 10,
                        color: Color(0xFF8B7355),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE8E0D8),
                        ),
                      ),
                      child: QrImageView(
                        data: 'https://www.facebook.com/mr.buenaz.2025',
                        version: QrVersions.auto,
                        size: 80,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF2C1810),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF2C1810),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '@mr.buenaz.2025',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 9,
                        color: Color(0xFF4A7C59),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Thank you message
                    const Text(
                      'Thank you for your order!',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 12,
                        color: Color(0xFF8B7355),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            
            // Close button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE8E0D8)),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
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
                    'Close Receipt',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name and quantity
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${item.quantity}x ${item.product.name}',
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C1810),
                  ),
                ),
              ),
              Text(
                '₱${(item.basePrice * item.quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 12,
                  color: Color(0xFF5A4A3A),
                ),
              ),
            ],
          ),
          
          // Size
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              item.product.categoryId == '7' 
                  ? (item.size == 'tall' ? 'Small' : 'Large')
                  : (item.size == 'tall' ? '16oz' : '22oz'),
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 10,
                color: Color(0xFF8B7355),
              ),
            ),
          ),
          
          // Add-ons
          if (item.addOns.isNotEmpty)
            ...item.addOns.map((addOn) => Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '+ ${addOn.name}',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 10,
                      color: Color(0xFF4A7C59),
                    ),
                  ),
                  Text(
                    '₱${(addOn.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 10,
                      color: Color(0xFF8B7355),
                    ),
                  ),
                ],
              ),
            )),
          
          // Item subtotal if has add-ons
          if (item.addOns.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Subtotal: ₱${(item.totalPrice * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A4A3A),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDashedLine() {
    return Row(
      children: List.generate(
        50,
        (index) => Expanded(
          child: Container(
            height: 1,
            color: index.isEven ? const Color(0xFFD0C5B8) : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

// Show receipt dialog
Future<void> showReceiptDialog(BuildContext context, Order order) {
  return showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => ReceiptDialog(order: order),
  );
}
