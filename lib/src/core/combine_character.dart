import '../_internal/constants.dart';
import '../types/choseong.dart';
import '../types/jongseong.dart';
import '../types/jungseong.dart';

/// 인자로 초성, 중성, 종성을 받아 하나의 완성형 한글 문자를 반환합니다.
///
/// - [choseong] 초성 (예: `ㄱ`)
/// - [jungseong] 중성(분해형) (예: `ㅏ`, `ㅗㅏ`)
/// - [jongseong] 종성(분해형) (예: `''`, `ㄱ`, `ㄱㅅ`)
///
/// ```dart
/// combineCharacter('ㄱ', 'ㅏ', 'ㅂㅅ'); // '값'
/// combineCharacter('ㅌ', 'ㅗ'); // '토'
/// ```
///
/// 유효하지 않은 조합이면 [ArgumentError]를 던집니다.
String combineCharacter(String choseong, String jungseong, [String jongseong = '']) {
  final choseongObj = Choseong.tryParse(choseong);
  final jungseongObj = Jungseong.tryParse(jungseong);
  final jongseongObj = Jongseong.tryParse(jongseong);

  if (choseongObj == null || jungseongObj == null || jongseongObj == null) {
    throw ArgumentError.value('$choseong, $jungseong, $jongseong', 'hangulCharacters', 'Invalid hangul characters');
  }

  final numOfJungseongs = jungseongs.length;
  final numOfJongseongs = jongseongs.length;

  final choseongIndex = choseongObj.index;
  final jungseongIndex = jungseongObj.index;
  final jongseongIndex = jongseongObj.index;

  final choseongOfTargetConsonant = choseongIndex * numOfJungseongs * numOfJongseongs;
  final choseongOfTargetVowel = jungseongIndex * numOfJongseongs;

  final unicode = completeHangulStartCharCode + choseongOfTargetConsonant + choseongOfTargetVowel + jongseongIndex;

  return String.fromCharCode(unicode);
}
