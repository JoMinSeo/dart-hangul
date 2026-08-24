import '../_internal/constants.dart' show choseongs;

/// 초성(ㄱ~ㅎ) 한 글자. String 자리에 그대로 사용할 수 있다 (`implements String`).
extension type Choseong(String value) implements String {
  /// [input]이 초성이면 [Choseong]으로, 아니면 `null`을 반환합니다.
  static Choseong? tryParse(String input) {
    if (!choseongs.contains(input)) return null;

    return Choseong(input);
  }

  /// 초성 테이블(ㄱ=0 … ㅎ=18)에서의 인덱스. 유니코드 완성형 조합 공식에 쓰입니다.
  int get index => choseongs.indexOf(value);
}
