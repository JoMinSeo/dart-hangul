({List<String> rest, String last}) excludeLastElement(List<String> array) {
  if (array.isEmpty) return (rest: const [], last: '');

  return (rest: array.sublist(0, array.length - 1), last: array.last);
}

/// 숫자를 정수부/소수부 문자열로 나눈다. 소수부가 없으면 `decimal` 은 null.
///
/// `12345.678` → `(integer: '12345', decimal: '678')`, `5.0` → `(integer: '5', decimal: null)`
({String integer, String? decimal}) splitNumberString(num number) {
  final parts = number.toString().split('.');
  final decimal = parts.length > 1 && parts[1] != '0' ? parts[1] : null; // double 5.0 → '5'
  return (integer: parts[0], decimal: decimal);
}
