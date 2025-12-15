import '../_internal/constants.dart';
import '../_internal/utils.dart';

/// 인자로 받은 문자가 중성으로 위치할 수 있는 문자인지 검사합니다.
///
/// [character] 대상 문자
///
/// ```dart
/// canBeJungseong('ㅏ'); // true
/// canBeJungseong('ㅗㅏ'); // true
/// canBeJungseong('ㅘ'); // true
/// canBeJungseong('ㅏㅗ'); // false
/// canBeJungseong('ㄱ'); // false
/// canBeJungseong('ㄱㅅ'); // false
/// canBeJungseong('가'); // false
/// ```
bool canBeJungseong(String character) {
  if (character.isEmpty) {
    return false;
  }

  // 단일 이중모음 문자인 경우 (ㅘ, ㅝ 등)
  if (disassembledVowelsByVowel.containsKey(character)) {
    return true;
  }

  // 분해된 이중모음 문자인 경우 (ㅗㅏ, ㅜㅓ 등)
  return hasValueInReadOnlyStringList(jungseongs, character);
}
