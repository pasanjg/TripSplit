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
    Category(name: 'accommodation', icon: CupertinoIcons.bed_double),
    Category(name: 'entertainment', icon: CupertinoIcons.game_controller),
    Category(name: 'shopping', icon: CupertinoIcons.shopping_cart),
    Category(name: 'other', icon: CupertinoIcons.square_stack_3d_up_slash),
  ];

  static Category getCategory(String name) {
    return categories.firstWhere((category) => category.name == name);
  }
}