extension StringExtension on String {
  String swapChars(int first, int last) {
    var firstChar = this[first];
    var lastChar = this[last];
    var firstPart = substring(0, first) + lastChar;
    var secondPart = substring(first + 1, last) + firstChar;
    var lastPart = substring(last + 1);
    return firstPart + secondPart + lastPart;
  }

  String get reversed {
    var s = StringBuffer();
    for (var i = length - 1; i >= 0; i--) {
      s.write(this[i]);
    }
    return s.toString();
  }
}