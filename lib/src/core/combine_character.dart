import '../_internal/constants.dart';
import 'can_be_choseong.dart';
import 'can_be_jongseong.dart';
import 'can_be_jungseong.dart';

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
  if (!canBeChoseong(choseong) || !canBeJungseong(jungseong) || !canBeJongseong(jongseong)) {
    throw ArgumentError.value('$choseong, $jungseong, $jongseong', 'hangulCharacters', 'Invalid hangul characters');
  }

  final numOfJungseongs = jungseongs.length;
  final numOfJongseongs = jongseongs.length;

  final choseongIndex = choseongs.indexOf(choseong);
  final jungseongIndex = jungseongs.indexOf(jungseong);
  final jongseongIndex = jongseongs.indexOf(jongseong);

  if (choseongIndex < 0 || jungseongIndex < 0 || jongseongIndex < 0) {
    throw ArgumentError.value('$choseong, $jungseong, $jongseong', 'hangulCharacters', 'Invalid hangul characters');
  }

  final choseongOfTargetConsonant = choseongIndex * numOfJungseongs * numOfJongseongs;
  final choseongOfTargetVowel = jungseongIndex * numOfJongseongs;

  final unicode = completeHangulStartCharCode + choseongOfTargetConsonant + choseongOfTargetVowel + jongseongIndex;

  return String.fromCharCode(unicode);
}
