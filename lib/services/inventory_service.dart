import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../widgets/product_detail_dialog.dart';

/// Inventory Service - Manages ingredient stock and product availability
class InventoryService {
  // Singleton pattern
  static final InventoryService _instance = InventoryService._internal();
  factory InventoryService() => _instance;
  InventoryService._internal();

  /// Get ingredient by name
  Ingredient? getIngredientByName(String name) {
    try {
      return sampleIngredients.firstWhere((i) => i.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Get ingredient index by name
  int getIngredientIndex(String name) {
    return sampleIngredients.indexWhere((i) => i.name == name);
  }

  /// Convert recipe amount to ingredient unit
  /// Recipe amounts are in smallest units (ml, g, pcs)
  /// All ingredients now use standard units: L, kg, pcs
  double convertToIngredientUnit(String ingredientName, double amount) {
    final ingredient = getIngredientByName(ingredientName);
    if (ingredient == null) return amount;

    // Convert from small unit to main unit based on ingredient's unit type
    // e.g., 150ml -> 0.15 L (divide by 1000)
    // e.g., 30g -> 0.03 kg (divide by 1000)
    // pcs remain as-is

    switch (ingredient.unit) {
      case 'L':
        // Recipe amount is in ml, convert to L
        return amount / 1000;
      case 'kg':
        // Recipe amount is in g, convert to kg
        return amount / 1000;
      case 'pcs':
        // Already in pieces
        return amount;
      default:
        return amount;
    }
  }

  /// Deduct supplies (cups, lids, straws) for an order
  void deductSupplies(String size, int quantity) {
    // Determine which cup to use
    final cupName = size == 'tall' ? 'Cups (16oz)' : 'Cups (22oz)';
    
    // Deduct cup
    final cupIndex = getIngredientIndex(cupName);
    if (cupIndex != -1) {
      final cup = sampleIngredients[cupIndex];
      sampleIngredients[cupIndex] = cup.copyWith(
        currentStock: (cup.currentStock - quantity).clamp(0.0, cup.maxStock),
        usedAmount: cup.usedAmount + quantity,
      );
    }
    
    // Deduct lid (1 per cup)
    final lidIndex = getIngredientIndex('Plastic Lids');
    if (lidIndex != -1) {
      final lid = sampleIngredients[lidIndex];
      sampleIngredients[lidIndex] = lid.copyWith(
        currentStock: (lid.currentStock - quantity).clamp(0.0, lid.maxStock),
        usedAmount: lid.usedAmount + quantity,
      );
    }
    
    // Deduct straw (1 per drink)
    final strawIndex = getIngredientIndex('Straws');
    if (strawIndex != -1) {
      final straw = sampleIngredients[strawIndex];
      sampleIngredients[strawIndex] = straw.copyWith(
        currentStock: (straw.currentStock - quantity).clamp(0.0, straw.maxStock),
        usedAmount: straw.usedAmount + quantity,
      );
    }
  }


  /// Check if an ingredient has enough stock
  bool hasEnoughStock(String ingredientName, double recipeAmount) {
    final ingredient = getIngredientByName(ingredientName);
    if (ingredient == null) return false;

    final amountNeeded = convertToIngredientUnit(ingredientName, recipeAmount);
    return ingredient.currentStock >= amountNeeded;
  }

  /// Get max servings for a product based on current stock
  int getMaxServings(String productId, String size) {
    final recipe = getProductRecipe(productId, size);
    if (recipe == null) return 0;

    int minServings = 999999;

    for (final entry in recipe.entries) {
      final ingredientName = entry.key;
      final recipeAmount = entry.value;
      
      final ingredient = getIngredientByName(ingredientName);
      if (ingredient == null) return 0;

      final amountPerServing = convertToIngredientUnit(ingredientName, recipeAmount);
      if (amountPerServing <= 0) continue;

      final servings = (ingredient.currentStock / amountPerServing).floor();
      if (servings < minServings) {
        minServings = servings;
      }
    }

    return minServings == 999999 ? 0 : minServings;
  }

  /// Get list of missing ingredients for a product
  List<String> getMissingIngredients(String productId, String size) {
    final recipe = getProductRecipe(productId, size);
    if (recipe == null) return [];

    final missing = <String>[];
    for (final entry in recipe.entries) {
      final ingredientName = entry.key;
      final recipeAmount = entry.value;

      if (!hasEnoughStock(ingredientName, recipeAmount)) {
        final ingredient = getIngredientByName(ingredientName);
        if (ingredient != null && ingredient.currentStock <= 0) {
          missing.add(ingredientName);
        }
      }
    }
    return missing;
  }

  /// Get list of low stock ingredients for a product (< 6 servings)
  List<String> getLowIngredients(String productId, String size) {
    final recipe = getProductRecipe(productId, size);
    if (recipe == null) return [];

    final low = <String>[];
    for (final entry in recipe.entries) {
      final ingredientName = entry.key;
      final recipeAmount = entry.value;

      final ingredient = getIngredientByName(ingredientName);
      if (ingredient == null) continue;

      final amountPerServing = convertToIngredientUnit(ingredientName, recipeAmount);
      if (amountPerServing <= 0) continue;

      final servings = (ingredient.currentStock / amountPerServing).floor();
      if (servings > 0 && servings < 6) {
        low.add(ingredientName);
      }
    }
    return low;
  }

  /// Check full product availability
  ProductAvailability checkProductAvailability(String productId, String size) {
    final maxServings = getMaxServings(productId, size);
    final missing = getMissingIngredients(productId, size);
    final low = getLowIngredients(productId, size);

    String? warningMessage;
    if (missing.isNotEmpty) {
      warningMessage = 'No ${missing.first}';
    } else if (maxServings > 0 && maxServings < 6) {
      // Find the ingredient with lowest stock
      final recipe = getProductRecipe(productId, size);
      if (recipe != null) {
        String? lowestIngredient;
        int lowestServings = 999;
        for (final entry in recipe.entries) {
          final amountPerServing = convertToIngredientUnit(entry.key, entry.value);
          final ingredient = getIngredientByName(entry.key);
          if (ingredient != null && amountPerServing > 0) {
            final servings = (ingredient.currentStock / amountPerServing).floor();
            if (servings < lowestServings) {
              lowestServings = servings;
              lowestIngredient = entry.key;
            }
          }
        }
        if (lowestIngredient != null) {
          warningMessage = 'Low: $lowestIngredient ($lowestServings left)';
        }
      }
    }

    return ProductAvailability(
      isAvailable: maxServings > 0,
      maxServings: maxServings,
      missingIngredients: missing,
      lowIngredients: low,
      warningMessage: warningMessage,
    );
  }

  /// Deduct ingredients for a product
  void deductForProduct(String productId, String size, int quantity) {
    final recipe = getProductRecipe(productId, size);
    if (recipe == null) return;

    for (final entry in recipe.entries) {
      final ingredientName = entry.key;
      final recipeAmount = entry.value;
      final amountToDeduct = convertToIngredientUnit(ingredientName, recipeAmount) * quantity;

      final index = getIngredientIndex(ingredientName);
      if (index != -1) {
        final current = sampleIngredients[index];
        final newStock = (current.currentStock - amountToDeduct).clamp(0.0, current.maxStock);
        sampleIngredients[index] = current.copyWith(
          currentStock: newStock,
          usedAmount: current.usedAmount + amountToDeduct,
        );
      }
    }
  }

  /// Deduct ingredients for add-ons
  void deductForAddOns(List<AddOn> addOns, int quantity) {
    for (final addOn in addOns) {
      final recipe = getAddOnRecipe(addOn.id);
      if (recipe == null) continue;

      for (final entry in recipe.entries) {
        final ingredientName = entry.key;
        final recipeAmount = entry.value;
        final amountToDeduct = convertToIngredientUnit(ingredientName, recipeAmount) * quantity;

        final index = getIngredientIndex(ingredientName);
        if (index != -1) {
          final current = sampleIngredients[index];
          final newStock = (current.currentStock - amountToDeduct).clamp(0.0, current.maxStock);
          sampleIngredients[index] = current.copyWith(
            currentStock: newStock,
            usedAmount: current.usedAmount + amountToDeduct,
          );
        }
      }
    }
  }

  /// Deduct ingredients for a cart item
  void deductForCartItem(CartItem item) {
    deductForProduct(item.product.id, item.size, item.quantity);
    deductForAddOns(item.addOns, item.quantity);
    
    // Deduct supplies (cups, lids, straws) for drinks only (not waffles)
    // Category 7 is Waffles - no cups/lids/straws needed
    if (item.product.categoryId != '7') {
      deductSupplies(item.size, item.quantity);
    }
  }


  /// Deduct ingredients for an entire order
  void deductForOrder(Order order) {
    for (final item in order.items) {
      deductForCartItem(item);
    }
  }

  /// Check if any ingredients are critically low (can't make 6+ products)
  bool hasLowStockWarning() {
    // Check if any ingredient is low enough that it affects multiple products
    for (final ingredient in sampleIngredients) {
      // Check by percentage - if below 20% consider it critically low
      if (ingredient.currentStock > 0 && ingredient.stockPercentage <= 0.2) {
        return true;
      }
    }
    return false;
  }

  /// Get count of ingredients that are running low
  int getLowStockCount() {
    int count = 0;
    for (final ingredient in sampleIngredients) {
      if (ingredient.currentStock > 0 && ingredient.stockPercentage <= 0.2) {
        count++;
      }
    }
    return count;
  }

  /// Get ingredients sorted with low stock at the top
  List<Ingredient> getIngredientsSortedByUrgency() {
    final sorted = List<Ingredient>.from(sampleIngredients);
    sorted.sort((a, b) {
      // Out of stock first
      if (a.currentStock <= 0 && b.currentStock > 0) return -1;
      if (b.currentStock <= 0 && a.currentStock > 0) return 1;
      // Then by stock percentage (lowest first)
      return a.stockPercentage.compareTo(b.stockPercentage);
    });
    return sorted;
  }

  /// Check add-on availability
  bool isAddOnAvailable(String addOnId) {
    final recipe = getAddOnRecipe(addOnId);
    if (recipe == null) return true; // If no recipe, assume available

    for (final entry in recipe.entries) {
      if (!hasEnoughStock(entry.key, entry.value)) {
        return false;
      }
    }
    return true;
  }
  
  /// Get the reason why an add-on is unavailable (returns ingredient name)
  String? getAddOnUnavailableReason(String addOnId) {
    final recipe = getAddOnRecipe(addOnId);
    if (recipe == null) return null;

    for (final entry in recipe.entries) {
      if (!hasEnoughStock(entry.key, entry.value)) {
        // Return a friendly ingredient name
        final ingredientName = entry.key;
        // Simplify ingredient names for display
        switch (ingredientName) {
          case 'Tapioca Pearls':
            return 'Pearl';
          case 'Crystal Boba':
            return 'Crystal';
          case 'Coffee Jelly':
            return 'Coffee Jelly';
          case 'Popping Boba (Mixed)':
            return 'Popping Boba';
          case 'Crushed Oreo':
            return 'Oreo';
          case 'Cream Cheese':
            return 'Cream Cheese';
          case 'Espresso Shots':
            return 'Espresso';
          case 'Whipped Cream':
            return 'Whipped Cream';
          default:
            return ingredientName;
        }
      }
    }
    return null;
  }
}


// Global instance
final inventoryService = InventoryService();
