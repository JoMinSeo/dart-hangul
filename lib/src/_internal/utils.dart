bool hasValueInReadOnlyStringList<T extends String>(List<T> list, String value) {
  return list.any((item) => item == value);
}

({List<String> rest, String last}) excludeLastElement(List<String> array) {
  if (array.isEmpty) return (rest: const [], last: '');

  return (rest: array.sublist(0, array.length - 1), last: array.last);
}

extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull {
    var iterator = this.iterator;

    if (iterator.moveNext()) return iterator.current;

    return null;
  }

  T? get lastOrNull {
    var iterator = this.iterator;

    if (!iterator.moveNext()) return null;

    T result;

    do {
      result = iterator.current;
    } while (iterator.moveNext());

    return result;
  }
}
