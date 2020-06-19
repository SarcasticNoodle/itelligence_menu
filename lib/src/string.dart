/// String extensions
extension StringX on String {
  /// If the trimmed string is empty return null
  String get nullIfWhiteSpace {
    if (trim().isEmpty) return null;
    return this;
  }
}
