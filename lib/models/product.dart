class Product {
  final String id;
  final String name;
  final String categoryId;
  final double priceTall; // 16oz
  final double priceGrande; // 22oz
  final String description;
  final bool isPopular;
  final bool isNew;
  final bool isComingSoon;
  final String? imagePath; // Optional product image path
  final Map<String, double> ingredientsTall; // 16oz: ingredientName -> amount in smallUnit
  final Map<String, double> ingredientsGrande; // 22oz: ingredientName -> amount in smallUnit

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.priceTall,
    required this.priceGrande,
    this.description = '',
    this.isPopular = false,
    this.isNew = false,
    this.isComingSoon = false,
    this.imagePath,
    this.ingredientsTall = const {},
    this.ingredientsGrande = const {},
  });

  // For editing existing products
  Product copyWith({
    String? id,
    String? name,
    String? categoryId,
    double? priceTall,
    double? priceGrande,
    String? description,
    bool? isPopular,
    bool? isNew,
    bool? isComingSoon,
    String? imagePath,
    Map<String, double>? ingredientsTall,
    Map<String, double>? ingredientsGrande,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      priceTall: priceTall ?? this.priceTall,
      priceGrande: priceGrande ?? this.priceGrande,
      description: description ?? this.description,
      isPopular: isPopular ?? this.isPopular,
      isNew: isNew ?? this.isNew,
      isComingSoon: isComingSoon ?? this.isComingSoon,
      imagePath: imagePath ?? this.imagePath,
      ingredientsTall: ingredientsTall ?? this.ingredientsTall,
      ingredientsGrande: ingredientsGrande ?? this.ingredientsGrande,
    );
  }
}



// Global set to track out-of-stock products (shared between Menu Management and ordering)
final Set<String> outOfStockProductIds = {};

