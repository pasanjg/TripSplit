part of 'extensions.dart';

extension ColorBrightnessX on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

extension ColorX on Color {
  String toHexTriplet() => '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  MaterialColor toMaterialColor() {
    List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = {};
    final int r = red, g = green, b = blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;

      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(value, swatch);
  }
}

extension ColorLuminanceX on Color {
  Color contrastColor({double luminance = 0.5}) {
    assert(luminance >= 0 && luminance <= 1);

    return Color(value).computeLuminance() > luminance
        ? Colors.black
        : Colors.white;
  }

  Brightness contrastBrightness({double luminance = 0.5}) {
    assert(luminance >= 0 && luminance <= 1);

    return Color(value).computeLuminance() > luminance
        ? Brightness.dark
        : Brightness.light;
  }
}
