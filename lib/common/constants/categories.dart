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
    Category(name: 'food', icon: Icons.fastfood_rounded, color: const Color(0xFFFF5D37)),
    Category(name: 'drinks', icon: Icons.wine_bar_rounded, color: const Color(0xFF730643)),
    Category(name: 'transport', icon: Icons.directions_bus_rounded, color: const Color(0xFF079383)),
    Category(name: 'fuel', icon: Icons.local_gas_station_rounded, color: const Color(0xFFFFA000)),
    Category(name: 'accommodation', icon: Icons.hotel_rounded, color: const Color(0xFF2542C5)),
    Category(name: 'entertainment', icon: Icons.gamepad_rounded, color: const Color(0xFFC107FF)),
    Category(name: 'shopping', icon: Icons.shopping_cart_rounded, color: const Color(0xFF008EFF)),
    Category(name: 'health_&_safety', icon: Icons.favorite, color: const Color(0xFFFF0000)),
    Category(name: 'other', icon: Icons.square, color: const Color(0xFF9E9E9E)),
  ];

  static Category getCategory(String name) {
    return categories.firstWhere((category) => category.name == name.toLowerCase());
  }
}