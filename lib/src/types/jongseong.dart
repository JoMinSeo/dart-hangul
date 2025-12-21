import '../_internal/constants.dart' show jongseongs;

extension type Jongseong(String value) {
  static Jongseong? tryParse(String input) {
    if (!jongseongs.contains(input)) return null;

    return Jongseong(input);
  }

  int get index => jongseongs.indexOf(value);
}
