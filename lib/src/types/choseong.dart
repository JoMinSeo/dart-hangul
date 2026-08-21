import '../_internal/constants.dart' show choseongs;

/// String 자리에 그대로 사용할 수 있다 (`implements String`).
extension type Choseong(String value) implements String {
  static Choseong? tryParse(String input) {
    if (!choseongs.contains(input)) return null;

    return Choseong(input);
  }

  int get index => choseongs.indexOf(value);
}
