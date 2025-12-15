import '../_internal/constants.dart';
import '../_internal/utils.dart';

/// 인자로 받은 문자가 종성으로 위치할 수 있는 문자인지 검사합니다.
///
/// [character] 대상 문자
///
/// ```dart
/// canBeJongseong('ㄱ'); // true
/// canBeJongseong('ㄱㅅ'); // true
/// canBeJongseong('ㅎㄹ'); // false
/// canBeJongseong('가'); // false
/// canBeJongseong('ㅏ'); // false
/// canBeJongseong('ㅗㅏ'); // false
/// ```
bool canBeJongseong(String character) {
  return hasValueInReadOnlyStringList(jongseongs, character);
}
