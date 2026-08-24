import '../_internal/constants.dart' show disassembledVowelsByVowel, jungseongs;

/// 중성(ㅏ~ㅣ). 저장값은 항상 분해형이다 (`ㅘ` → `'ㅗㅏ'`).
/// String 자리에 그대로 사용할 수 있다 (`implements String`).
extension type Jungseong(String value) implements String {
  /// [input]이 중성이면 분해형으로 정규화한 [Jungseong]으로(`'ㅘ'` → `'ㅗㅏ'`), 아니면 `null`을 반환합니다.
  static Jungseong? tryParse(String input) {
    if (input.isEmpty) return null;

    // 조합형 이중모음(예: 'ㅘ')이면 분해형(예: 'ㅗㅏ')으로 정규화한다.
    final normalized = disassembledVowelsByVowel[input] ?? input;

    if (!jungseongs.contains(normalized)) return null;

    return Jungseong(normalized);
  }

  /// 중성 테이블(ㅏ=0 … ㅣ=20)에서의 인덱스. 유니코드 완성형 조합 공식에 쓰입니다.
  int get index => jungseongs.indexOf(value);
}