// Products based on Mr. Buenaz menu with detailed descriptions
// All products now have pre-filled ingredients for 16oz (Tall) and 22oz (Grande) sizes
final List<Product> sampleProducts = [
  // ICED COFFEE
  Product(id: '1', name: 'Mr. Mocha', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Rich espresso blended with premium dark chocolate and fresh milk, served over ice.', 
    ingredientsTall: {'Espresso Shots': 1, 'Fresh Milk': 150, 'Chocolate Syrup': 30, 'Ice Cubes': 100},
    ingredientsGrande: {'Espresso Shots': 2, 'Fresh Milk': 200, 'Chocolate Syrup': 40, 'Ice Cubes': 150}),
  Product(id: '2', name: 'Mr. Vanilla', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Smooth espresso infused with Madagascar vanilla syrup and creamy cold milk.',
    ingredientsTall: {'Espresso Shots': 1, 'Fresh Milk': 150, 'Vanilla Syrup': 30, 'Ice Cubes': 100},
    ingredientsGrande: {'Espresso Shots': 2, 'Fresh Milk': 200, 'Vanilla Syrup': 40, 'Ice Cubes': 150}),
  Product(id: '3', name: 'Mr. Matcha', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Premium Japanese green tea powder paired with espresso and chilled milk.', isPopular: true,
    ingredientsTall: {'Espresso Shots': 1, 'Fresh Milk': 150, 'Matcha Powder': 15, 'Ice Cubes': 100},
    ingredientsGrande: {'Espresso Shots': 2, 'Fresh Milk': 200, 'Matcha Powder': 20, 'Ice Cubes': 150}),
  Product(id: '4', name: 'Mr. Caramel', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Buttery caramel sauce swirled with bold espresso and fresh cold milk.', isPopular: true,
    ingredientsTall: {'Espresso Shots': 1, 'Fresh Milk': 150, 'Caramel Syrup': 30, 'Ice Cubes': 100},
    ingredientsGrande: {'Espresso Shots': 2, 'Fresh Milk': 200, 'Caramel Syrup': 40, 'Ice Cubes': 150}),
  Product(id: '5', name: 'Mr. Caramel Macchiato', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Layered espresso with vanilla-infused milk and rich caramel drizzle.',
    ingredientsTall: {'Espresso Shots': 1, 'Fresh Milk': 150, 'Vanilla Syrup': 20, 'Caramel Drizzle': 15, 'Ice Cubes': 100},
    ingredientsGrande: {'Espresso Shots': 2, 'Fresh Milk': 200, 'Vanilla Syrup': 30, 'Caramel Drizzle': 20, 'Ice Cubes': 150}),
  Product(id: '6', name: 'Mr. Hazel Macchiato', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Toasted hazelnut syrup blended with espresso and steamed milk.', isNew: true,
    ingredientsTall: {'Espresso Shots': 1, 'Fresh Milk': 150, 'Hazelnut Syrup': 30, 'Ice Cubes': 100},
    ingredientsGrande: {'Espresso Shots': 2, 'Fresh Milk': 200, 'Hazelnut Syrup': 40, 'Ice Cubes': 150}),
  Product(id: '7', name: 'Mr. White Mochaccino', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Luxurious white chocolate melted into smooth espresso with cold creamy milk.', isNew: true,
    ingredientsTall: {'Espresso Shots': 1, 'Fresh Milk': 150, 'White Chocolate Powder': 25, 'Ice Cubes': 100},
    ingredientsGrande: {'Espresso Shots': 2, 'Fresh Milk': 200, 'White Chocolate Powder': 35, 'Ice Cubes': 150}),

  // MILK TEA (with pearl)
  Product(id: '8', name: 'Okinawa', categoryId: '3', priceTall: 29, priceGrande: 39, description: 'Brown sugar milk tea with authentic roasted Okinawa flavor and chewy tapioca pearls.', isPopular: true,
    ingredientsTall: {'Okinawa Powder': 25, 'Fresh Milk': 120, 'Brown Sugar': 20, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Okinawa Powder': 35, 'Fresh Milk': 160, 'Brown Sugar': 30, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '9', name: 'Wintermelon', categoryId: '3', priceTall: 29, priceGrande: 39, description: 'Sweet wintermelon extract blended with fresh milk and soft tapioca pearls.', isPopular: true,
    ingredientsTall: {'Wintermelon Powder': 25, 'Fresh Milk': 120, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Wintermelon Powder': 35, 'Fresh Milk': 160, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '10', name: 'Chocolate', categoryId: '3', priceTall: 29, priceGrande: 39, description: 'Rich cocoa powder mixed with creamy milk tea base and chewy pearls.',
    ingredientsTall: {'Cocoa Powder': 25, 'Fresh Milk': 120, 'Milk Tea Powder': 15, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Cocoa Powder': 35, 'Fresh Milk': 160, 'Milk Tea Powder': 20, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '11', name: 'Taro', categoryId: '3', priceTall: 29, priceGrande: 39, description: 'Purple taro root extract blended with creamy milk and soft tapioca pearls.', isPopular: true,
    ingredientsTall: {'Taro Powder': 30, 'Fresh Milk': 120, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Taro Powder': 40, 'Fresh Milk': 160, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '12', name: 'Strawberry', categoryId: '3', priceTall: 29, priceGrande: 39, description: 'Fresh strawberry puree swirled into milk tea with chewy tapioca pearls.',
    ingredientsTall: {'Strawberry Syrup': 30, 'Fresh Milk': 120, 'Milk Tea Powder': 15, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Strawberry Syrup': 40, 'Fresh Milk': 160, 'Milk Tea Powder': 20, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '13', name: 'Cheesecake', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Cream cheese flavor infused into smooth milk tea with soft tapioca pearls.',
    ingredientsTall: {'Cheesecake Powder': 30, 'Fresh Milk': 120, 'Cream Cheese': 20, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Cheesecake Powder': 40, 'Fresh Milk': 160, 'Cream Cheese': 30, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '14', name: 'Dark Choco', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Intense dark chocolate blended with milk tea base and chewy pearls.',
    ingredientsTall: {'Dark Chocolate Powder': 30, 'Fresh Milk': 120, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Dark Chocolate Powder': 40, 'Fresh Milk': 160, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '15', name: 'Choco Kisses', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Milk chocolate sweetness mixed with creamy tea and soft tapioca pearls.',
    ingredientsTall: {'Cocoa Powder': 25, 'Fresh Milk': 130, 'Chocolate Syrup': 20, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Cocoa Powder': 35, 'Fresh Milk': 170, 'Chocolate Syrup': 30, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '16', name: 'Red Velvet', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Red velvet cake flavor with subtle cream cheese notes and chewy pearls.',
    ingredientsTall: {'Red Velvet Powder': 30, 'Fresh Milk': 120, 'Cream Cheese': 15, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Red Velvet Powder': 40, 'Fresh Milk': 160, 'Cream Cheese': 25, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '17', name: 'Matcha', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Premium Japanese matcha whisked into fresh milk with soft tapioca pearls.',
    ingredientsTall: {'Matcha Powder': 20, 'Fresh Milk': 130, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Matcha Powder': 30, 'Fresh Milk': 170, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '18', name: 'Salted Caramel', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Sweet and salty caramel swirled into creamy milk tea with chewy pearls.',
    ingredientsTall: {'Salted Caramel Syrup': 30, 'Fresh Milk': 120, 'Milk Tea Powder': 15, 'Tapioca Pearls': 50, 'Sea Salt': 1, 'Ice Cubes': 80},
    ingredientsGrande: {'Salted Caramel Syrup': 40, 'Fresh Milk': 160, 'Milk Tea Powder': 20, 'Tapioca Pearls': 70, 'Sea Salt': 2, 'Ice Cubes': 120}),
  Product(id: '19', name: 'Cookies & Cream', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Crushed Oreo cookies blended into creamy milk tea with soft tapioca pearls.', isPopular: true,
    ingredientsTall: {'Crushed Oreo': 25, 'Fresh Milk': 130, 'Milk Tea Powder': 15, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Crushed Oreo': 35, 'Fresh Milk': 170, 'Milk Tea Powder': 20, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '20', name: 'Double Dutch', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Double chocolate intensity with milk tea base and chewy tapioca pearls.',
    ingredientsTall: {'Cocoa Powder': 20, 'Dark Chocolate Powder': 20, 'Fresh Milk': 120, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Cocoa Powder': 30, 'Dark Chocolate Powder': 30, 'Fresh Milk': 160, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '21', name: 'Choco Hazelnut', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Nutella-inspired hazelnut chocolate blended with milk tea and soft pearls.', isNew: true,
    ingredientsTall: {'Nutella Spread': 25, 'Cocoa Powder': 15, 'Fresh Milk': 120, 'Hazelnut Syrup': 15, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Nutella Spread': 35, 'Cocoa Powder': 20, 'Fresh Milk': 160, 'Hazelnut Syrup': 25, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),
  Product(id: '22', name: 'Chocoberry', categoryId: '3', priceTall: 0, priceGrande: 49, description: 'Chocolate and strawberry fusion with creamy milk tea and chewy pearls.',
    ingredientsTall: {'Cocoa Powder': 20, 'Strawberry Syrup': 20, 'Fresh Milk': 120, 'Tapioca Pearls': 50, 'Ice Cubes': 80},
    ingredientsGrande: {'Cocoa Powder': 30, 'Strawberry Syrup': 30, 'Fresh Milk': 160, 'Tapioca Pearls': 70, 'Ice Cubes': 120}),

  // FRAPPE - Coffee-Based (with whipped cream)
  Product(id: '23', name: 'Coffee Jelly', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Blended coffee frappe with chewy coffee jelly bits and fluffy whipped cream.', isPopular: true,
    ingredientsTall: {'Espresso Shots': 2, 'Fresh Milk': 100, 'Coffee Jelly': 50, 'Whipped Cream': 30, 'Ice Cubes': 150},
    ingredientsGrande: {'Espresso Shots': 3, 'Fresh Milk': 150, 'Coffee Jelly': 70, 'Whipped Cream': 40, 'Ice Cubes': 200}),
  Product(id: '24', name: 'Java Chip', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Mocha frappe blended with chocolate chips and topped with whipped cream.', isPopular: true,
    ingredientsTall: {'Espresso Shots': 2, 'Fresh Milk': 100, 'Chocolate Chips': 30, 'Chocolate Syrup': 25, 'Whipped Cream': 30, 'Ice Cubes': 150},
    ingredientsGrande: {'Espresso Shots': 3, 'Fresh Milk': 150, 'Chocolate Chips': 45, 'Chocolate Syrup': 35, 'Whipped Cream': 40, 'Ice Cubes': 200}),
  Product(id: '25', name: 'Vanilla Frappe', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Classic vanilla bean frappe with smooth espresso and airy whipped cream.',
    ingredientsTall: {'Espresso Shots': 2, 'Fresh Milk': 100, 'Vanilla Syrup': 35, 'Whipped Cream': 30, 'Ice Cubes': 150},
    ingredientsGrande: {'Espresso Shots': 3, 'Fresh Milk': 150, 'Vanilla Syrup': 50, 'Whipped Cream': 40, 'Ice Cubes': 200}),
  Product(id: '26', name: 'Mocha Frappe', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Rich dark chocolate and espresso blended with ice and crowned with whipped cream.',
    ingredientsTall: {'Espresso Shots': 2, 'Fresh Milk': 100, 'Dark Chocolate Powder': 25, 'Chocolate Syrup': 20, 'Whipped Cream': 30, 'Ice Cubes': 150},
    ingredientsGrande: {'Espresso Shots': 3, 'Fresh Milk': 150, 'Dark Chocolate Powder': 35, 'Chocolate Syrup': 30, 'Whipped Cream': 40, 'Ice Cubes': 200}),
  Product(id: '27', name: 'Caramel Macchiato', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Caramel swirled frappe with espresso layers and generous whipped cream topping.',
    ingredientsTall: {'Espresso Shots': 2, 'Fresh Milk': 100, 'Caramel Syrup': 30, 'Caramel Drizzle': 15, 'Whipped Cream': 30, 'Ice Cubes': 150},
    ingredientsGrande: {'Espresso Shots': 3, 'Fresh Milk': 150, 'Caramel Syrup': 40, 'Caramel Drizzle': 25, 'Whipped Cream': 40, 'Ice Cubes': 200}),
  
  // FRAPPE - Cream-Based
  Product(id: '28', name: 'Matcha Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Japanese matcha blended with sweet cream base and fluffy whipped topping.',
    ingredientsTall: {'Matcha Powder': 20, 'Fresh Milk': 120, 'Heavy Cream': 30, 'Whipped Cream': 30, 'Ice Cubes': 150},
    ingredientsGrande: {'Matcha Powder': 30, 'Fresh Milk': 170, 'Heavy Cream': 40, 'Whipped Cream': 40, 'Ice Cubes': 200}),
  Product(id: '29', name: 'Cookies & Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Crushed Oreos blended with vanilla cream and topped with whipped cream.', isPopular: true,
    ingredientsTall: {'Crushed Oreo': 35, 'Fresh Milk': 120, 'Vanilla Syrup': 20, 'Whipped Cream': 30, 'Ice Cubes': 150},
    ingredientsGrande: {'Crushed Oreo': 50, 'Fresh Milk': 170, 'Vanilla Syrup': 30, 'Whipped Cream': 40, 'Ice Cubes': 200}),
  Product(id: '30', name: 'Cheesecake Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Creamy cheesecake flavor blended with ice and crowned with whipped cream.',
    ingredientsTall: {'Cheesecake Powder': 30, 'Fresh Milk': 100, 'Cream Cheese': 25, 'Heavy Cream': 30, 'Whipped Cream': 30, 'Ice Cubes': 150},
    ingredientsGrande: {'Cheesecake Powder': 40, 'Fresh Milk': 150, 'Cream Cheese': 35, 'Heavy Cream': 40, 'Whipped Cream': 40, 'Ice Cubes': 200}),
  Product(id: '31', name: 'Taro Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Purple taro blended with cream base and soft whipped cream topping.',
    ingredientsTall: {'Taro Powder': 35, 'Fresh Milk': 120, 'Heavy Cream': 30, 'Whipped Cream': 30, 'Ice Cubes': 150},
    ingredientsGrande: {'Taro Powder': 50, 'Fresh Milk': 170, 'Heavy Cream': 40, 'Whipped Cream': 40, 'Ice Cubes': 200}),
  Product(id: '32', name: 'Chocolate Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Rich dark chocolate blended with vanilla cream and piled with whipped cream.',
    ingredientsTall: {'Dark Chocolate Powder': 30, 'Fresh Milk': 100, 'Chocolate Syrup': 25, 'Heavy Cream': 30, 'Whipped Cream': 30, 'Ice Cubes': 150},
    ingredientsGrande: {'Dark Chocolate Powder': 40, 'Fresh Milk': 150, 'Chocolate Syrup': 35, 'Heavy Cream': 40, 'Whipped Cream': 40, 'Ice Cubes': 200}),
  Product(id: '33', name: 'Strawberry Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Fresh strawberry puree with cream base and airy whipped cream topping.',
    ingredientsTall: {'Strawberry Puree': 50, 'Fresh Milk': 100, 'Strawberry Syrup': 20, 'Heavy Cream': 30, 'Whipped Cream': 30, 'Ice Cubes': 150},
    ingredientsGrande: {'Strawberry Puree': 70, 'Fresh Milk': 150, 'Strawberry Syrup': 30, 'Heavy Cream': 40, 'Whipped Cream': 40, 'Ice Cubes': 200}),

  // FRUITIES (with crystal/popping boba)
  Product(id: '34', name: 'Kiwi', categoryId: '5', priceTall: 29, priceGrande: 39, description: 'Fresh kiwi fruit tea with crystal boba and real fruit bits.',
    ingredientsTall: {'Kiwi Syrup': 40, 'Crystal Boba': 40, 'Ice Cubes': 100},
    ingredientsGrande: {'Kiwi Syrup': 55, 'Crystal Boba': 55, 'Ice Cubes': 150}),
  Product(id: '35', name: 'Lemon', categoryId: '5', priceTall: 29, priceGrande: 39, description: 'Zesty lemon tea with natural honey and bursting popping boba pearls.',
    ingredientsTall: {'Lemon Syrup': 40, 'Honey': 15, 'Popping Boba (Mixed)': 40, 'Ice Cubes': 100},
    ingredientsGrande: {'Lemon Syrup': 55, 'Honey': 25, 'Popping Boba (Mixed)': 55, 'Ice Cubes': 150}),
  Product(id: '36', name: 'Honey Peach', categoryId: '5', priceTall: 29, priceGrande: 39, description: 'Sweet peach tea infused with natural honey and crystal boba pearls.',
    ingredientsTall: {'Peach Syrup': 40, 'Honey': 20, 'Crystal Boba': 40, 'Ice Cubes': 100},
    ingredientsGrande: {'Peach Syrup': 55, 'Honey': 30, 'Crystal Boba': 55, 'Ice Cubes': 150}),
  Product(id: '37', name: 'Passion Fruit', categoryId: '5', priceTall: 29, priceGrande: 39, description: 'Tropical passion fruit tea with popping boba and real passion fruit seeds.', isPopular: true,
    ingredientsTall: {'Passion Fruit Syrup': 35, 'Passion Fruit Puree': 20, 'Popping Boba (Mixed)': 40, 'Ice Cubes': 100},
    ingredientsGrande: {'Passion Fruit Syrup': 50, 'Passion Fruit Puree': 30, 'Popping Boba (Mixed)': 55, 'Ice Cubes': 150}),
  Product(id: '38', name: 'Lychee', categoryId: '5', priceTall: 39, priceGrande: 49, description: 'Sweet lychee fruit tea with crystal boba and refreshing aloe vera bits.',
    ingredientsTall: {'Lychee Syrup': 40, 'Crystal Boba': 35, 'Aloe Vera': 25, 'Ice Cubes': 100},
    ingredientsGrande: {'Lychee Syrup': 55, 'Crystal Boba': 50, 'Aloe Vera': 35, 'Ice Cubes': 150}),
  Product(id: '39', name: 'Green Apple', categoryId: '5', priceTall: 39, priceGrande: 49, description: 'Crisp green apple tea with popping boba and fresh mint leaves.',
    ingredientsTall: {'Green Apple Syrup': 45, 'Popping Boba (Mixed)': 40, 'Fresh Mint Leaves': 3, 'Ice Cubes': 100},
    ingredientsGrande: {'Green Apple Syrup': 60, 'Popping Boba (Mixed)': 55, 'Fresh Mint Leaves': 5, 'Ice Cubes': 150}),
  Product(id: '40', name: 'Mango', categoryId: '5', priceTall: 39, priceGrande: 49, description: 'Tropical mango puree blended with fruit tea and bursting popping boba.', isPopular: true,
    ingredientsTall: {'Mango Syrup': 35, 'Mango Puree': 30, 'Popping Boba (Mixed)': 40, 'Ice Cubes': 100},
    ingredientsGrande: {'Mango Syrup': 50, 'Mango Puree': 45, 'Popping Boba (Mixed)': 55, 'Ice Cubes': 150}),
  Product(id: '41', name: 'Blueberry', categoryId: '5', priceTall: 39, priceGrande: 49, description: 'Sweet blueberry tea with crystal boba and real blueberry pieces.',
    ingredientsTall: {'Blueberry Syrup': 35, 'Blueberry Puree': 25, 'Crystal Boba': 40, 'Ice Cubes': 100},
    ingredientsGrande: {'Blueberry Syrup': 50, 'Blueberry Puree': 35, 'Crystal Boba': 55, 'Ice Cubes': 150}),
  Product(id: '42', name: 'Strawberry', categoryId: '5', priceTall: 39, priceGrande: 49, description: 'Fresh strawberry fruit tea with popping boba pearls and real fruit bits.',
    ingredientsTall: {'Strawberry Syrup': 35, 'Strawberry Puree': 25, 'Popping Boba (Mixed)': 40, 'Ice Cubes': 100},
    ingredientsGrande: {'Strawberry Syrup': 50, 'Strawberry Puree': 35, 'Popping Boba (Mixed)': 55, 'Ice Cubes': 150}),

  // WAFFLES (Coming Soon)
  Product(id: '43', name: 'Classic Waffle', categoryId: '7', priceTall: 79, priceGrande: 99, description: 'Golden crispy Belgian waffle with creamy butter and pure maple syrup.', isComingSoon: true,
    ingredientsTall: {'Waffle Batter Mix': 100, 'Eggs': 1, 'Butter': 30, 'Maple Syrup': 30},
    ingredientsGrande: {'Waffle Batter Mix': 150, 'Eggs': 2, 'Butter': 45, 'Maple Syrup': 45}),
  Product(id: '44', name: 'Chocolate Waffle', categoryId: '7', priceTall: 89, priceGrande: 109, description: 'Warm Belgian waffle drizzled with rich dark chocolate sauce and cocoa powder.', isComingSoon: true,
    ingredientsTall: {'Waffle Batter Mix': 100, 'Eggs': 1, 'Chocolate Drizzle': 40, 'Cocoa Powder': 10},
    ingredientsGrande: {'Waffle Batter Mix': 150, 'Eggs': 2, 'Chocolate Drizzle': 60, 'Cocoa Powder': 15}),
  Product(id: '45', name: 'Strawberry Waffle', categoryId: '7', priceTall: 89, priceGrande: 109, description: 'Crispy waffle topped with fresh sliced strawberries and fluffy whipped cream.', isComingSoon: true,
    ingredientsTall: {'Waffle Batter Mix': 100, 'Eggs': 1, 'Fresh Strawberries': 80, 'Whipped Cream': 40},
    ingredientsGrande: {'Waffle Batter Mix': 150, 'Eggs': 2, 'Fresh Strawberries': 120, 'Whipped Cream': 60}),
  Product(id: '46', name: 'Nutella Waffle', categoryId: '7', priceTall: 99, priceGrande: 119, description: 'Warm waffle generously spread with creamy Nutella and sprinkled with crushed hazelnuts.', isComingSoon: true,
    ingredientsTall: {'Waffle Batter Mix': 100, 'Eggs': 1, 'Nutella Spread': 50, 'Crushed Hazelnuts': 15},
    ingredientsGrande: {'Waffle Batter Mix': 150, 'Eggs': 2, 'Nutella Spread': 75, 'Crushed Hazelnuts': 25}),
  Product(id: '47', name: 'Ice Cream Waffle', categoryId: '7', priceTall: 99, priceGrande: 119, description: 'Fresh crispy waffle topped with a scoop of vanilla ice cream and chocolate drizzle.', isComingSoon: true,
    ingredientsTall: {'Waffle Batter Mix': 100, 'Eggs': 1, 'Vanilla Ice Cream': 80, 'Chocolate Drizzle': 25},
    ingredientsGrande: {'Waffle Batter Mix': 150, 'Eggs': 2, 'Vanilla Ice Cream': 120, 'Chocolate Drizzle': 40}),
  Product(id: '48', name: 'Banana Caramel', categoryId: '7', priceTall: 89, priceGrande: 109, description: 'Crispy waffle with sliced fresh bananas and warm buttery caramel sauce.', isComingSoon: true,
    ingredientsTall: {'Waffle Batter Mix': 100, 'Eggs': 1, 'Fresh Bananas': 1, 'Caramel Drizzle': 40},
    ingredientsGrande: {'Waffle Batter Mix': 150, 'Eggs': 2, 'Fresh Bananas': 2, 'Caramel Drizzle': 60}),
];


// Get popular products
List<Product> get popularProducts => sampleProducts.where((p) => p.isPopular).toList();
