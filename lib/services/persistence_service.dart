import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ingredient.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../widgets/product_detail_dialog.dart';

class PersistenceService {
  static const String _ingredientsKey = 'ingredients_data';
  static const String _cartKey = 'cart_data';
  static const String _ordersKey = 'orders_data';
  static const String _outOfStockProductsKey = 'out_of_stock_products';

  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============ INGREDIENTS ============
  
  // Save ingredients to local storage
  static Future<void> saveIngredients() async {
    if (_prefs == null) await init();
    
    final ingredientsList = sampleIngredients.map((i) => {
      'id': i.id,
      'name': i.name,
      'unit': i.unit,
      'smallUnit': i.smallUnit,
      'conversionFactor': i.conversionFactor,
      'maxStock': i.maxStock,
      'currentStock': i.currentStock,
      'usedAmount': i.usedAmount,
      'category': i.category,
    }).toList();
    
    await _prefs!.setString(_ingredientsKey, jsonEncode(ingredientsList));
  }

  // Load ingredients from local storage
  static Future<void> loadIngredients() async {
    if (_prefs == null) await init();
    
    final data = _prefs!.getString(_ingredientsKey);
    if (data == null) return; // Use default ingredients
    
    try {
      final List<dynamic> ingredientsList = jsonDecode(data);
      
      // Update existing ingredients with saved data
      for (final saved in ingredientsList) {
        final index = sampleIngredients.indexWhere((i) => i.id == saved['id']);
        if (index != -1) {
          sampleIngredients[index] = Ingredient(
            id: saved['id'],
            name: saved['name'],
            unit: saved['unit'],
            smallUnit: saved['smallUnit'],
            conversionFactor: (saved['conversionFactor'] as num).toDouble(),
            maxStock: (saved['maxStock'] as num).toDouble(),
            currentStock: (saved['currentStock'] as num).toDouble(),
            usedAmount: (saved['usedAmount'] as num).toDouble(),
            category: saved['category'],
          );
        } else {
          // Add new ingredients that don't exist in defaults
          sampleIngredients.add(Ingredient(
            id: saved['id'],
            name: saved['name'],
            unit: saved['unit'],
            smallUnit: saved['smallUnit'],
            conversionFactor: (saved['conversionFactor'] as num).toDouble(),
            maxStock: (saved['maxStock'] as num).toDouble(),
            currentStock: (saved['currentStock'] as num).toDouble(),
            usedAmount: (saved['usedAmount'] as num).toDouble(),
            category: saved['category'],
          ));
        }
      }
    } catch (e) {
      print('Error loading ingredients: $e');
    }
  }

  // ============ CART ============
  
  // Save cart to local storage
  static Future<void> saveCart(Cart cart) async {
    if (_prefs == null) await init();
    
    final cartItems = cart.items.map((item) => {
      'id': item.id,
      'productId': item.product.id,
      'size': item.size,
      'basePrice': item.basePrice,
      'addOns': item.addOns.map((a) => {
        'id': a.id,
        'name': a.name,
        'price': a.price,
      }).toList(),
      'addOnsTotal': item.addOnsTotal,
      'totalPrice': item.totalPrice,
      'quantity': item.quantity,
    }).toList();
    
    await _prefs!.setString(_cartKey, jsonEncode(cartItems));
  }

  // Load cart from local storage
  static Future<Cart> loadCart() async {
    if (_prefs == null) await init();
    
    final cart = Cart();
    final data = _prefs!.getString(_cartKey);
    if (data == null) return cart;
    
    try {
      final List<dynamic> cartItems = jsonDecode(data);
      
      for (final saved in cartItems) {
        // Find the product
        final product = sampleProducts.firstWhere(
          (p) => p.id == saved['productId'],
          orElse: () => sampleProducts.first,
        );
        
        // Reconstruct add-ons
        final addOns = (saved['addOns'] as List).map((a) => AddOn(
          id: a['id'],
          name: a['name'],
          price: (a['price'] as num).toDouble(),
        )).toList();
        
        final cartItem = CartItem(
          id: saved['id'],
          product: product,
          size: saved['size'],
          basePrice: (saved['basePrice'] as num).toDouble(),
          addOns: addOns,
          addOnsTotal: (saved['addOnsTotal'] as num).toDouble(),
          totalPrice: (saved['totalPrice'] as num).toDouble(),
          quantity: saved['quantity'],
        );
        
        cart.items.add(cartItem);
      }
    } catch (e) {
      print('Error loading cart: $e');
    }
    
    return cart;
  }

