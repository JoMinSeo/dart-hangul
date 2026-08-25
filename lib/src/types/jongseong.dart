import '../_internal/constants.dart' show disassembledConsonantsByConsonant, jongseongs;

/// 종성(받침). 저장값은 항상 분해형이고(`ㄳ` → `'ㄱㅅ'`), 종성 없음은 빈 문자열이다.
/// String 자리에 그대로 사용할 수 있다 (`implements String`).
///
/// 직접 생성할 수 없고 [tryParse]·[fromIndex] 로만 만든다 — 저장값이 항상 유효한 분해형 종성임을 보장한다.
extension type Jongseong._(String value) implements String {
  /// 종성 테이블 인덱스(없음=0, ㄱ=1 … ㅎ=27)로 만듭니다. [index] 의 역연산. 범위 밖이면 [RangeError].
  Jongseong.fromIndex(int index) : this._(jongseongs[index]);

  /// [input]이 종성이면 분해형으로 정규화한 [Jongseong]으로(`'ㄳ'` → `'ㄱㅅ'`), 아니면 `null`을 반환합니다.
  /// 빈 문자열은 "종성 없음" 으로 유효하다.
  static Jongseong? tryParse(String input) {
    // 합성형 겹받침(예: 'ㄳ')이면 분해형(예: 'ㄱㅅ')으로 정규화한다 — Jungseong 과 같은 규칙.
    final normalized = disassembledConsonantsByConsonant[input] ?? input;

    return _indexByValue.containsKey(normalized) ? Jongseong._(normalized) : null;
  }

  /// 종성 테이블(없음=0, ㄱ=1 … ㅎ=27)에서의 인덱스. 유니코드 완성형 조합 공식에 쓰입니다.
  int get index => _indexByValue[value]!;

  static final Map<String, int> _indexByValue = {for (final (i, v) in jongseongs.indexed) v: i};
}
