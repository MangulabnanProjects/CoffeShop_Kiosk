class Ingredient {
  final String id;
  final String name;
  final String unit;
  final String smallUnit; // Converted unit for display (ml, g, etc.)
  final double conversionFactor; // How many small units in one main unit
  final double maxStock; // Full capacity
  final double currentStock;
  final double usedAmount; // How much has been used/deducted
  final String category;

  Ingredient({
    required this.id,
    required this.name,
    required this.unit,
    required this.smallUnit,
    required this.conversionFactor,
    required this.maxStock,
    required this.currentStock,
    this.usedAmount = 0,
    required this.category,
  });

  bool get isLowStock => currentStock <= (maxStock * 0.2);
  bool get isOutOfStock => currentStock <= 0;
  bool get hasUsage => usedAmount > 0;
  double get stockPercentage => maxStock > 0 ? (currentStock / maxStock).clamp(0.0, 1.0) : 0.0;
  
  // Copy with method for updating ingredient
  Ingredient copyWith({
    String? id,
    String? name,
    String? unit,
    String? smallUnit,
    double? conversionFactor,
    double? maxStock,
    double? currentStock,
    double? usedAmount,
    String? category,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      smallUnit: smallUnit ?? this.smallUnit,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      maxStock: maxStock ?? this.maxStock,
      currentStock: currentStock ?? this.currentStock,
      usedAmount: usedAmount ?? this.usedAmount,
      category: category ?? this.category,
    );
  }
  
  // Get current stock in small units
  double get currentInSmallUnits => currentStock * conversionFactor;
  
  // Get max stock in small units
  double get maxInSmallUnits => maxStock * conversionFactor;
  
  // Get used amount in small units
  double get usedInSmallUnits => usedAmount * conversionFactor;
  
  // Format small unit value
  String get formattedSmallCurrent {
    final value = currentInSmallUnits;
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(value == value.toInt() ? 0 : 1);
  }
  
  String get formattedSmallMax {
    final value = maxInSmallUnits;
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(value == value.toInt() ? 0 : 1);
  }
  
  String get formattedSmallUsed {
    final value = usedInSmallUnits;
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(value == value.toInt() ? 0 : 1);
  }
}

