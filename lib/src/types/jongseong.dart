import '../_internal/constants.dart' show disassembledConsonantsByConsonant, jongseongs;

/// String 자리에 그대로 사용할 수 있다 (`implements String`).
extension type Jongseong(String value) implements String {
  static Jongseong? tryParse(String input) {
    // 합성형 겹받침(예: 'ㄳ')이면 분해형(예: 'ㄱㅅ')으로 정규화한다 — Jungseong 과 같은 규칙. 저장값은 항상 분해형.
    final normalized = disassembledConsonantsByConsonant[input] ?? input;

    if (!jongseongs.contains(normalized)) return null;

    return Jongseong(normalized);
  }

  int get index => jongseongs.indexOf(value);
}
