class Validators {
  static String formatDateYMD(DateTime date) {
    final String y = date.year.toString().padLeft(4, '0');
    final String m = date.month.toString().padLeft(2, '0');
    final String d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static bool isValidEmail(String input) {
    final String value = input.trim();
    if (value.isEmpty) return false;
    final RegExp re = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
    return re.hasMatch(value);
  }

  static bool isValidPhone(String input) {
    final String value = input.trim();
    if (value.isEmpty) return false;
    // Allows optional +, digits, spaces, dashes, parentheses; 7-15 digits total
    final RegExp digits = RegExp(r'\d');
    final int count = digits.allMatches(value).length;
    if (count < 7 || count > 15) return false;
    final RegExp re = RegExp(r'^\+?[0-9 ()-]+$');
    return re.hasMatch(value);
  }
}


