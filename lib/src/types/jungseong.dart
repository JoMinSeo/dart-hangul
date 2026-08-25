import '../_internal/constants.dart' show disassembledVowelsByVowel, jungseongs;

/// 중성(ㅏ~ㅣ). 저장값은 항상 분해형이다 (`ㅘ` → `'ㅗㅏ'`).
/// String 자리에 그대로 사용할 수 있다 (`implements String`).
///
/// 직접 생성할 수 없고 [tryParse]·[fromIndex] 로만 만든다 — 저장값이 항상 유효한 분해형 중성임을 보장한다.
extension type Jungseong._(String value) implements String {
  /// 중성 테이블 인덱스(ㅏ=0 … ㅣ=20)로 만듭니다. [index] 의 역연산. 범위 밖이면 [RangeError].
  Jungseong.fromIndex(int index) : this._(jungseongs[index]);

  /// [input]이 중성이면 분해형으로 정규화한 [Jungseong]으로(`'ㅘ'` → `'ㅗㅏ'`), 아니면 `null`을 반환합니다.
  static Jungseong? tryParse(String input) {
    // 조합형 이중모음(예: 'ㅘ')이면 분해형(예: 'ㅗㅏ')으로 정규화한다.
    final normalized = disassembledVowelsByVowel[input] ?? input;

    return _indexByValue.containsKey(normalized) ? Jungseong._(normalized) : null;
  }

  /// 중성 테이블(ㅏ=0 … ㅣ=20)에서의 인덱스. 유니코드 완성형 조합 공식에 쓰입니다.
  int get index => _indexByValue[value]!;

  static final Map<String, int> _indexByValue = {for (final (i, v) in jungseongs.indexed) v: i};
}
