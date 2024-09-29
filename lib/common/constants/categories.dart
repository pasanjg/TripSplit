part of 'constants.dart';

class Category {
  late String name;
  late IconData icon;
  late Color color;

  Category({
    required this.name,
    required this.icon,
    required this.color,
  });

  String get displayName {
    return name.split('_').map((e) => e.capitalize()).join(' ');
  }

  static List<Category> categories = [
    Category(name: 'food', icon: Icons.fastfood_rounded, color: Colors.red),
    Category(name: 'drinks', icon: Icons.wine_bar_rounded, color: Colors.green),
    Category(name: 'transport', icon: Icons.directions_bus_rounded, color: Colors.blue),
    Category(name: 'fuel', icon: Icons.local_gas_station_rounded, color: Colors.amber),
    Category(name: 'accommodation', icon: Icons.hotel_rounded, color: Colors.purple),
    Category(name: 'entertainment', icon: Icons.gamepad_rounded, color: Colors.orange),
    Category(name: 'shopping', icon: Icons.shopping_cart_rounded, color: Colors.pinkAccent),
    Category(name: 'other', icon: Icons.square, color: Colors.grey),
  ];

  static Category getCategory(String name) {
    return categories.firstWhere((category) => category.name == name.toLowerCase());
  }
}