  // Clear cart from storage
  static Future<void> clearCart() async {
    if (_prefs == null) await init();
    await _prefs!.remove(_cartKey);
  }

  // ============ ORDERS ============
  
  // Save orders to local storage
  static Future<void> saveOrders(OrderHistory orderHistory) async {
    if (_prefs == null) await init();
    
    final ordersList = orderHistory.orders.map((order) => {
      'id': order.id,
      'customerName': order.customerName,
      'totalAmount': order.totalAmount,
      'dateTime': order.dateTime.toIso8601String(),
      'items': order.items.map((item) => {
        'id': item.id,
        'productId': item.product.id,
        'size': item.size,
        'basePrice': item.basePrice,
        'addOns': item.addOns.map((a) => {
          'id': a.id,
          'name': a.name,
          'price': a.price,
        }).toList(),
        'addOnsTotal': item.addOnsTotal,
        'totalPrice': item.totalPrice,
        'quantity': item.quantity,
      }).toList(),
    }).toList();
    
    await _prefs!.setString(_ordersKey, jsonEncode(ordersList));
  }

  // Load orders from local storage
  static Future<OrderHistory> loadOrders() async {
    if (_prefs == null) await init();
    
    final orderHistory = OrderHistory();
    final data = _prefs!.getString(_ordersKey);
    if (data == null) return orderHistory;
    
    try {
      final List<dynamic> ordersList = jsonDecode(data);
      
      for (final saved in ordersList) {
        // Reconstruct cart items
        final items = <CartItem>[];
        for (final itemData in (saved['items'] as List)) {
          final product = sampleProducts.firstWhere(
            (p) => p.id == itemData['productId'],
            orElse: () => sampleProducts.first,
          );
          
          final addOns = (itemData['addOns'] as List).map((a) => AddOn(
            id: a['id'],
            name: a['name'],
            price: (a['price'] as num).toDouble(),
          )).toList();
          
          items.add(CartItem(
            id: itemData['id'],
            product: product,
            size: itemData['size'],
            basePrice: (itemData['basePrice'] as num).toDouble(),
            addOns: addOns,
            addOnsTotal: (itemData['addOnsTotal'] as num).toDouble(),
            totalPrice: (itemData['totalPrice'] as num).toDouble(),
            quantity: itemData['quantity'],
          ));
        }
        
        orderHistory.orders.add(Order(
          id: saved['id'],
          customerName: saved['customerName'] ?? 'Guest', // Default for old data
          items: items,
          totalAmount: (saved['totalAmount'] as num).toDouble(),
          dateTime: DateTime.parse(saved['dateTime']),
        ));
      }
    } catch (e) {
      print('Error loading orders: $e');
    }
    
    return orderHistory;
  }

  // ============ OUT OF STOCK PRODUCTS ============
  
  // Save out of stock product IDs
  static Future<void> saveOutOfStockProducts(Set<String> productIds) async {
    if (_prefs == null) await init();
    await _prefs!.setStringList(_outOfStockProductsKey, productIds.toList());
  }

  // Load out of stock product IDs
  static Future<Set<String>> loadOutOfStockProducts() async {
    if (_prefs == null) await init();
    final list = _prefs!.getStringList(_outOfStockProductsKey);
    return list?.toSet() ?? {};
  }

  // ============ RESET ============
  
  // Clear all persisted data (for debugging/reset)
  static Future<void> clearAll() async {
    if (_prefs == null) await init();
    await _prefs!.clear();
  }
}
