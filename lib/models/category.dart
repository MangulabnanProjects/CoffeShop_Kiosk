class Category {
  final String id;
  final String name;
  final bool isSpecial;

  Category({
    required this.id,
    required this.name,
    this.isSpecial = false,
  });
}

// Menu categories based on Mr. Buenaz menu
final List<Category> sampleCategories = [
  Category(id: '0', name: 'Popular Choice', isSpecial: true),
  Category(id: '1', name: 'All Products'),
  Category(id: '6', name: 'Hot Coffee'),
  Category(id: '2', name: 'Iced Coffee'),
  Category(id: '3', name: 'Milk Tea'),
  Category(id: '4', name: 'Frappe'),
  Category(id: '5', name: 'Fruities'),
  Category(id: '7', name: 'Waffles'),
];
