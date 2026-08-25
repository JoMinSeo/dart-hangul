import '../_internal/constants.dart' show choseongs;

/// 초성(ㄱ~ㅎ) 한 글자. String 자리에 그대로 사용할 수 있다 (`implements String`).
///
/// 직접 생성할 수 없고 [tryParse]·[fromIndex] 로만 만든다 — 저장값이 항상 유효한 초성임을 보장한다.
extension type Choseong._(String value) implements String {
  /// 초성 테이블 인덱스(ㄱ=0 … ㅎ=18)로 만듭니다. [index] 의 역연산. 범위 밖이면 [RangeError].
  Choseong.fromIndex(int index) : this._(choseongs[index]);

  /// [input]이 초성이면 [Choseong]으로, 아니면 `null`을 반환합니다.
  static Choseong? tryParse(String input) => _indexByValue.containsKey(input) ? Choseong._(input) : null;

  /// 초성 테이블(ㄱ=0 … ㅎ=18)에서의 인덱스. 유니코드 완성형 조합 공식에 쓰입니다.
  int get index => _indexByValue[value]!;

  static final Map<String, int> _indexByValue = {for (final (i, v) in choseongs.indexed) v: i};
}
