// Recipe model - defines ingredients needed for each product and add-on
// Amounts are in the smallest unit (ml for liquids, g for solids, pieces for countable items)

class RecipeIngredient {
  final String ingredientName;
  final double amount; // Amount needed in smallest unit

  RecipeIngredient({required this.ingredientName, required this.amount});
}

class ProductAvailability {
  final bool isAvailable;
  final int maxServings; // How many can be made with current stock
  final List<String> missingIngredients; // Completely out
  final List<String> lowIngredients; // Running low (< 6 servings)
  final String? warningMessage;

  ProductAvailability({
    required this.isAvailable,
    required this.maxServings,
    this.missingIngredients = const [],
    this.lowIngredients = const [],
    this.warningMessage,
  });
}

// ========== PRODUCT RECIPES ==========
// Maps product ID -> size -> ingredient name -> amount needed

final Map<String, Map<String, Map<String, double>>> productRecipes = {
  // ===== ICED COFFEE =====
  '1': { // Mr. Mocha
    'tall': {'Espresso Shots': 2, 'Chocolate Syrup': 30, 'Fresh Milk': 150, 'Ice Cubes': 0.1},
    'grande': {'Espresso Shots': 2, 'Chocolate Syrup': 40, 'Fresh Milk': 200, 'Ice Cubes': 0.15},
  },
  '2': { // Mr. Vanilla
    'tall': {'Espresso Shots': 2, 'Vanilla Syrup': 25, 'Fresh Milk': 150, 'Ice Cubes': 0.1},
    'grande': {'Espresso Shots': 2, 'Vanilla Syrup': 35, 'Fresh Milk': 200, 'Ice Cubes': 0.15},
  },
  '3': { // Mr. Matcha
    'tall': {'Espresso Shots': 1, 'Matcha Powder': 10, 'Fresh Milk': 180, 'Ice Cubes': 0.1},
    'grande': {'Espresso Shots': 1, 'Matcha Powder': 15, 'Fresh Milk': 240, 'Ice Cubes': 0.15},
  },
  '4': { // Mr. Caramel
    'tall': {'Espresso Shots': 2, 'Caramel Syrup': 30, 'Fresh Milk': 150, 'Ice Cubes': 0.1},
    'grande': {'Espresso Shots': 2, 'Caramel Syrup': 40, 'Fresh Milk': 200, 'Ice Cubes': 0.15},
  },
  '5': { // Mr. Caramel Macchiato
    'tall': {'Espresso Shots': 2, 'Vanilla Syrup': 20, 'Caramel Drizzle': 15, 'Fresh Milk': 150, 'Ice Cubes': 0.1},
    'grande': {'Espresso Shots': 2, 'Vanilla Syrup': 25, 'Caramel Drizzle': 20, 'Fresh Milk': 200, 'Ice Cubes': 0.15},
  },
  '6': { // Mr. Hazel Macchiato
    'tall': {'Espresso Shots': 2, 'Hazelnut Syrup': 30, 'Fresh Milk': 150, 'Ice Cubes': 0.1},
    'grande': {'Espresso Shots': 2, 'Hazelnut Syrup': 40, 'Fresh Milk': 200, 'Ice Cubes': 0.15},
  },
  '7': { // Mr. White Mochaccino
    'tall': {'Espresso Shots': 2, 'White Chocolate Powder': 20, 'Fresh Milk': 150, 'Ice Cubes': 0.1},
    'grande': {'Espresso Shots': 2, 'White Chocolate Powder': 25, 'Fresh Milk': 200, 'Ice Cubes': 0.15},
  },

  // ===== MILK TEA =====
  // NOTE: Toppings like Tapioca Pearls are handled separately as add-ons
  // Products remain available even if toppings are out of stock
  '8': { // Okinawa
    'tall': {'Milk Tea Powder': 25, 'Okinawa Powder': 15, 'Brown Sugar': 10, 'Fresh Milk': 120, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 35, 'Okinawa Powder': 20, 'Brown Sugar': 15, 'Fresh Milk': 160, 'Ice Cubes': 0.1},
  },
  '9': { // Wintermelon
    'tall': {'Milk Tea Powder': 25, 'Wintermelon Powder': 20, 'Fresh Milk': 120, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 35, 'Wintermelon Powder': 28, 'Fresh Milk': 160, 'Ice Cubes': 0.1},
  },
  '10': { // Chocolate
    'tall': {'Milk Tea Powder': 20, 'Cocoa Powder': 15, 'Fresh Milk': 130, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 28, 'Cocoa Powder': 20, 'Fresh Milk': 170, 'Ice Cubes': 0.1},
  },
  '11': { // Taro
    'tall': {'Taro Powder': 30, 'Fresh Milk': 150, 'Ice Cubes': 0.08},
    'grande': {'Taro Powder': 40, 'Fresh Milk': 200, 'Ice Cubes': 0.1},
  },
  '12': { // Strawberry
    'tall': {'Milk Tea Powder': 20, 'Strawberry Syrup': 25, 'Fresh Milk': 130, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 28, 'Strawberry Syrup': 35, 'Fresh Milk': 170, 'Ice Cubes': 0.1},
  },
  '13': { // Cheesecake
    'tall': {'Milk Tea Powder': 20, 'Cheesecake Powder': 20, 'Cream Cheese': 15, 'Fresh Milk': 120, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 28, 'Cheesecake Powder': 28, 'Cream Cheese': 20, 'Fresh Milk': 160, 'Ice Cubes': 0.1},
  },
  '14': { // Dark Choco
    'tall': {'Milk Tea Powder': 18, 'Dark Chocolate Powder': 22, 'Fresh Milk': 130, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 25, 'Dark Chocolate Powder': 30, 'Fresh Milk': 170, 'Ice Cubes': 0.1},
  },
  '15': { // Choco Kisses
    'tall': {'Milk Tea Powder': 20, 'Cocoa Powder': 18, 'Condensed Milk': 0.04, 'Fresh Milk': 120, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 28, 'Cocoa Powder': 25, 'Condensed Milk': 0.04, 'Fresh Milk': 160, 'Ice Cubes': 0.1},
  },
  '16': { // Red Velvet
    'tall': {'Milk Tea Powder': 18, 'Red Velvet Powder': 20, 'Cream Cheese': 12, 'Fresh Milk': 130, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 25, 'Red Velvet Powder': 28, 'Cream Cheese': 18, 'Fresh Milk': 170, 'Ice Cubes': 0.1},
  },
  '17': { // Matcha (Milk Tea)
    'tall': {'Matcha Powder': 15, 'Fresh Milk': 170, 'White Sugar': 10, 'Ice Cubes': 0.08},
    'grande': {'Matcha Powder': 22, 'Fresh Milk': 220, 'White Sugar': 15, 'Ice Cubes': 0.1},
  },
  '18': { // Salted Caramel
    'tall': {'Milk Tea Powder': 22, 'Salted Caramel Syrup': 30, 'Sea Salt': 1, 'Fresh Milk': 120, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 30, 'Salted Caramel Syrup': 40, 'Sea Salt': 1.5, 'Fresh Milk': 160, 'Ice Cubes': 0.1},
  },
  '19': { // Cookies & Cream
    'tall': {'Milk Tea Powder': 22, 'Crushed Oreo': 20, 'Heavy Cream': 20, 'Fresh Milk': 130, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 30, 'Crushed Oreo': 30, 'Heavy Cream': 30, 'Fresh Milk': 170, 'Ice Cubes': 0.1},
  },
  '20': { // Double Dutch
    'tall': {'Milk Tea Powder': 15, 'Dark Chocolate Powder': 15, 'Cocoa Powder': 12, 'Fresh Milk': 130, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 20, 'Dark Chocolate Powder': 20, 'Cocoa Powder': 18, 'Fresh Milk': 170, 'Ice Cubes': 0.1},
  },
  '21': { // Choco Hazelnut
    'tall': {'Milk Tea Powder': 20, 'Cocoa Powder': 15, 'Hazelnut Syrup': 20, 'Fresh Milk': 130, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 28, 'Cocoa Powder': 20, 'Hazelnut Syrup': 28, 'Fresh Milk': 170, 'Ice Cubes': 0.1},
  },
  '22': { // Chocoberry
    'tall': {'Milk Tea Powder': 20, 'Cocoa Powder': 15, 'Strawberry Syrup': 20, 'Fresh Milk': 130, 'Ice Cubes': 0.08},
    'grande': {'Milk Tea Powder': 28, 'Cocoa Powder': 20, 'Strawberry Syrup': 28, 'Fresh Milk': 170, 'Ice Cubes': 0.1},
  },

  // ===== FRAPPE - COFFEE BASED =====
  // NOTE: Whipped Cream is optional topping, handled separately
  '23': { // Coffee Jelly - coffee jelly is core ingredient for this product
    'tall': {'Espresso Shots': 2, 'Ground Coffee': 5, 'Coffee Jelly': 50, 'Fresh Milk': 100, 'Ice Cubes': 0.12},
    'grande': {'Espresso Shots': 2, 'Ground Coffee': 8, 'Coffee Jelly': 70, 'Fresh Milk': 140, 'Ice Cubes': 0.18},
  },
  '24': { // Java Chip
    'tall': {'Espresso Shots': 2, 'Chocolate Syrup': 25, 'Chocolate Chips': 20, 'Fresh Milk': 100, 'Ice Cubes': 0.12},
    'grande': {'Espresso Shots': 2, 'Chocolate Syrup': 35, 'Chocolate Chips': 30, 'Fresh Milk': 140, 'Ice Cubes': 0.18},
  },
  '25': { // Vanilla Frappe
    'tall': {'Espresso Shots': 2, 'Vanilla Syrup': 30, 'Fresh Milk': 100, 'Ice Cubes': 0.12},
    'grande': {'Espresso Shots': 2, 'Vanilla Syrup': 42, 'Fresh Milk': 140, 'Ice Cubes': 0.18},
  },
  '26': { // Mocha Frappe
    'tall': {'Espresso Shots': 2, 'Dark Chocolate Powder': 20, 'Chocolate Syrup': 20, 'Fresh Milk': 100, 'Ice Cubes': 0.12},
    'grande': {'Espresso Shots': 2, 'Dark Chocolate Powder': 28, 'Chocolate Syrup': 28, 'Fresh Milk': 140, 'Ice Cubes': 0.18},
  },
  '27': { // Caramel Macchiato Frappe
    'tall': {'Espresso Shots': 2, 'Caramel Syrup': 25, 'Caramel Drizzle': 15, 'Fresh Milk': 100, 'Ice Cubes': 0.12},
    'grande': {'Espresso Shots': 2, 'Caramel Syrup': 35, 'Caramel Drizzle': 20, 'Fresh Milk': 140, 'Ice Cubes': 0.18},
  },

  // ===== FRAPPE - CREAM BASED =====
  '28': { // Matcha Cream
    'tall': {'Matcha Powder': 18, 'Heavy Cream': 50, 'Fresh Milk': 80, 'White Sugar': 15, 'Ice Cubes': 0.12},
    'grande': {'Matcha Powder': 25, 'Heavy Cream': 70, 'Fresh Milk': 110, 'White Sugar': 22, 'Ice Cubes': 0.18},
  },
  '29': { // Cookies & Cream Frappe
    'tall': {'Crushed Oreo': 30, 'Heavy Cream': 50, 'Fresh Milk': 80, 'Vanilla Syrup': 15, 'Ice Cubes': 0.12},
    'grande': {'Crushed Oreo': 45, 'Heavy Cream': 70, 'Fresh Milk': 110, 'Vanilla Syrup': 22, 'Ice Cubes': 0.18},
  },
  '30': { // Cheesecake Cream
    'tall': {'Cheesecake Powder': 25, 'Cream Cheese': 20, 'Heavy Cream': 40, 'Fresh Milk': 80, 'Ice Cubes': 0.12},
    'grande': {'Cheesecake Powder': 35, 'Cream Cheese': 30, 'Heavy Cream': 55, 'Fresh Milk': 110, 'Ice Cubes': 0.18},
  },
  '31': { // Taro Cream
    'tall': {'Taro Powder': 30, 'Heavy Cream': 50, 'Fresh Milk': 80, 'Ice Cubes': 0.12},
    'grande': {'Taro Powder': 42, 'Heavy Cream': 70, 'Fresh Milk': 110, 'Ice Cubes': 0.18},
  },
  '32': { // Chocolate Cream
    'tall': {'Dark Chocolate Powder': 25, 'Heavy Cream': 50, 'Fresh Milk': 80, 'Ice Cubes': 0.12},
    'grande': {'Dark Chocolate Powder': 35, 'Heavy Cream': 70, 'Fresh Milk': 110, 'Ice Cubes': 0.18},
  },
  '33': { // Strawberry Cream
    'tall': {'Strawberry Puree': 40, 'Heavy Cream': 50, 'Fresh Milk': 80, 'Ice Cubes': 0.12},
    'grande': {'Strawberry Puree': 55, 'Heavy Cream': 70, 'Fresh Milk': 110, 'Ice Cubes': 0.18},
  },

  // ===== FRUITIES =====
  // NOTE: Crystal Boba and Popping Boba are optional toppings, handled as add-ons
  '34': { // Kiwi
    'tall': {'Kiwi Syrup': 40, 'White Sugar': 10, 'Fresh Lemons': 1, 'Ice Cubes': 0.1},
    'grande': {'Kiwi Syrup': 55, 'White Sugar': 15, 'Fresh Lemons': 1, 'Ice Cubes': 0.14},
  },
  '35': { // Lemon
    'tall': {'Lemon Syrup': 35, 'Fresh Lemons': 2, 'Honey': 20, 'Ice Cubes': 0.1},
    'grande': {'Lemon Syrup': 50, 'Fresh Lemons': 3, 'Honey': 28, 'Ice Cubes': 0.14},
  },
  '36': { // Honey Peach
    'tall': {'Peach Syrup': 40, 'Honey': 15, 'Ice Cubes': 0.1},
    'grande': {'Peach Syrup': 55, 'Honey': 22, 'Ice Cubes': 0.14},
  },
  '37': { // Passion Fruit
    'tall': {'Passion Fruit Syrup': 35, 'Passion Fruit Puree': 25, 'White Sugar': 8, 'Ice Cubes': 0.1},
    'grande': {'Passion Fruit Syrup': 50, 'Passion Fruit Puree': 35, 'White Sugar': 12, 'Ice Cubes': 0.14},
  },
  '38': { // Lychee
    'tall': {'Lychee Syrup': 40, 'Aloe Vera': 30, 'Ice Cubes': 0.1},
    'grande': {'Lychee Syrup': 55, 'Aloe Vera': 45, 'Ice Cubes': 0.14},
  },
  '39': { // Green Apple
    'tall': {'Green Apple Syrup': 40, 'Fresh Mint Leaves': 5, 'Ice Cubes': 0.1},
    'grande': {'Green Apple Syrup': 55, 'Fresh Mint Leaves': 8, 'Ice Cubes': 0.14},
  },
  '40': { // Mango
    'tall': {'Mango Syrup': 30, 'Mango Puree': 40, 'Ice Cubes': 0.1},
    'grande': {'Mango Syrup': 42, 'Mango Puree': 55, 'Ice Cubes': 0.14},
  },
  '41': { // Blueberry
    'tall': {'Blueberry Syrup': 35, 'Blueberry Puree': 25, 'Ice Cubes': 0.1},
    'grande': {'Blueberry Syrup': 50, 'Blueberry Puree': 35, 'Ice Cubes': 0.14},
  },
  '42': { // Strawberry Fruities
    'tall': {'Strawberry Syrup': 35, 'Strawberry Puree': 30, 'Ice Cubes': 0.1},
    'grande': {'Strawberry Syrup': 50, 'Strawberry Puree': 42, 'Ice Cubes': 0.14},
  },


  // ===== WAFFLES =====
  '43': { // Classic Waffle
    'tall': {'Waffle Batter Mix': 100, 'Eggs': 1, 'Fresh Milk': 50, 'Butter': 20, 'Maple Syrup': 30},
    'grande': {'Waffle Batter Mix': 150, 'Eggs': 2, 'Fresh Milk': 75, 'Butter': 30, 'Maple Syrup': 45},
  },
  '44': { // Chocolate Waffle
    'tall': {'Waffle Batter Mix': 100, 'Eggs': 1, 'Fresh Milk': 50, 'Butter': 15, 'Chocolate Drizzle': 40, 'Cocoa Powder': 5},
    'grande': {'Waffle Batter Mix': 150, 'Eggs': 2, 'Fresh Milk': 75, 'Butter': 25, 'Chocolate Drizzle': 60, 'Cocoa Powder': 8},
  },
  '45': { // Strawberry Waffle
    'tall': {'Waffle Batter Mix': 100, 'Eggs': 1, 'Fresh Milk': 50, 'Butter': 15, 'Fresh Strawberries': 80, 'Whipped Cream': 1},
    'grande': {'Waffle Batter Mix': 150, 'Eggs': 2, 'Fresh Milk': 75, 'Butter': 25, 'Fresh Strawberries': 120, 'Whipped Cream': 2},
  },
  '46': { // Nutella Waffle
    'tall': {'Waffle Batter Mix': 100, 'Eggs': 1, 'Fresh Milk': 50, 'Butter': 15, 'Nutella Spread': 1, 'Crushed Hazelnuts': 15},
    'grande': {'Waffle Batter Mix': 150, 'Eggs': 2, 'Fresh Milk': 75, 'Butter': 25, 'Nutella Spread': 1, 'Crushed Hazelnuts': 25},
  },
  '47': { // Ice Cream Waffle
    'tall': {'Waffle Batter Mix': 100, 'Eggs': 1, 'Fresh Milk': 50, 'Butter': 15, 'Vanilla Ice Cream': 80, 'Chocolate Drizzle': 25},
    'grande': {'Waffle Batter Mix': 150, 'Eggs': 2, 'Fresh Milk': 75, 'Butter': 25, 'Vanilla Ice Cream': 120, 'Chocolate Drizzle': 35},
  },
  '48': { // Banana Caramel
    'tall': {'Waffle Batter Mix': 100, 'Eggs': 1, 'Fresh Milk': 50, 'Butter': 20, 'Fresh Bananas': 1, 'Caramel Drizzle': 35},
    'grande': {'Waffle Batter Mix': 150, 'Eggs': 2, 'Fresh Milk': 75, 'Butter': 30, 'Fresh Bananas': 2, 'Caramel Drizzle': 50},
  },
};

// ========== ADD-ON RECIPES ==========
// Maps add-on ID -> ingredient name -> amount needed

final Map<String, Map<String, double>> addOnRecipes = {
  '1': {'Tapioca Pearls': 50}, // Pearl
  '2': {'Crystal Boba': 50}, // Crystal
  '3': {'Coffee Jelly': 50}, // Coffee Jelly
  '4': {'Popping Boba (Mixed)': 50}, // Popping Boba
  '5': {'Crushed Oreo': 1}, // Crushed Oreo (packs)
  '6': {'Cream Cheese': 20}, // Cream Cheese
  '7': {'Espresso Shots': 1}, // Espresso Shot
  '8': {'Whipped Cream': 1}, // Whipped Cream (cans - 0.5 per serving)
};

// Helper function to get recipe for a product
Map<String, double>? getProductRecipe(String productId, String size) {
  return productRecipes[productId]?[size];
}

// Helper function to get recipe for an add-on
Map<String, double>? getAddOnRecipe(String addOnId) {
  return addOnRecipes[addOnId];
}
