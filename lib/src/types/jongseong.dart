import '../_internal/constants.dart' show jongseongs;

/// String 자리에 그대로 사용할 수 있다 (`implements String`).
extension type Jongseong(String value) implements String {
  static Jongseong? tryParse(String input) {
    if (!jongseongs.contains(input)) return null;

    return Jongseong(input);
  }

  int get index => jongseongs.indexOf(value);
}
