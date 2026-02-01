import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../widgets/side_panel.dart';
import '../widgets/header_bar.dart';
import '../widgets/product_grid.dart';
import '../widgets/product_detail_dialog.dart';
import '../widgets/cart_dialog.dart';
import '../widgets/orders_dialog.dart';
import '../screens/storage_screen.dart';
import '../services/persistence_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategoryId = '0'; // Default to 'Popular Choice'
  String _searchQuery = '';
  bool _showStorageScreen = false;
  Cart _cart = Cart();
  OrderHistory _orderHistory = OrderHistory();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPersistedData();
  }

  Future<void> _loadPersistedData() async {
    final cart = await PersistenceService.loadCart();
    final orderHistory = await PersistenceService.loadOrders();
    
    if (mounted) {
      setState(() {
        _cart = cart;
        _orderHistory = orderHistory;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCart() async {
    await PersistenceService.saveCart(_cart);
  }

  Future<void> _saveOrders() async {
    await PersistenceService.saveOrders(_orderHistory);
  }


  List<Product> get _filteredProducts {
    List<Product> products;
    
    if (_selectedCategoryId == '0') {
      products = popularProducts;
    } else if (_selectedCategoryId == '1') {
      products = sampleProducts;
    } else {
      products = sampleProducts
          .where((p) => p.categoryId == _selectedCategoryId)
          .toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      products = products.where((p) {
        return p.name.toLowerCase().contains(query) ||
               p.description.toLowerCase().contains(query);
      }).toList();
    }
    
    return products;
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isNotEmpty && _selectedCategoryId != '1') {
        _selectedCategoryId = '1';
      }
    });
  }

  void _onProductTap(Product product) async {
    final result = await showProductDetail(context, product);
    
    if (result != null) {
      final cartItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: result['product'] as Product,
        size: result['size'] as String,
        basePrice: result['basePrice'] as double,
        addOns: result['addOns'] as List<AddOn>,
        addOnsTotal: result['addOnsTotal'] as double,
        totalPrice: result['totalPrice'] as double,
      );

      setState(() {
        _cart.addItem(cartItem);
      });
      
      // Save cart to persistence
      _saveCart();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${cartItem.product.name} to cart'),
          backgroundColor: const Color(0xFF4A7C59),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _onCartTap() {
    showCartDialog(
      context,
      _cart,
      () {
        setState(() {
          _cart.clear();
        });
        // Save cart after clearing
        _saveCart();
      },
      (itemId) {
        setState(() {
          _cart.removeItem(itemId);
        });
        // Save cart after removing item
        _saveCart();
      },
      (order) {
        setState(() {
          _orderHistory.addOrder(order);
          _cart.clear();
        });
        // Save orders and clear cart persistence
        _saveOrders();
        _saveCart();
        // Also save ingredients (since they were deducted during checkout)
        PersistenceService.saveIngredients();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Order completed successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF4A7C59),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }


  void _onOrdersTap() {
    showOrdersDialog(context, _orderHistory);
  }

  @override
  Widget build(BuildContext context) {
    // Show storage screen if selected
    if (_showStorageScreen) {
      return StorageScreen(
        onBackToMenu: () => setState(() => _showStorageScreen = false),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: Column(
        children: [
          // Header
          HeaderBar(
            cartItemCount: _cart.itemCount,
            onCartTap: _onCartTap,
            onOrdersTap: _onOrdersTap,
            onSearch: _onSearch,
          ),
          
          // Main content area
          Expanded(
            child: Row(
              children: [
                // Side panel
                SidePanel(
                  categories: sampleCategories,
                  selectedCategoryId: _selectedCategoryId,
                  onCategorySelected: _onCategorySelected,
                  onStorageTap: () => setState(() => _showStorageScreen = true),
                ),
                
                // Product grid
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category title
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Row(
                          children: [
                            Text(
                              _searchQuery.isNotEmpty 
                                  ? 'Search: "$_searchQuery"'
                                  : _getCategoryName(),
                              style: const TextStyle(
                                color: Color(0xFF2C1810),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4A7C59).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${_filteredProducts.length} items',
                                style: const TextStyle(
                                  color: Color(0xFF4A7C59),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Product grid
                      Expanded(
                        child: ProductGrid(
                          products: _filteredProducts,
                          onProductTap: _onProductTap,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryName() {
    final category = sampleCategories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => Category(id: '0', name: 'Popular Choice'),
    );
    return category.name;
  }
}
