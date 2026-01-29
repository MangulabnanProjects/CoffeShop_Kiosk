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
  });
}

// Global set to track out-of-stock products (shared between Menu Management and ordering)
final Set<String> outOfStockProductIds = {};

// Products based on Mr. Buenaz menu with detailed descriptions
final List<Product> sampleProducts = [
  // ICED COFFEE
  Product(id: '1', name: 'Mr. Mocha', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Rich espresso blended with premium dark chocolate and fresh milk, served over ice. A bold and bittersweet flavor perfect for hot summer days when you need that chocolate coffee kick to power through.'),
  Product(id: '2', name: 'Mr. Vanilla', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Smooth espresso infused with Madagascar vanilla syrup and creamy cold milk. Sweet and aromatic, this refreshing drink is ideal for warm afternoons when you crave something light yet satisfying.'),
  Product(id: '3', name: 'Mr. Matcha', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Premium Japanese green tea powder paired with a shot of espresso and chilled milk. Earthy and slightly sweet, this unique fusion is great for any season and gives you calm energy throughout the day.', isPopular: true),
  Product(id: '4', name: 'Mr. Caramel', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Buttery caramel sauce swirled with bold espresso and fresh cold milk. Indulgently sweet with a smooth finish, perfect for satisfying your sweet tooth on a hot day or as an afternoon treat.', isPopular: true),
  Product(id: '5', name: 'Mr. Caramel Macchiato', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Beautifully layered espresso with vanilla-infused milk and rich caramel drizzle on top. The perfect balance of sweet and bold, ideal for coffee lovers who enjoy a visually stunning drink any time of year.'),
  Product(id: '6', name: 'Mr. Hazel Macchiato', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Toasted hazelnut syrup blended with espresso and steamed milk in delicate layers. Nutty and aromatic with a cozy warmth, this drink is especially comforting during cool rainy seasons.', isNew: true),
  Product(id: '7', name: 'Mr. White Mochaccino', categoryId: '2', priceTall: 39, priceGrande: 49, description: 'Luxurious white chocolate melted into smooth espresso with cold creamy milk. Sweet and velvety with a mild coffee taste, this is a crowd favorite for those who prefer milder coffee drinks year-round.', isNew: true),

  // MILK TEA (with pearl)
  Product(id: '8', name: 'Okinawa', categoryId: '3', priceTall: 29, priceGrande: 39, description: 'Brown sugar milk tea with authentic roasted Okinawa flavor and chewy tapioca pearls. Rich caramel-like sweetness with a hint of smokiness, perfect for satisfying cravings any time of day or season.', isPopular: true),
  Product(id: '9', name: 'Wintermelon', categoryId: '3', priceTall: 29, priceGrande: 39, description: 'Sweet wintermelon extract blended with fresh milk and soft tapioca pearls. Light, refreshing, and subtly sweet, this classic milk tea is ideal for hot summer days when you need a cool refreshment.', isPopular: true),
  Product(id: '10', name: 'Chocolate', categoryId: '3', priceTall: 29, priceGrande: 39, description: 'Rich cocoa powder mixed with creamy milk tea base and chewy pearls. Decadent chocolate flavor with tea undertones, great for chocolate lovers looking for a unique twist any season.'),
  Product(id: '11', name: 'Taro', categoryId: '3', priceTall: 29, priceGrande: 39, description: 'Purple taro root extract blended with creamy milk and soft tapioca pearls. Naturally sweet with a nutty, vanilla-like flavor, this Instagram-worthy drink is delightful for any occasion year-round.', isPopular: true),
  Product(id: '12', name: 'Strawberry', categoryId: '3', priceTall: 29, priceGrande: 39, description: 'Fresh strawberry puree swirled into milk tea with chewy tapioca pearls. Fruity and refreshing with a creamy texture, perfect for spring and summer when strawberries are at their sweetest.'),
  Product(id: '13', name: 'Cheesecake', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Cream cheese flavor infused into smooth milk tea with soft tapioca pearls. Rich and tangy like your favorite dessert, this indulgent drink is perfect for treating yourself any time of year.'),
  Product(id: '14', name: 'Dark Choco', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Intense dark chocolate blended with milk tea base and chewy pearls. Bold and bittersweet with deep cocoa notes, ideal for chocolate purists who enjoy rich flavors during cool evenings.'),
  Product(id: '15', name: 'Choco Kisses', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Milk chocolate sweetness mixed with creamy tea and soft tapioca pearls. Smooth and comforting like a warm hug, this sweet treat is wonderful for rainy days or whenever you need a mood boost.'),
  Product(id: '16', name: 'Red Velvet', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Red velvet cake flavor with subtle cream cheese notes and chewy pearls. Velvety smooth with a hint of cocoa, this dessert-inspired drink is perfect for special occasions or everyday indulgence.'),
  Product(id: '17', name: 'Matcha', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Premium Japanese matcha whisked into fresh milk with soft tapioca pearls. Earthy, slightly bitter with natural sweetness, this antioxidant-rich drink is great for health-conscious sipping any season.'),
  Product(id: '18', name: 'Salted Caramel', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Sweet and salty caramel swirled into creamy milk tea with chewy pearls. The perfect balance of flavors that dance on your tongue, ideal for those who love complex taste profiles year-round.'),
  Product(id: '19', name: 'Cookies & Cream', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Crushed Oreo cookies blended into creamy milk tea with soft tapioca pearls. Crunchy cookie bits in every sip, this nostalgic flavor is a hit with kids and adults alike any time of year.', isPopular: true),
  Product(id: '20', name: 'Double Dutch', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Double chocolate intensity with milk tea base and chewy tapioca pearls. Extra rich and deeply chocolatey, perfect for serious chocolate cravings during cold weather or late-night treats.'),
  Product(id: '21', name: 'Choco Hazelnut', categoryId: '3', priceTall: 39, priceGrande: 49, description: 'Nutella-inspired hazelnut chocolate blended with milk tea and soft pearls. Creamy, nutty, and irresistibly sweet, this drink tastes like dessert in a cup for any season.', isNew: true),
  Product(id: '22', name: 'Chocoberry', categoryId: '3', priceTall: 0, priceGrande: 49, description: 'Chocolate and strawberry fusion with creamy milk tea and chewy pearls. A romantic blend of fruity and chocolatey notes, perfect for date nights or springtime refreshment.'),

  // FRAPPE - Coffee-Based (with whipped cream)
  Product(id: '23', name: 'Coffee Jelly', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Blended coffee frappe with chewy coffee jelly bits and fluffy whipped cream. Bold coffee flavor with fun texture, perfect for hot summer days when you need caffeine and refreshment together.', isPopular: true),
  Product(id: '24', name: 'Java Chip', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Mocha frappe blended with chocolate chips and topped with whipped cream. Crunchy chocolate pieces in every sip, this indulgent treat is ideal for satisfying coffee and chocolate cravings on warm days.', isPopular: true),
  Product(id: '25', name: 'Vanilla Frappe', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Classic vanilla bean frappe with smooth espresso and airy whipped cream. Sweet and aromatic with a caffeine boost, perfect for afternoon pick-me-ups during any season.'),
  Product(id: '26', name: 'Mocha Frappe', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Rich dark chocolate and espresso blended with ice and crowned with whipped cream. Bold and decadent, this frozen treat is a coffee shop staple for beating the summer heat.'),
  Product(id: '27', name: 'Caramel Macchiato', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Caramel swirled frappe with espresso layers and generous whipped cream topping. Sweet butterscotch notes with coffee depth, perfect for those who love Instagram-worthy drinks year-round.'),
  
  // FRAPPE - Cream-Based
  Product(id: '28', name: 'Matcha Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Japanese matcha blended with sweet cream base and fluffy whipped topping. Earthy green tea flavor in a creamy frozen form, great for matcha lovers seeking refreshment in warm weather.'),
  Product(id: '29', name: 'Cookies & Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Crushed Oreos blended with vanilla cream and topped with whipped cream. Like a cookies and cream milkshake, this nostalgic treat is perfect for hot days and sweet cravings year-round.', isPopular: true),
  Product(id: '30', name: 'Cheesecake Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Creamy cheesecake flavor blended with ice and crowned with whipped cream. Rich and tangy dessert taste, ideal for treating yourself on special occasions or lazy summer afternoons.'),
  Product(id: '31', name: 'Taro Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Purple taro blended with cream base and soft whipped cream topping. Naturally sweet with nutty undertones, this beautiful drink is perfect for photos and refreshment any season.'),
  Product(id: '32', name: 'Chocolate Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Rich dark chocolate blended with vanilla cream and piled with whipped cream. Intense chocolate flavor in every frozen sip, perfect for chocolate lovers beating the summer heat.'),
  Product(id: '33', name: 'Strawberry Cream', categoryId: '4', priceTall: 59, priceGrande: 69, description: 'Fresh strawberry puree with cream base and airy whipped cream topping. Fruity and refreshing like a strawberry milkshake, ideal for spring and summer enjoyment.'),

  // FRUITIES (with crystal/popping boba)
  Product(id: '34', name: 'Kiwi', categoryId: '5', priceTall: 29, priceGrande: 39, description: 'Fresh kiwi fruit tea with crystal boba and real fruit bits. Tangy and refreshing with tropical vibes, this vitamin-rich drink is perfect for hot summer days when you need natural refreshment.'),
  Product(id: '35', name: 'Lemon', categoryId: '5', priceTall: 29, priceGrande: 39, description: 'Zesty lemon tea with natural honey and bursting popping boba pearls. Bright and citrusy with a sweet finish, ideal for detoxing and staying refreshed during warm weather.'),
  Product(id: '36', name: 'Honey Peach', categoryId: '5', priceTall: 29, priceGrande: 39, description: 'Sweet peach tea infused with natural honey and crystal boba pearls. Juicy and aromatic like biting into a fresh peach, perfect for spring and summer when peaches are in season.'),
  Product(id: '37', name: 'Passion Fruit', categoryId: '5', priceTall: 29, priceGrande: 39, description: 'Tropical passion fruit tea with popping boba and real passion fruit seeds. Tangy, exotic, and refreshing, this tropical escape is ideal for hot days when you dream of island vibes.', isPopular: true),
  Product(id: '38', name: 'Lychee', categoryId: '5', priceTall: 39, priceGrande: 49, description: 'Sweet lychee fruit tea with crystal boba and refreshing aloe vera bits. Floral and delicate with natural sweetness, this elegant drink is perfect for sophisticated refreshment any season.'),
  Product(id: '39', name: 'Green Apple', categoryId: '5', priceTall: 39, priceGrande: 49, description: 'Crisp green apple tea with popping boba and fresh mint leaves. Tart and refreshing with a cooling finish, ideal for hot days when you need something bright and energizing.'),
  Product(id: '40', name: 'Mango', categoryId: '5', priceTall: 39, priceGrande: 49, description: 'Tropical mango puree blended with fruit tea and bursting popping boba. Sweet and sunny like a tropical vacation, this fan favorite is perfect for summer days and mango season.', isPopular: true),
  Product(id: '41', name: 'Blueberry', categoryId: '5', priceTall: 39, priceGrande: 49, description: 'Sweet blueberry tea with crystal boba and real blueberry pieces. Antioxidant-rich with natural berry sweetness, great for health-conscious sipping during any season.'),
  Product(id: '42', name: 'Strawberry', categoryId: '5', priceTall: 39, priceGrande: 49, description: 'Fresh strawberry fruit tea with popping boba pearls and real fruit bits. Sweet and refreshing like strawberry fields, perfect for spring and summer when berries are abundant.'),

  // WAFFLES (Coming Soon)
  Product(id: '43', name: 'Classic Waffle', categoryId: '7', priceTall: 79, priceGrande: 99, description: 'Golden crispy Belgian waffle with creamy butter and pure maple syrup. Light and fluffy inside with a satisfying crunch, perfect for breakfast or as a comforting snack any time of day.', isComingSoon: true),
  Product(id: '44', name: 'Chocolate Waffle', categoryId: '7', priceTall: 89, priceGrande: 109, description: 'Warm Belgian waffle drizzled with rich dark chocolate sauce and cocoa powder. Decadent and indulgent, this chocolate lovers dream is perfect for dessert or a sweet afternoon treat.', isComingSoon: true),
  Product(id: '45', name: 'Strawberry Waffle', categoryId: '7', priceTall: 89, priceGrande: 109, description: 'Crispy waffle topped with fresh sliced strawberries and fluffy whipped cream. Fruity and refreshing with a sweet finish, ideal for spring brunches or summer dessert cravings.', isComingSoon: true),
  Product(id: '46', name: 'Nutella Waffle', categoryId: '7', priceTall: 99, priceGrande: 119, description: 'Warm waffle generously spread with creamy Nutella and sprinkled with crushed hazelnuts. Rich hazelnut chocolate heaven, perfect for satisfying serious sweet tooth cravings any season.', isComingSoon: true),
  Product(id: '47', name: 'Ice Cream Waffle', categoryId: '7', priceTall: 99, priceGrande: 119, description: 'Fresh crispy waffle topped with a scoop of vanilla ice cream and chocolate drizzle. Warm and cold contrast in every bite, this indulgent treat is perfect for hot summer days.', isComingSoon: true),
  Product(id: '48', name: 'Banana Caramel', categoryId: '7', priceTall: 89, priceGrande: 109, description: 'Crispy waffle with sliced fresh bananas and warm buttery caramel sauce. Sweet and fruity with rich caramel notes, a comforting choice for cozy rainy days or weekend brunch.', isComingSoon: true),
];

// Get popular products
List<Product> get popularProducts => sampleProducts.where((p) => p.isPopular).toList();
