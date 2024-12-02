bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  final a = double.tryParse(
    s,
  );
  return a != null;
}
