import 'package:dart_hangul/src/types/jungseong.dart';

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
  return Jungseong.tryParse(character) != null;
}
