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
final List<Ingredient> sampleIngredients = [
  // Milk & Dairy (liters -> milliliters)
  Ingredient(id: '1', name: 'Fresh Milk', unit: 'liters', smallUnit: 'ml', conversionFactor: 1000, maxStock: 20, currentStock: 15, usedAmount: 5, category: 'Dairy'),
  Ingredient(id: '2', name: 'Condensed Milk', unit: 'cans', smallUnit: 'cans', conversionFactor: 1, maxStock: 12, currentStock: 8, usedAmount: 4, category: 'Dairy'),
  Ingredient(id: '3', name: 'Cream', unit: 'liters', smallUnit: 'ml', conversionFactor: 1000, maxStock: 5, currentStock: 3, usedAmount: 2, category: 'Dairy'),
  
  // Coffee (kg -> grams)
  Ingredient(id: '4', name: 'Coffee Beans', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 8, currentStock: 5, usedAmount: 3, category: 'Coffee'),
  Ingredient(id: '5', name: 'Ground Coffee', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 5, currentStock: 3, usedAmount: 2, category: 'Coffee'),
  Ingredient(id: '6', name: 'Espresso Shots', unit: 'shots', smallUnit: 'shots', conversionFactor: 1, maxStock: 100, currentStock: 50, usedAmount: 50, category: 'Coffee'),
  
  // Tea & Powder (kg -> grams)
  Ingredient(id: '7', name: 'Milk Tea Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 6, currentStock: 4, usedAmount: 2, category: 'Tea'),
  Ingredient(id: '8', name: 'Matcha Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 1.5, usedAmount: 1.5, category: 'Tea'),
  Ingredient(id: '9', name: 'Thai Tea Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 4, currentStock: 2, usedAmount: 2, category: 'Tea'),
  Ingredient(id: '10', name: 'Taro Powder', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 4, currentStock: 2.5, usedAmount: 1.5, category: 'Tea'),
  
  // Syrups (bottles)
  Ingredient(id: '11', name: 'Caramel Syrup', unit: 'bottles', smallUnit: 'bottles', conversionFactor: 1, maxStock: 6, currentStock: 4, usedAmount: 2, category: 'Syrups'),
  Ingredient(id: '12', name: 'Vanilla Syrup', unit: 'bottles', smallUnit: 'bottles', conversionFactor: 1, maxStock: 6, currentStock: 3, usedAmount: 3, category: 'Syrups'),
  Ingredient(id: '13', name: 'Hazelnut Syrup', unit: 'bottles', smallUnit: 'bottles', conversionFactor: 1, maxStock: 6, currentStock: 2, usedAmount: 4, category: 'Syrups'),
  Ingredient(id: '14', name: 'Chocolate Syrup', unit: 'bottles', smallUnit: 'bottles', conversionFactor: 1, maxStock: 8, currentStock: 5, usedAmount: 3, category: 'Syrups'),
  
  // Toppings (kg -> grams)
  Ingredient(id: '15', name: 'Tapioca Pearls', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 5, currentStock: 3, usedAmount: 2, category: 'Toppings'),
  Ingredient(id: '16', name: 'Crystal Boba', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 2, usedAmount: 1, category: 'Toppings'),
  Ingredient(id: '17', name: 'Coffee Jelly', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 1.5, usedAmount: 1.5, category: 'Toppings'),
  Ingredient(id: '18', name: 'Popping Boba', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 2, usedAmount: 1, category: 'Toppings'),
  Ingredient(id: '19', name: 'Crushed Oreo', unit: 'packs', smallUnit: 'packs', conversionFactor: 1, maxStock: 15, currentStock: 10, usedAmount: 5, category: 'Toppings'),
  Ingredient(id: '20', name: 'Whipped Cream', unit: 'cans', smallUnit: 'cans', conversionFactor: 1, maxStock: 10, currentStock: 6, usedAmount: 4, category: 'Toppings'),
  
  // Waffle Ingredients
  Ingredient(id: '21', name: 'Waffle Batter Mix', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 8, currentStock: 5, usedAmount: 3, category: 'Waffle'),
  Ingredient(id: '22', name: 'Eggs', unit: 'pieces', smallUnit: 'pcs', conversionFactor: 1, maxStock: 48, currentStock: 30, usedAmount: 18, category: 'Waffle'),
  Ingredient(id: '23', name: 'Butter', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 3, currentStock: 2, usedAmount: 1, category: 'Waffle'),
  
  // Ice & Others
  Ingredient(id: '24', name: 'Ice Cubes', unit: 'bags', smallUnit: 'bags', conversionFactor: 1, maxStock: 15, currentStock: 10, usedAmount: 5, category: 'Others'),
  Ingredient(id: '25', name: 'Sugar', unit: 'kg', smallUnit: 'g', conversionFactor: 1000, maxStock: 10, currentStock: 8, usedAmount: 2, category: 'Others'),
  Ingredient(id: '26', name: 'Cups (16oz)', unit: 'pieces', smallUnit: 'pcs', conversionFactor: 1, maxStock: 200, currentStock: 150, usedAmount: 50, category: 'Others'),
  Ingredient(id: '27', name: 'Cups (22oz)', unit: 'pieces', smallUnit: 'pcs', conversionFactor: 1, maxStock: 200, currentStock: 100, usedAmount: 100, category: 'Others'),
];
