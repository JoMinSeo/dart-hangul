import '../_internal/constants.dart' show disassembledConsonantsByConsonant, jongseongs;

/// 종성(받침). 저장값은 항상 분해형이고(`ㄳ` → `'ㄱㅅ'`), 종성 없음은 빈 문자열이다.
/// String 자리에 그대로 사용할 수 있다 (`implements String`).
extension type Jongseong(String value) implements String {
  /// [input]이 종성이면 분해형으로 정규화한 [Jongseong]으로(`'ㄳ'` → `'ㄱㅅ'`), 아니면 `null`을 반환합니다.
  static Jongseong? tryParse(String input) {
    // 합성형 겹받침(예: 'ㄳ')이면 분해형(예: 'ㄱㅅ')으로 정규화한다 — Jungseong 과 같은 규칙. 저장값은 항상 분해형.
    final normalized = disassembledConsonantsByConsonant[input] ?? input;

    if (!jongseongs.contains(normalized)) return null;

    return Jongseong(normalized);
  }

  /// 종성 테이블(없음=0, ㄱ=1 … ㅎ=27)에서의 인덱스. 유니코드 완성형 조합 공식에 쓰입니다.
  int get index => jongseongs.indexOf(value);
}
