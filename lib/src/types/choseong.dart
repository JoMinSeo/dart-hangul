import '../_internal/constants.dart' show choseongs;

extension type Choseong(String value) {
  static Choseong? tryParse(String input) {
    if (!choseongs.contains(input)) return null;

    return Choseong(input);
  }

  int get index => choseongs.indexOf(value);
}
