import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid: calculate columns based on available width
        int crossAxisCount = 3;
        if (constraints.maxWidth > 600) {
          crossAxisCount = 4;
        }
        if (constraints.maxWidth > 900) {
          crossAxisCount = 5;
        }
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 6;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.62,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _ProductCard(
              product: product,
              onTap: () => onProductTap(product),
            );
          },
        );
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isHovered = false;
  bool _isTallSelected = true; // true = 16oz, false = 22oz

  IconData _getCategoryIcon() {
    switch (widget.product.categoryId) {
      case '2': return Icons.coffee_rounded; // Iced Coffee
      case '3': return Icons.bubble_chart_rounded; // Milk Tea
      case '4': return Icons.blender_rounded; // Frappe
      case '5': return Icons.local_florist_rounded; // Fruities
      case '6': return Icons.coffee_maker_rounded; // Hot Coffee
      case '7': return Icons.breakfast_dining_rounded; // Waffles
      default: return Icons.local_cafe_rounded;
    }
  }

  double get _currentPrice => _isTallSelected 
      ? widget.product.priceTall 
      : widget.product.priceGrande;

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = outOfStockProductIds.contains(widget.product.id);
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = !isOutOfStock && true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale((_isHovered && !isOutOfStock) ? 1.02 : 1.0),
        child: Opacity(
          opacity: isOutOfStock ? 0.6 : 1.0,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isOutOfStock ? null : widget.onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: isOutOfStock ? const Color(0xFFF0F0F0) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isOutOfStock
                        ? const Color(0xFFCCCCCC)
                        : (_isHovered 
                            ? const Color(0xFF4A7C59)
                            : const Color(0xFFE8E0D8)),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: _isHovered && !isOutOfStock
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4A7C59).withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image placeholder with badges
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F0EB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                _getCategoryIcon(),
                                size: 36,
                                color: const Color(0xFF4A7C59).withOpacity(0.4),
                              ),
                            ),
                          ),
                          // Out of Stock overlay
                          if (isOutOfStock)
                            Positioned.fill(
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    'OUT OF\nSTOCK',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          // Popular badge
                          if (widget.product.isPopular && !isOutOfStock)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4A7C59),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      'Popular',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // New badge
                          if (widget.product.isNew && !isOutOfStock)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8A850),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'NEW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          // Coming Soon overlay
                          if (widget.product.isComingSoon && !isOutOfStock)
                            Positioned.fill(
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    'COMING\nSOON',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Product details
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name
                            Text(
                              widget.product.name,
                              style: TextStyle(
                                color: isOutOfStock ? const Color(0xFF999999) : const Color(0xFF2C1810),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                decoration: isOutOfStock ? TextDecoration.lineThrough : null,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // Product description (scrollable)
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.product.description,
                                  style: TextStyle(
                                    color: const Color(0xFF8B7355).withOpacity(0.8),
                                    fontSize: 10,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Price and size selector
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Price display
                                    Text(
                                      '₱${_currentPrice.toInt()}',
                                      style: TextStyle(
                                        color: isOutOfStock ? const Color(0xFF999999) : const Color(0xFF4A7C59),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Size selector buttons
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F0EB),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          // Small/16oz button
                                          GestureDetector(
                                            onTap: isOutOfStock ? null : () => setState(() => _isTallSelected = true),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _isTallSelected 
                                                    ? (isOutOfStock ? const Color(0xFF999999) : const Color(0xFF4A7C59))
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                widget.product.categoryId == '7' ? 'Small' : '16oz',
                                                style: TextStyle(
                                                  color: _isTallSelected 
                                                      ? Colors.white
                                                      : const Color(0xFF8B7355),
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Large/22oz button
                                          GestureDetector(
                                            onTap: isOutOfStock ? null : () => setState(() => _isTallSelected = false),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: !_isTallSelected 
                                                    ? (isOutOfStock ? const Color(0xFF999999) : const Color(0xFF4A7C59))
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                widget.product.categoryId == '7' ? 'Large' : '22oz',
                                                style: TextStyle(
                                                  color: !_isTallSelected 
                                                      ? Colors.white
                                                      : const Color(0xFF8B7355),
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // Add button
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isOutOfStock ? const Color(0xFF999999) : const Color(0xFF4A7C59),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
