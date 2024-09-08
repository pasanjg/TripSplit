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
}

extension ColorLuminanceX on Color {
  Color computedLuminance({double luminance = 0.5}) {
    assert(luminance >= 0 && luminance <= 1);

    return Color(value).computeLuminance() > luminance
        ? Colors.black
        : Colors.white;
  }

  Brightness computedBrightness({double luminance = 0.5}) {
    assert(luminance >= 0 && luminance <= 1);

    return Color(value).computeLuminance() > luminance
        ? Brightness.dark
        : Brightness.light;
  }
}
