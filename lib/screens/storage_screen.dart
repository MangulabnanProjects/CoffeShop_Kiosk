import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../models/ingredient.dart';
import '../models/product.dart';
import '../widgets/storage_side_panel.dart';

class StorageScreen extends StatefulWidget {
  final VoidCallback onBackToMenu;

  const StorageScreen({super.key, required this.onBackToMenu});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  String _selectedNavItem = 'storage';
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Dairy', 'Coffee', 'Tea', 'Syrups', 'Toppings', 'Waffle', 'Others'];

  // Change Menu State
  String _selectedMenuCategory = 'All';
  final List<String> _menuCategories = ['All', 'Iced Coffee', 'Hot Coffee', 'Milk Tea', 'Frappe', 'Fruities', 'Waffles'];
  String _menuSearchQuery = '';
  
  // Storage Search
  String _storageSearchQuery = '';


  List<Ingredient> get _filteredIngredients {
    var items = sampleIngredients.toList();
    
    if (_selectedCategory != 'All') {
      items = items.where((i) => i.category == _selectedCategory).toList();
    }
    
    if (_storageSearchQuery.isNotEmpty) {
      items = items.where((i) => i.name.toLowerCase().contains(_storageSearchQuery.toLowerCase())).toList();
    }
    
    return items;
  }
  
  List<Product> get _filteredProducts {
    var items = sampleProducts.toList();
    
    if (_selectedMenuCategory != 'All') {
      String catId = _getCategoryId(_selectedMenuCategory);
      items = items.where((p) => p.categoryId == catId).toList();
    }
    
    if (_menuSearchQuery.isNotEmpty) {
      items = items.where((p) => p.name.toLowerCase().contains(_menuSearchQuery.toLowerCase())).toList();
    }
    
    return items;
  }

  int get _lowStockCount => sampleIngredients.where((i) => i.isLowStock).length;

