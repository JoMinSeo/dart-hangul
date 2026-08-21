import '../_internal/constants.dart' show disassembledVowelsByVowel, jungseongs;

/// String 자리에 그대로 사용할 수 있다 (`implements String`).
extension type Jungseong(String value) implements String {
  static Jungseong? tryParse(String input) {
    if (input.isEmpty) return null;

    // 조합형 이중모음(예: 'ㅘ')이면 분해형(예: 'ㅗㅏ')으로 정규화한다.
    final normalized = disassembledVowelsByVowel[input] ?? input;

    if (!jungseongs.contains(normalized)) return null;

    return Jungseong(normalized);
  }

  int get index => jungseongs.indexOf(value);
}
