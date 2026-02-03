import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/order.dart';
import '../models/cart.dart';

// 58mm thermal printer receipt width (approximately 218px at 96dpi)
// Characters per line: ~32 for standard thermal font
const double receiptWidth = 218.0;

class ReceiptDialog extends StatelessWidget {
  final Order order;

  const ReceiptDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: receiptWidth,
        constraints: BoxConstraints(maxHeight: screenHeight * 0.9),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF5), // Receipt paper color
          borderRadius: BorderRadius.circular(4),
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ===== HEADER =====
                    const Text(
                      'Mr. Buenaz',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1810),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Address
                    const Text(
                      'Brgy. Buenavista\nMagdalena, Laguna',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 8,
                        color: Color(0xFF5A4A3A),
                        height: 1.3,
                      ),
                    ),
                    const Text(
                      'beside Gupit Tope Barber',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 7,
                        color: Color(0xFF8B7355),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 3),
                    
                    // Phone
                    const Text(
                      'Tel: 0917-123-4567',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 8,
                        color: Color(0xFF5A4A3A),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    _buildDashedLine(),
                    const SizedBox(height: 6),
                    
                    // Order info row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#${order.id.substring(order.id.length - 6)}',
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 8,
                            color: Color(0xFF5A4A3A),
                          ),
                        ),
                        Text(
                          order.formattedTime,
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 8,
                            color: Color(0xFF5A4A3A),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      order.fullDateString,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 7,
                        color: Color(0xFF8B7355),
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Customer Name
                    const Text(
                      'CUSTOMER:',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 7,
                        color: Color(0xFF5A4A3A),
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      order.customerName.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C1810),
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    _buildDashedLine(),
                    const SizedBox(height: 8),
                    
                    // ===== ORDER ITEMS =====
                    ...order.items.map((item) => _buildReceiptItem(item)),
                    
                    const SizedBox(height: 6),
                    _buildDashedLine(),
                    const SizedBox(height: 8),
                    
                    // ===== TOTAL =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C1810),
                          ),
                        ),
                        Text(
                          'P${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C1810),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 10),
                    _buildDashedLine(),
                    const SizedBox(height: 10),
                    
                    // ===== FOOTER =====
                    const Text(
                      '~ drop by and have a taste! ~',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 8,
                        color: Color(0xFF4A7C59),
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A7C59).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFF4A7C59).withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'OPEN 2PM - 10PM',
                        style: TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A7C59),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // QR Code
                    const Text(
                      'Follow us on Facebook!',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 7,
                        color: Color(0xFF8B7355),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFE8E0D8)),
                      ),
                      child: QrImageView(
                        data: 'https://www.facebook.com/mr.buenaz.2025',
                        version: QrVersions.auto,
                        size: 50,
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
                    const SizedBox(height: 2),
                    const Text(
                      '@mr.buenaz.2025',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 7,
                        color: Color(0xFF4A7C59),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    const Text(
                      'Thank you for your order!',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 9,
                        color: Color(0xFF8B7355),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Close button
            Container(
              padding: const EdgeInsets.all(8),
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Close Receipt',
                    style: TextStyle(
                      fontSize: 10,
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product name and price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${item.quantity}x ${item.product.name}',
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C1810),
                  ),
                ),
              ),
              Text(
                'P${(item.basePrice * item.quantity).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 9,
                  color: Color(0xFF5A4A3A),
                ),
              ),
            ],
          ),
          
          // Size
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              item.product.categoryId == '7' 
                  ? (item.size == 'tall' ? 'Small' : 'Large')
                  : (item.size == 'tall' ? '16oz' : '22oz'),
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 7,
                color: Color(0xFF8B7355),
              ),
            ),
          ),
          
          // Add-ons
          if (item.addOns.isNotEmpty)
            ...item.addOns.map((addOn) => Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '+ ${addOn.name}',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 7,
                      color: Color(0xFF4A7C59),
                    ),
                  ),
                  Text(
                    'P${(addOn.price * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 7,
                      color: Color(0xFF8B7355),
                    ),
                  ),
                ],
              ),
            )),
          
          // Subtotal if has add-ons
          if (item.addOns.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Sub: P${(item.totalPrice * item.quantity).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 7,
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
        36,
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
