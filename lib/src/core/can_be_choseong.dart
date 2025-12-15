import '../_internal/constants.dart';
import '../_internal/utils.dart';

/// 인자로 받은 문자가 초성으로 위치할 수 있는 문자인지 검사합니다.
///
/// [character] 대상 문자
///
/// ```dart
/// canBeChoseong('ㄱ'); // true
/// canBeChoseong('ㅃ'); // true
/// canBeChoseong('ㄱㅅ'); // false
/// canBeChoseong('ㅏ'); // false
/// canBeChoseong('가'); // false
/// ```
bool canBeChoseong(String character) {
  return hasValueInReadOnlyStringList(choseongs, character);
}
