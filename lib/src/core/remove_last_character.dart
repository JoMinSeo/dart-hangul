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
  if (words.isEmpty) return '';

  // UTF-16 코드유닛이 아니라 코드포인트 단위로 마지막 글자를 잡는다 — 서로게이트 쌍(이모지 등)이 반쪽만 잘리지 않도록
  final lastCharacter = String.fromCharCode(words.runes.last);
  final head = words.substring(0, words.length - lastCharacter.length);

  final lastCharacterWithoutLastAlphabet = excludeLastElement(disassembleToGroups(lastCharacter)[0]).rest;

  // 마지막 글자가 분해 불가능(예: 공백/기호)이라면 그 글자만 제거
  if (lastCharacterWithoutLastAlphabet.isEmpty) return head;

  // 패턴 매칭으로 케이스 분리
  final result = switch (lastCharacterWithoutLastAlphabet) {
    // [초성] 형태
    [var first] => first,

    // [초성, 중성] 형태
    [var first, var middle] => combineCharacter(first, middle),

    // [초성, 중성, 종성] 형태
    [var first, var middle, var last] when canBeJungseong(last) => combineCharacter(first, '$middle$last'),

    [var first, var middle, var last] => combineCharacter(first, middle, last),

    // [초성, 중성1, 중성2, 종성] 형태
    [var first, var firstJungseong, var secondJungseong, var firstJongseong] => combineCharacter(
      first,
      '$firstJungseong$secondJungseong',
      firstJongseong,
    ),

    // 그 외 (이론적으로 도달 불가능하지만 안전장치)
    _ => lastCharacterWithoutLastAlphabet.join(),
  };

  return '$head$result';
}
