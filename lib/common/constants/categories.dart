part of 'constants.dart';

class Category {
  late String name;
  late IconData icon;

  Category({
    required this.name,
    required this.icon,
  });

  String get displayName {
    return name.split('_').map((e) => e.capitalize()).join(' ');
  }

  static List<Category> categories = [
    Category(name: 'food', icon: Icons.fastfood_rounded),
    Category(name: 'drinks', icon: Icons.wine_bar_rounded),
    Category(name: 'transport', icon: Icons.directions_bus_rounded),
    Category(name: 'fuel', icon: Icons.local_gas_station_rounded),
    Category(name: 'accommodation', icon: Icons.hotel_rounded),
    Category(name: 'entertainment', icon: Icons.gamepad_rounded),
    Category(name: 'shopping', icon: Icons.shopping_cart_rounded),
    Category(name: 'other', icon: Icons.square),
  ];

  static Category getCategory(String name) {
    return categories.firstWhere((category) => category.name == name.toLowerCase());
  }
}