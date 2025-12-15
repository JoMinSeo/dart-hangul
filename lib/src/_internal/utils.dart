bool hasValueInReadOnlyStringList<T extends String>(List<T> list, String value) {
  return list.any((item) => item == value);
}