// Sample ingredients data with full capacity and usage tracking
// Comprehensive list for all Coffee, Milk Tea, Frappe, and Fruities products
// All stock reset to full (currentStock = maxStock, usedAmount = 0)
// All measurements use real units (L/ml, kg/g, pcs)
final List<Ingredient> sampleIngredients = [
  // ========== DAIRY ==========
  Ingredient(id: '1', name: 'Fresh Milk', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 20, currentStock: 20, usedAmount: 0, category: 'Dairy'),
  Ingredient(id: '2', name: 'Condensed Milk', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 4.8, currentStock: 4.8, usedAmount: 0, category: 'Dairy'), // 12 cans x 400ml
  Ingredient(id: '3', name: 'Heavy Cream', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 5, currentStock: 5, usedAmount: 0, category: 'Dairy'),
  Ingredient(id: '4', name: 'Cream Cheese', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Dairy'),
  Ingredient(id: '5', name: 'Evaporated Milk', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 4, currentStock: 4, usedAmount: 0, category: 'Dairy'), // 10 cans x 400ml
  
  // ========== COFFEE ==========
  Ingredient(id: '6', name: 'Coffee Beans', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 8, currentStock: 8, usedAmount: 0, category: 'Coffee'),
  Ingredient(id: '7', name: 'Ground Coffee', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 5, currentStock: 5, usedAmount: 0, category: 'Coffee'),
  Ingredient(id: '8', name: 'Espresso Shots', unit: 'pcs', smallUnit: 'pcs', conversionFactor: 1, maxStock: 100, currentStock: 100, usedAmount: 0, category: 'Coffee'),
  Ingredient(id: '9', name: 'Instant Coffee', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Coffee'),
  
  // ========== TEA & POWDERS ==========
  Ingredient(id: '10', name: 'Milk Tea Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 6, currentStock: 6, usedAmount: 0, category: 'Tea'),
  Ingredient(id: '11', name: 'Matcha Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Tea'),
  Ingredient(id: '12', name: 'Thai Tea Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 4, currentStock: 4, usedAmount: 0, category: 'Tea'),
  Ingredient(id: '13', name: 'Taro Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 4, currentStock: 4, usedAmount: 0, category: 'Tea'),
  Ingredient(id: '14', name: 'Okinawa Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 4, currentStock: 4, usedAmount: 0, category: 'Tea'),
  Ingredient(id: '15', name: 'Wintermelon Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 4, currentStock: 4, usedAmount: 0, category: 'Tea'),
  Ingredient(id: '16', name: 'Cocoa Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 4, currentStock: 4, usedAmount: 0, category: 'Tea'),
  Ingredient(id: '17', name: 'Dark Chocolate Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Tea'),
  Ingredient(id: '18', name: 'White Chocolate Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Tea'),
  Ingredient(id: '19', name: 'Red Velvet Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Tea'),
  Ingredient(id: '20', name: 'Cheesecake Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Tea'),
  Ingredient(id: '21', name: 'Brown Sugar', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 5, currentStock: 5, usedAmount: 0, category: 'Tea'),
  
  // ========== SYRUPS ==========
  Ingredient(id: '22', name: 'Caramel Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 4.5, currentStock: 4.5, usedAmount: 0, category: 'Syrups'), // 6 bottles x 750ml
  Ingredient(id: '23', name: 'Vanilla Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 4.5, currentStock: 4.5, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '24', name: 'Hazelnut Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 4.5, currentStock: 4.5, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '25', name: 'Chocolate Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 6, currentStock: 6, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '26', name: 'Strawberry Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 4.5, currentStock: 4.5, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '27', name: 'Blueberry Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3.75, currentStock: 3.75, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '28', name: 'Mango Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3.75, currentStock: 3.75, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '29', name: 'Passion Fruit Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3.75, currentStock: 3.75, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '30', name: 'Lychee Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3.75, currentStock: 3.75, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '31', name: 'Peach Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3.75, currentStock: 3.75, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '32', name: 'Kiwi Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3.75, currentStock: 3.75, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '33', name: 'Green Apple Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3.75, currentStock: 3.75, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '34', name: 'Honey', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Syrups'), // 6 bottles x 500ml
  Ingredient(id: '35', name: 'Maple Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 2, currentStock: 2, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '36', name: 'Salted Caramel Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Syrups'),
  Ingredient(id: '37', name: 'Lemon Syrup', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3.75, currentStock: 3.75, usedAmount: 0, category: 'Syrups'),
  
  // ========== TOPPINGS ==========
  Ingredient(id: '38', name: 'Tapioca Pearls', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 5, currentStock: 5, usedAmount: 0, category: 'Toppings'),
  Ingredient(id: '39', name: 'Crystal Boba', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Toppings'),
  Ingredient(id: '40', name: 'Coffee Jelly', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Toppings'),
  Ingredient(id: '41', name: 'Popping Boba (Mixed)', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Toppings'),
  Ingredient(id: '42', name: 'Crushed Oreo', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 1.5, currentStock: 1.5, usedAmount: 0, category: 'Toppings'), // 15 packs x 100g
  Ingredient(id: '43', name: 'Whipped Cream', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 2.5, currentStock: 2.5, usedAmount: 0, category: 'Toppings'), // 10 cans x 250ml
  Ingredient(id: '44', name: 'Chocolate Chips', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Toppings'),
  Ingredient(id: '45', name: 'Caramel Drizzle', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 2.5, currentStock: 2.5, usedAmount: 0, category: 'Toppings'),
  Ingredient(id: '46', name: 'Chocolate Drizzle', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 2.5, currentStock: 2.5, usedAmount: 0, category: 'Toppings'),
  Ingredient(id: '47', name: 'Aloe Vera', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Toppings'),
  Ingredient(id: '48', name: 'Fresh Mint Leaves', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 0.5, currentStock: 0.5, usedAmount: 0, category: 'Toppings'), // 10 packs x 50g
  Ingredient(id: '49', name: 'Crushed Hazelnuts', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 2, currentStock: 2, usedAmount: 0, category: 'Toppings'),
  Ingredient(id: '50', name: 'Nutella Spread', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 4.5, currentStock: 4.5, usedAmount: 0, category: 'Toppings'), // 6 jars x 750g
  Ingredient(id: '51', name: 'Vanilla Ice Cream', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 5, currentStock: 5, usedAmount: 0, category: 'Toppings'),
  Ingredient(id: '52', name: 'Sea Salt', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 1, currentStock: 1, usedAmount: 0, category: 'Toppings'),
  
  // ========== WAFFLE INGREDIENTS ==========
  Ingredient(id: '53', name: 'Waffle Batter Mix', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 8, currentStock: 8, usedAmount: 0, category: 'Waffle'),
  Ingredient(id: '54', name: 'Eggs', unit: 'pcs', smallUnit: 'pcs', conversionFactor: 1, maxStock: 48, currentStock: 48, usedAmount: 0, category: 'Waffle'),
  Ingredient(id: '55', name: 'Butter', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Waffle'),
  Ingredient(id: '56', name: 'Fresh Strawberries', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Waffle'),
  Ingredient(id: '57', name: 'Fresh Bananas', unit: 'pcs', smallUnit: 'pcs', conversionFactor: 1, maxStock: 30, currentStock: 30, usedAmount: 0, category: 'Waffle'),
  
  // ========== FRUIT PUREES & FRESH FRUITS ==========
  Ingredient(id: '58', name: 'Strawberry Puree', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 4, currentStock: 4, usedAmount: 0, category: 'Others'),
  Ingredient(id: '59', name: 'Mango Puree', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 4, currentStock: 4, usedAmount: 0, category: 'Others'),
  Ingredient(id: '60', name: 'Passion Fruit Puree', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Others'),
  Ingredient(id: '61', name: 'Blueberry Puree', unit: 'L', smallUnit: 'ml', conversionFactor: 1000, maxStock: 3, currentStock: 3, usedAmount: 0, category: 'Others'),
  Ingredient(id: '62', name: 'Fresh Lemons', unit: 'pcs', smallUnit: 'pcs', conversionFactor: 1, maxStock: 30, currentStock: 30, usedAmount: 0, category: 'Others'),
  
  // ========== SUPPLIES (Cups, Lids, Straws) ==========
  Ingredient(id: '63', name: 'Ice Cubes', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 30, currentStock: 30, usedAmount: 0, category: 'Others'), // 15 bags x 2kg
  Ingredient(id: '64', name: 'White Sugar', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 10, currentStock: 10, usedAmount: 0, category: 'Others'),
  Ingredient(id: '65', name: 'Cups (16oz)', unit: 'pcs', smallUnit: 'pcs', conversionFactor: 1, maxStock: 200, currentStock: 200, usedAmount: 0, category: 'Others'),
  Ingredient(id: '66', name: 'Cups (22oz)', unit: 'pcs', smallUnit: 'pcs', conversionFactor: 1, maxStock: 200, currentStock: 200, usedAmount: 0, category: 'Others'),
  Ingredient(id: '67', name: 'Plastic Lids', unit: 'pcs', smallUnit: 'pcs', conversionFactor: 1, maxStock: 400, currentStock: 400, usedAmount: 0, category: 'Others'),
  Ingredient(id: '68', name: 'Straws', unit: 'pcs', smallUnit: 'pcs', conversionFactor: 1, maxStock: 2000, currentStock: 2000, usedAmount: 0, category: 'Others'), // 20 packs x 100
  Ingredient(id: '69', name: 'Napkins', unit: 'pcs', smallUnit: 'pcs', conversionFactor: 1, maxStock: 3000, currentStock: 3000, usedAmount: 0, category: 'Others'), // 30 packs x 100
  Ingredient(id: '70', name: 'Paper Bags', unit: 'pcs', smallUnit: 'pcs', conversionFactor: 1, maxStock: 1000, currentStock: 1000, usedAmount: 0, category: 'Others'), // 20 packs x 50
];

