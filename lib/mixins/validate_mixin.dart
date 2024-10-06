mixin ValidateMixin {
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email) ? null : 'Please enter a valid email';
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    }
    return password.length >= 8
        ? null
        : 'Password must be at least 8 characters';
  }

  String? validateText(String? text) {
    if (text == null || text.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? validateNumber(String? number, {
    double? minValue,
    double? maxValue,
  }) {
    if (number == null || number.isEmpty) {
      return 'This field is required';
    }

    final numberRegExp = RegExp(r'^\d+(\.\d+)?$');
    if (!numberRegExp.hasMatch(number)) {
      return 'Please enter a valid number';
    }

    if (minValue != null && double.parse(number) < minValue) {
      return 'Please enter a value greater than $minValue';
    }

    if (maxValue != null && double.parse(number) > maxValue) {
      return 'Please enter a value less than $maxValue';
    }

    return null;
  }

  String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (password == null || confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    return password == confirmPassword ? null : 'Passwords do not match';
  }
}
