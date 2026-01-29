import '../models/product.dart';
import '../widgets/product_detail_dialog.dart';

class CartItem {
  final String id;
  final Product product;
  final String size; // 'tall' or 'grande'
  final double basePrice;
  final List<AddOn> addOns;
  final double addOnsTotal;
  final double totalPrice;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.size,
    required this.basePrice,
    required this.addOns,
    required this.addOnsTotal,
    required this.totalPrice,
    this.quantity = 1,
  });

  // Generate a unique key based on product, size, and add-ons
  String get uniqueKey {
    final addOnIds = addOns.map((a) => a.id).toList()..sort();
    return '${product.id}_${size}_${addOnIds.join(",")}';
  }

  // Check if two cart items are the same (same product, size, and add-ons)
  bool isSameAs(CartItem other) {
    return uniqueKey == other.uniqueKey;
  }
}

class Cart {
  final List<CartItem> items = [];

  void addItem(CartItem newItem) {
    // Check if item with same product, size, and add-ons already exists
    for (var item in items) {
      if (item.isSameAs(newItem)) {
        item.quantity++;
        return;
      }
    }
    // If not found, add as new item
    items.add(newItem);
  }

  void removeItem(String itemId) {
    items.removeWhere((item) => item.id == itemId);
  }

  void clear() {
    items.clear();
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + (item.totalPrice * item.quantity));
  }

  // Group items by product for display (same product stacked together)
  Map<String, List<CartItem>> get groupedByProduct {
    final grouped = <String, List<CartItem>>{};
    for (var item in items) {
      if (!grouped.containsKey(item.product.id)) {
        grouped[item.product.id] = [];
      }
      grouped[item.product.id]!.add(item);
    }
    return grouped;
  }
}