  void _onNavItemSelected(String item) {
    setState(() {
      _selectedNavItem = item;
    });
    
    if (item != 'storage' && item != 'change_menu') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.construction_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('${_getItemLabel(item)} coming soon!'),
            ],
          ),
          backgroundColor: const Color(0xFF8B7355),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 1),
        ),
      );
      setState(() {
        _selectedNavItem = 'storage';
      });
    }
  }

  String _getItemLabel(String item) {
    switch (item) {
      case 'storage': return 'Storage';
      case 'inventory': return 'Inventory';
      case 'change_menu': return 'Change Menu';
      case 'calculator': return 'Calculator';
      default: return item;
    }
  }

  void _showSummaryDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => _SummaryDialog(ingredients: sampleIngredients),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => _AddItemDialog(
        initialCategory: _selectedCategory == 'All' ? 'Others' : _selectedCategory,
        onAdd: (ingredient) {
          setState(() {
            sampleIngredients.add(ingredient);
          });
        },
      ),
    );
  }

  void _showRestockDialog(Ingredient ingredient) {
    final index = sampleIngredients.indexWhere((i) => i.id == ingredient.id);
    if (index == -1) return;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => _RestockDialog(
        ingredient: ingredient,
        onRestock: (amount) {
          setState(() {
            final currentItem = sampleIngredients[index];
            // If adding amount, increase current stock.
            // Also reset usedAmount as requested "without deductions"
            double newCurrent = currentItem.currentStock + amount;
            if (newCurrent > currentItem.maxStock) newCurrent = currentItem.maxStock;
            
            sampleIngredients[index] = currentItem.copyWith(
              currentStock: newCurrent,
              usedAmount: 0,
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: Row(
        children: [
          // Storage side panel
          StorageSidePanel(
            selectedItem: _selectedNavItem,
            onItemSelected: _onNavItemSelected,
            onMenuTap: widget.onBackToMenu,
          ),
          
          // Main content
          Expanded(
            child: _selectedNavItem == 'change_menu' 
                ? _buildChangeMenuContent()
                : Column(
              children: [
                // Header
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Title
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STORAGE & INVENTORY',
                            style: TextStyle(
                              color: Color(0xFF2C1810),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            'Manage your ingredients and supplies',
                            style: TextStyle(
                              color: Color(0xFF8B7355),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      // Search bar
                      SizedBox(
                        width: 220,
                        height: 38,
                        child: TextField(
                          onChanged: (value) => setState(() => _storageSearchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Search ingredients...',
                            hintStyle: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.6), fontSize: 13),
                            prefixIcon: Icon(Icons.search_rounded, color: const Color(0xFF8B7355).withOpacity(0.6), size: 20),
                            filled: true,
                            fillColor: const Color(0xFFF5F0EB),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Low stock warning
                      if (_lowStockCount > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFD35555).withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_rounded, color: Color(0xFFD35555), size: 18),
                              const SizedBox(width: 6),
                              Text(
                                '$_lowStockCount Low Stock',
                                style: const TextStyle(color: Color(0xFFD35555), fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      // Summary button
                      GestureDetector(
                        onTap: _showSummaryDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A7C59),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.summarize_rounded, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Summary',
                                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content area
                Expanded(
                  child: Row(
                    children: [
                      // Category sidebar
                      Container(
                        width: 180,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Categories',
                                style: TextStyle(color: Color(0xFF8B7355), fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                itemCount: _categories.length,
                                itemBuilder: (context, index) {
                                  final category = _categories[index];
                                  final isSelected = category == _selectedCategory;
                                  final count = category == 'All' 
                                      ? sampleIngredients.length 
                                      : sampleIngredients.where((i) => i.category == category).length;
                                  
                                  return GestureDetector(
                                    onTap: () => setState(() => _selectedCategory = category),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFF4A7C59) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _getCategoryIcon(category),
                                            size: 18,
                                            color: isSelected ? Colors.white : const Color(0xFF8B7355),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              category,
                                              style: TextStyle(
                                                color: isSelected ? Colors.white : const Color(0xFF2C1810),
                                                fontSize: 13,
                                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.white.withOpacity(0.2) : const Color(0xFFF5F0EB),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '$count',
                                              style: TextStyle(
                                                color: isSelected ? Colors.white : const Color(0xFF8B7355),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Ingredients grid
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title with Add Item button
                              Row(
                                children: [
                                  Text(
                                    _selectedCategory == 'All' ? 'All Ingredients' : _selectedCategory,
                                    style: const TextStyle(color: Color(0xFF2C1810), fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4A7C59).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '${_filteredIngredients.length} items',
                                      style: const TextStyle(color: Color(0xFF4A7C59), fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const Spacer(),
                                  // Add Item button
                                  GestureDetector(
                                    onTap: _showAddItemDialog,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4A7C59),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.add_rounded, color: Colors.white, size: 16),
                                          SizedBox(width: 6),
                                          Text(
                                            'Add Item',
                                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Ingredients grid
                              Expanded(
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context).copyWith(
                                    dragDevices: {
                                      PointerDeviceKind.touch,
                                      PointerDeviceKind.mouse,
                                      PointerDeviceKind.stylus,
                                      PointerDeviceKind.trackpad,
                                    },
                                  ),
                                  child: GridView.builder(
                                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      childAspectRatio: 1.2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemCount: _filteredIngredients.length,
                                    itemBuilder: (context, index) {
                                      final ingredient = _filteredIngredients[index];
                                      return _buildIngredientCard(ingredient);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'All': return Icons.inventory_2_rounded;
      case 'Dairy': return Icons.water_drop_rounded;
      case 'Coffee': return Icons.coffee_rounded;
      case 'Tea': return Icons.local_florist_rounded;
      case 'Syrups': return Icons.local_bar_rounded;
      case 'Toppings': return Icons.bubble_chart_rounded;
      case 'Waffle': return Icons.breakfast_dining_rounded;
      case 'Others': return Icons.more_horiz_rounded;
      default: return Icons.inventory_2_rounded;
    }
  }

  Widget _buildIngredientCard(Ingredient ingredient) {
    // Determine colors and status
    final bool isOutOfStock = ingredient.currentStock <= 0;
    
    final stockColor = isOutOfStock
        ? const Color(0xFF9E9E9E) // Grey for out of stock
        : (ingredient.isLowStock 
            ? const Color(0xFFD35555) 
            : const Color(0xFF4A7C59));
    
    return GestureDetector(
      onTap: () => _showRestockDialog(ingredient),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOutOfStock 
                ? const Color(0xFF9E9E9E).withOpacity(0.3)
                : (ingredient.isLowStock 
                    ? const Color(0xFFD35555).withOpacity(0.3) 
                    : const Color(0xFFE8E0D8)),
            width: (ingredient.isLowStock || isOutOfStock) ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: stockColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(ingredient.category),
                    size: 18,
                    color: stockColor.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                if (isOutOfStock)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'OUT OF STOCK',
                      style: TextStyle(color: Color(0xFF616161), fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  )
                else if (ingredient.isLowStock)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'LOW',
                      style: TextStyle(color: Color(0xFFD35555), fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            
            // Name
            Text(
              ingredient.name,
              style: TextStyle(
                color: isOutOfStock ? const Color(0xFF9E9E9E) : const Color(0xFF2C1810), 
                fontSize: 13, 
                fontWeight: FontWeight.w600,
                decoration: isOutOfStock ? TextDecoration.lineThrough : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            
            // Stock amount (original unit) - top display
            Text(
              '${ingredient.currentStock} ${ingredient.unit}',
              style: TextStyle(color: stockColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            
            const Spacer(),
            
            // Stock bar with deduction indicator
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0EB),
                borderRadius: BorderRadius.circular(3),
              ),
              child: isOutOfStock 
                ? Container() // Empty bar if out of stock
                : Row(
                    children: [
                      // Current stock (green/red)
                      Expanded(
                        flex: (ingredient.stockPercentage * 100).toInt(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: stockColor,
                            borderRadius: BorderRadius.horizontal(
                              left: const Radius.circular(3),
                              right: ingredient.hasUsage ? Radius.zero : const Radius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      // Used/deducted portion (gray)
                      if (ingredient.hasUsage)
                        Expanded(
                          flex: ((ingredient.usedAmount / ingredient.maxStock) * 100).toInt(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFBBB5AE),
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.zero,
                                right: const Radius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      // Remaining empty space
                      if ((1 - ingredient.stockPercentage - (ingredient.usedAmount / ingredient.maxStock)) > 0)
                        Expanded(
                          flex: ((1 - ingredient.stockPercentage - (ingredient.usedAmount / ingredient.maxStock)) * 100).toInt().clamp(0, 100),
                          child: const SizedBox(),
                        ),
                    ],
                  ),
            ),
            const SizedBox(height: 4),
            
            // Full capacity in small units with used amount in red on the right
            Row(
              children: [
                Text(
                  '${ingredient.formattedSmallMax} ${ingredient.smallUnit}',
                  style: const TextStyle(color: Color(0xFF8B7355), fontSize: 10),
                ),
                if (!isOutOfStock && ingredient.hasUsage) ...[
                  const Spacer(),
                  Text(
                    '-${ingredient.formattedSmallUsed}',
                    style: const TextStyle(color: Color(0xFFD35555), fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== CHANGE MENU IMPLEMENTATION =====
  
  IconData _getProductCategoryIcon(String category) {
    switch (category) {
      case 'All': return Icons.restaurant_menu_rounded;
      case 'Iced Coffee': return Icons.coffee_rounded;
      case 'Hot Coffee': return Icons.local_cafe_rounded;
      case 'Milk Tea': return Icons.local_drink_rounded;
      case 'Frappe': return Icons.ac_unit_rounded;
      case 'Fruities': return Icons.local_florist_rounded;
      case 'Waffles': return Icons.breakfast_dining_rounded;
      default: return Icons.fastfood_rounded;
    }
  }

  Widget _buildChangeMenuContent() {
    return Row(
      children: [
        // Left Side Panel for Categories
        Container(
          width: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C1810),
                ),
              ),
              const SizedBox(height: 16),
              
              // Category List
              Expanded(
                child: ListView.builder(
                  itemCount: _menuCategories.length,
                  itemBuilder: (context, index) {
                    final category = _menuCategories[index];
                    final isSelected = category == _selectedMenuCategory;
                    final count = category == 'All' 
                        ? sampleProducts.length 
                        : sampleProducts.where((p) => p.categoryId == _getCategoryId(category)).length;
                    
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMenuCategory = category),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF4A7C59) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getProductCategoryIcon(category),
                              size: 18,
                              color: isSelected ? Colors.white : const Color(0xFF8B7355),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF5A4A3A),
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white.withOpacity(0.2) : const Color(0xFFF5F0EB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSelected ? Colors.white : const Color(0xFF8B7355),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Main Content Area
        Expanded(
          child: Column(
            children: [
              // Header with Title and Add Button
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedMenuCategory == 'All' ? 'All Products' : _selectedMenuCategory,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C1810),
                          ),
                        ),
                        Text(
                          '${_filteredProducts.length} items',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8B7355),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    // Search bar
                    SizedBox(
                      width: 220,
                      height: 38,
                      child: TextField(
                        onChanged: (value) => setState(() => _menuSearchQuery = value),
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          hintStyle: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.6), fontSize: 13),
                          prefixIcon: Icon(Icons.search_rounded, color: const Color(0xFF8B7355).withOpacity(0.6), size: 20),
                          filled: true,
                          fillColor: const Color(0xFFF5F0EB),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        ),
                      ),
                    ),
                    const Spacer(),
                    
                    // Add Item Button
                    GestureDetector(
                      onTap: _showAddProductDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A7C59),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4A7C59).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Add Item',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Product Grid
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = (constraints.maxWidth / 250).floor().clamp(2, 4);
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) => _buildProductCard(_filteredProducts[index]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => _AddProductDialog(
        initialCategory: _selectedMenuCategory == 'All' ? 'Iced Coffee' : _selectedMenuCategory,
        onAdd: (product) {
          setState(() {
            sampleProducts.add(product);
          });
        },
      ),
    );
  }

  String _getCategoryId(String categoryName) {
    switch (categoryName) {
      case 'Iced Coffee': return '2';
      case 'Hot Coffee': return '1';
      case 'Milk Tea': return '3';
      case 'Frappe': return '4';
      case 'Fruities': return '5';
      case 'Waffles': return '7';
      default: return '';
    }
  }


  Widget _buildProductCard(Product product) {
    final isOutOfStock = outOfStockProductIds.contains(product.id);
    final isWaffle = product.categoryId == '7';
    final sizeLabel = isWaffle ? 'Small / Large' : '16oz / 22oz';
    
    return Opacity(
      opacity: isOutOfStock ? 0.6 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isOutOfStock ? const Color(0xFFF0F0F0) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image placeholder with delete button
            Stack(
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(_getProductCategoryIcon(_getCategoryName(product.categoryId)), size: 40, color: const Color(0xFFD3C0A9)),
                  ),
                ),
                // Delete button (mark as out of stock)
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isOutOfStock) {
                          outOfStockProductIds.remove(product.id);
                        } else {
                          outOfStockProductIds.add(product.id);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isOutOfStock ? const Color(0xFF4A7C59) : const Color(0xFFD35555).withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isOutOfStock ? Icons.refresh_rounded : Icons.remove_circle_outline_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Status badges
            Row(
              children: [
                if (isOutOfStock) _buildBadge('OUT OF STOCK', const Color(0xFFD35555)),
                if (product.isNew && !isOutOfStock) _buildBadge('NEW', const Color(0xFF4A7C59)),
                if (product.isPopular && !isOutOfStock) _buildBadge('POPULAR', const Color(0xFFD4A574)),
                if (product.isComingSoon && !isOutOfStock) _buildBadge('COMING SOON', const Color(0xFF9E9E9E)),
              ],
            ),
            if (isOutOfStock || product.isNew || product.isPopular || product.isComingSoon)
              const SizedBox(height: 8),
            
            Text(
              product.name, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 14, 
                color: isOutOfStock ? const Color(0xFF999999) : const Color(0xFF2C1810),
                decoration: isOutOfStock ? TextDecoration.lineThrough : null,
              ), 
              maxLines: 1, 
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(product.description, style: TextStyle(fontSize: 11, color: const Color(0xFF5A4A3A).withOpacity(0.7)), maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            
            // Price and Edit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₱${product.priceTall.toStringAsFixed(0)} / ₱${product.priceGrande.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isOutOfStock ? const Color(0xFF999999) : const Color(0xFF4A7C59))),
                    Text(sizeLabel, style: const TextStyle(fontSize: 9, color: Color(0xFF8B7355))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFF5F0EB), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.edit_rounded, size: 16, color: Color(0xFF8B7355)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color)),
    );
  }

  String _getCategoryName(String categoryId) {
    switch (categoryId) {
      case '2': return 'Iced Coffee';
      case '3': return 'Milk Tea';
      case '4': return 'Frappe';
      case '5': return 'Fruities';
      case '7': return 'Waffles';
      default: return 'All';
    }
  }
}

// Summary Dialog
class _SummaryDialog extends StatelessWidget {
  final List<Ingredient> ingredients;

  const _SummaryDialog({required this.ingredients});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final usedIngredients = ingredients.where((i) => i.hasUsage).toList();
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * 0.6,
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
                  const Icon(Icons.summarize_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Inventory Summary',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${usedIngredients.length} items used',
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
            
            // Table header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFF5F0EB),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: Text('Ingredient', style: TextStyle(color: Color(0xFF8B7355), fontSize: 12, fontWeight: FontWeight.w600))),
                  Expanded(flex: 2, child: Text('Original', style: TextStyle(color: Color(0xFF8B7355), fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                  Expanded(flex: 2, child: Text('Used', style: TextStyle(color: Color(0xFF8B7355), fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                  Expanded(flex: 2, child: Text('Remaining', style: TextStyle(color: Color(0xFF8B7355), fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                ],
              ),
            ),
            
            // Items list
            Expanded(
              child: ScrollConfiguration(
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: usedIngredients.length,
                  itemBuilder: (context, index) {
                    final item = usedIngredients[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: const Color(0xFFE8E0D8).withOpacity(0.5)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F0EB),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    _getCategoryIcon(item.category),
                                    size: 14,
                                    color: const Color(0xFF8B7355),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(color: Color(0xFF2C1810), fontSize: 13, fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${item.maxStock} ${item.unit}',
                              style: const TextStyle(color: Color(0xFF5A4A3A), fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '-${item.usedAmount} ${item.unit}',
                              style: const TextStyle(color: Color(0xFFD35555), fontSize: 13, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${item.currentStock} ${item.unit}',
                              style: TextStyle(
                                color: item.isLowStock ? const Color(0xFFD35555) : const Color(0xFF4A7C59),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F0EB),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: const Color(0xFF8B7355).withOpacity(0.7)),
                  const SizedBox(width: 8),
                  Text(
                    'Showing ${usedIngredients.length} ingredients with usage',
                    style: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.8), fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Dairy': return Icons.water_drop_rounded;
      case 'Coffee': return Icons.coffee_rounded;
      case 'Tea': return Icons.local_florist_rounded;
      case 'Syrups': return Icons.local_bar_rounded;
      case 'Toppings': return Icons.bubble_chart_rounded;
      case 'Waffle': return Icons.breakfast_dining_rounded;
      case 'Others': return Icons.more_horiz_rounded;
      default: return Icons.inventory_2_rounded;
    }
  }
}

// Add Item Dialog
class _AddItemDialog extends StatefulWidget {
  final String initialCategory;
  final Function(Ingredient) onAdd;

  const _AddItemDialog({
    required this.initialCategory,
    required this.onAdd,
  });

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String _selectedCategory = 'Others';
  String _selectedUnit = 'pcs';
  
  final List<String> _categories = ['Dairy', 'Coffee', 'Tea', 'Syrups', 'Toppings', 'Waffle', 'Others'];
  final List<String> _units = ['liters', 'ml', 'kg', 'g', 'pcs', 'cans', 'bottles', 'bags', 'packs', 'shots'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Dairy': return Icons.water_drop_rounded;
      case 'Coffee': return Icons.coffee_rounded;
      case 'Tea': return Icons.local_florist_rounded;
      case 'Syrups': return Icons.local_bar_rounded;
      case 'Toppings': return Icons.bubble_chart_rounded;
      case 'Waffle': return Icons.breakfast_dining_rounded;
      case 'Others': return Icons.more_horiz_rounded;
      default: return Icons.inventory_2_rounded;
    }
  }

  String _getSmallUnit(String unit) {
    switch (unit) {
      case 'liters': return 'ml';
      case 'kg': return 'g';
      default: return unit;
    }
  }

  double _getConversionFactor(String unit) {
    switch (unit) {
      case 'liters': return 1000;
      case 'kg': return 1000;
      default: return 1;
    }
  }

  void _addItem() {
    final name = _nameController.text.trim();
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    
    if (name.isEmpty || quantity <= 0) {
      return;
    }

    final newIngredient = Ingredient(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      unit: _selectedUnit,
      smallUnit: _getSmallUnit(_selectedUnit),
      conversionFactor: _getConversionFactor(_selectedUnit),
      maxStock: quantity,
      currentStock: quantity,
      usedAmount: 0,
      category: _selectedCategory,
    );

    widget.onAdd(newIngredient);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * 0.4,
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
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF4A7C59),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(_getCategoryIcon(_selectedCategory), color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Add New Item',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
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
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category selector
                  const Text(
                    'Category',
                    style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF4A7C59) : const Color(0xFFF5F0EB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF4A7C59) : const Color(0xFFE8E0D8),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getCategoryIcon(category),
                                size: 14,
                                color: isSelected ? Colors.white : const Color(0xFF8B7355),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF5A4A3A),
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Name field
                  const Text(
                    'Item Name',
                    style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter item name',
                      hintStyle: const TextStyle(color: Color(0xFFBBB5AE), fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFFF5F0EB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    style: const TextStyle(color: Color(0xFF2C1810), fontSize: 14),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Quantity and Unit row
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _quantityController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                hintText: '0',
                                hintStyle: const TextStyle(color: Color(0xFFBBB5AE), fontSize: 14),
                                filled: true,
                                fillColor: const Color(0xFFF5F0EB),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              style: const TextStyle(color: Color(0xFF2C1810), fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Unit',
                              style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F0EB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedUnit,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF8B7355)),
                                  style: const TextStyle(color: Color(0xFF2C1810), fontSize: 14),
                                  dropdownColor: Colors.white,
                                  items: _units.map((unit) {
                                    return DropdownMenuItem(
                                      value: unit,
                                      child: Text(unit),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedUnit = value);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F0EB),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE8E0D8)),
                            ),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Color(0xFF8B7355), fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _addItem,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A7C59),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'Add',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
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
}

// Restock Dialog
class _RestockDialog extends StatefulWidget {
  final Ingredient ingredient;
  final Function(double) onRestock;

  const _RestockDialog({
    required this.ingredient,
    required this.onRestock,
  });

  @override
  State<_RestockDialog> createState() => _RestockDialogState();
}

class _RestockDialogState extends State<_RestockDialog> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleRestock() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount > 0) {
      widget.onRestock(amount);
      Navigator.pop(context);
    }
  }
  
  void _maxRestock() {
    // Fill up to max capacity
    final needed = widget.ingredient.maxStock - widget.ingredient.currentStock;
    widget.onRestock(needed > 0 ? needed : 0); 
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 350,
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
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF4A7C59),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                   const Icon(Icons.add_shopping_cart_rounded, color: Colors.white, size: 20),
                   const SizedBox(width: 8),
                   const Text(
                    'Restock Item',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
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
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ingredient.name,
                    style: const TextStyle(color: Color(0xFF2C1810), fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Current Stock: ${widget.ingredient.currentStock} ${widget.ingredient.unit}',
                    style: TextStyle(color: const Color(0xFF8B7355), fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  
                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _maxRestock,
                           icon: const Icon(Icons.restart_alt_rounded, size: 16),
                          label: const Text('Reset to Max'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4A7C59),
                            side: const BorderSide(color: Color(0xFF4A7C59)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                   const SizedBox(height: 16),
                   const Row(children: [
                        Expanded(child: Divider()),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("OR", style: TextStyle(fontSize: 10, color: Colors.grey))),
                        Expanded(child: Divider()),
                   ]),
                   const SizedBox(height: 16),

                  // Manual Add
                  const Text(
                    'Add Quantity',
                    style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: '0',
                            suffixText: widget.ingredient.unit,
                            filled: true,
                            fillColor: const Color(0xFFF5F0EB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _handleRestock,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A7C59),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Add'),
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
}

// Add Product Dialog
class _AddProductDialog extends StatefulWidget {
  final String initialCategory;
  final Function(Product) onAdd;

  const _AddProductDialog({
    required this.initialCategory,
    required this.onAdd,
  });

  @override
  State<_AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<_AddProductDialog> {
  late String _selectedCategory;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _price16Controller = TextEditingController();
  final TextEditingController _price22Controller = TextEditingController();

  final List<String> _productCategories = ['Iced Coffee', 'Hot Coffee', 'Milk Tea', 'Frappe', 'Fruities', 'Waffles'];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _price16Controller.dispose();
    _price22Controller.dispose();
    super.dispose();
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Iced Coffee': return Icons.coffee_rounded;
      case 'Hot Coffee': return Icons.local_cafe_rounded;
      case 'Milk Tea': return Icons.local_drink_rounded;
      case 'Frappe': return Icons.ac_unit_rounded;
      case 'Fruities': return Icons.local_florist_rounded;
      case 'Waffles': return Icons.breakfast_dining_rounded;
      default: return Icons.fastfood_rounded;
    }
  }

  String _getCategoryIdFromName(String name) {
    switch (name) {
      case 'Iced Coffee': return '2';
      case 'Hot Coffee': return '1';
      case 'Milk Tea': return '3';
      case 'Frappe': return '4';
      case 'Fruities': return '5';
      case 'Waffles': return '7';
      default: return '2';
    }
  }

  void _handleAdd() {
    final name = _nameController.text.trim();
    final price16 = double.tryParse(_price16Controller.text) ?? 0;
    final price22 = double.tryParse(_price22Controller.text) ?? 0;
    
    if (name.isEmpty || price16 <= 0 || price22 <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in name and both prices')),
      );
      return;
    }

    final product = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      categoryId: _getCategoryIdFromName(_selectedCategory),
      priceTall: price16,
      priceGrande: price22,
      description: _descController.text.trim(),
    );

    widget.onAdd(product);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 420,
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
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF4A7C59),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(_getCategoryIcon(_selectedCategory), color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  const Text(
                    'Add Menu Item',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Selector
                  const Text('Category', style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0EB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF8B7355)),
                        items: _productCategories.map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Row(
                            children: [
                              Icon(_getCategoryIcon(cat), size: 18, color: const Color(0xFF8B7355)),
                              const SizedBox(width: 10),
                              Text(cat, style: const TextStyle(color: Color(0xFF2C1810))),
                            ],
                          ),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _selectedCategory = value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  const Text('Item Name', style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter product name',
                      hintStyle: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.6)),
                      filled: true,
                      fillColor: const Color(0xFFF5F0EB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  const Text('Description (optional)', style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Enter description',
                      hintStyle: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.6)),
                      filled: true,
                      fillColor: const Color(0xFFF5F0EB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Prices
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Price (16oz)', style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _price16Controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '₱0',
                                prefixText: '₱',
                                hintStyle: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.6)),
                                filled: true,
                                fillColor: const Color(0xFFF5F0EB),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Price (22oz)', style: TextStyle(color: Color(0xFF5A4A3A), fontSize: 12, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _price22Controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '₱0',
                                prefixText: '₱',
                                hintStyle: TextStyle(color: const Color(0xFF8B7355).withOpacity(0.6)),
                                filled: true,
                                fillColor: const Color(0xFFF5F0EB),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F0EB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text('Cancel', style: TextStyle(color: Color(0xFF8B7355), fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _handleAdd,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A7C59),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text('Add Item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
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
}
