import '../_internal/utils.dart';
import 'can_be_jungseong.dart';
import 'combine_character.dart';
import 'disassemble_to_groups.dart';

/// 인자로 주어진 한글 문자열에서 가장 마지막 문자 하나를 제거하여 반환합니다.
///
/// ```dart
/// removeLastCharacter('안녕하세요 값'); // 안녕하세요 갑
/// removeLastCharacter('프론트엔드'); // 프론트엔ㄷ
/// removeLastCharacter('일요일'); // 일요이
/// removeLastCharacter('전화'); // 전호
/// removeLastCharacter('신세계'); // 신세ㄱ
/// ```
String removeLastCharacter(String words) {
  final lastCharacter = words.split('').lastOrNull;
  if (lastCharacter == null) return '';

  String result;

  final disassembleLastCharacter = disassembleToGroups(lastCharacter);
  final lastCharacterWithoutLastAlphabet = excludeLastElement(disassembleLastCharacter[0]).rest;

  // 마지막 글자가 분해 불가능(예: 공백/기호)이라면 그냥 제거
  if (lastCharacterWithoutLastAlphabet.isEmpty) {
    return '';
  }

  if (lastCharacterWithoutLastAlphabet.length <= 3) {
    final first = lastCharacterWithoutLastAlphabet[0];
    final middle = lastCharacterWithoutLastAlphabet.length >= 2 ? lastCharacterWithoutLastAlphabet[1] : null;
    final last = lastCharacterWithoutLastAlphabet.length >= 3 ? lastCharacterWithoutLastAlphabet[2] : null;

    if (middle != null) {
      result =
          (last != null && canBeJungseong(last))
              ? combineCharacter(first, '$middle$last')
              : combineCharacter(first, middle, last ?? '');
    } else {
      result = first;
    }
  } else {
    // [초성, 중성1, 중성2, 종성] 형태
    final first = lastCharacterWithoutLastAlphabet[0];
    final firstJungseong = lastCharacterWithoutLastAlphabet[1];
    final secondJungseong = lastCharacterWithoutLastAlphabet[2];
    final firstJongseong = lastCharacterWithoutLastAlphabet[3];

    result = combineCharacter(first, '$firstJungseong$secondJungseong', firstJongseong);
  }

  return '${words.substring(0, words.length - 1)}$result';
}
