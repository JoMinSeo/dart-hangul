import '../core/can_be_choseong.dart';
import '../core/can_be_jongseong.dart';
import '../core/can_be_jungseong.dart';
import '../core/combine_character.dart';
import '../core/combine_vowels.dart';
import '../core/disassemble_to_groups.dart';
import '../core/has_batchim.dart';
import '../core/remove_last_character.dart';
import 'utils.dart';

final _completeHangulCharacter = RegExp(r'^[가-힣]$');
final _hangulAlphabet = RegExp(r'^[ㄱ-ㅣ]$');
final _blank = RegExp(r'^\s$');
final _hangulString = RegExp(r'^[가-힣ㄱ-ㅣ\s]+$');

/// 완성형 한글 한 글자(가~힣)인지
bool isHangulCharacter(String character) => _completeHangulCharacter.hasMatch(character);

/// 한글 자모 한 글자(ㄱ~ㅣ)인지
bool isHangulAlphabet(String character) => _hangulAlphabet.hasMatch(character);

bool isBlank(String character) => _blank.hasMatch(character);

/// 완성형 한글·자모·공백으로만 이루어진 문자열인지. String 이 아니면 false.
bool isHangul(Object? actual) => actual is String && _hangulString.hasMatch(actual);

/// 두 개의 한글 자모를 합칩니다. 완성된 한글 문자는 취급하지 않습니다.
///
/// ```dart
/// binaryAssembleAlphabets('ㄱ', 'ㅏ'); // 가
/// binaryAssembleAlphabets('ㅗ', 'ㅏ'); // ㅘ
/// ```
String binaryAssembleAlphabets(String source, String nextCharacter) {
  if (canBeJungseong('$source$nextCharacter')) {
    return combineVowels(source, nextCharacter);
  }

  final isConsonantSource = canBeJungseong(source) == false;
  if (isConsonantSource && canBeJungseong(nextCharacter)) {
    return combineCharacter(source, nextCharacter);
  }

  return '$source$nextCharacter';
}

/// 연음 법칙을 적용하여 두 개의 한글 문자를 연결합니다.
String linkHangulCharacters(String source, String nextCharacter) {
  final lastJamo = disassembleToGroups(source)[0].last;

  return '${removeLastCharacter(source)}${combineCharacter(lastJamo, nextCharacter)}';
}

/// 인자로 받은 한글 문자 2개를 합성합니다.
///
/// ```dart
/// binaryAssembleCharacters('ㄱ', 'ㅏ'); // 가
/// binaryAssembleCharacters('가', 'ㅇ'); // 강
/// binaryAssembleCharacters('갑', 'ㅅ'); // 값
/// binaryAssembleCharacters('깎', 'ㅏ'); // 까까
/// ```
String binaryAssembleCharacters(String source, String nextCharacter) {
  if (!isHangulCharacter(source) && !isHangulAlphabet(source)) {
    throw ArgumentError('Invalid source character: $source. Source must be one character.');
  }
  if (!isHangulAlphabet(nextCharacter)) {
    throw ArgumentError(
      'Invalid next character: $nextCharacter. Next character must be one of the choseong, jungseong, or jongseong.',
    );
  }

  final sourceJamos = disassembleToGroups(source)[0];

  if (sourceJamos.length == 1) {
    return binaryAssembleAlphabets(sourceJamos[0], nextCharacter);
  }

  final excluded = excludeLastElement(sourceJamos);
  final restJamos = excluded.rest;
  final lastJamo = excluded.last;
  final secondaryLastJamo = restJamos.last;
  final choseong = restJamos[0];

  final needLinking = canBeChoseong(lastJamo) && canBeJungseong(nextCharacter);
  if (needLinking) {
    return linkHangulCharacters(source, nextCharacter);
  }

  if (canBeJungseong('$lastJamo$nextCharacter')) {
    return combineCharacter(choseong, '$lastJamo$nextCharacter');
  }

  if (canBeJungseong('$secondaryLastJamo$lastJamo') && canBeJongseong(nextCharacter)) {
    return combineCharacter(choseong, '$secondaryLastJamo$lastJamo', nextCharacter);
  }

  if (canBeJungseong(lastJamo) && canBeJongseong(nextCharacter)) {
    return combineCharacter(choseong, lastJamo, nextCharacter);
  }

  // 홑받침 글자 + 자음 → 겹받침 (갑 + ㅅ → 값). 홑받침이면 restJamos = [초성, ...중성] 이 보장된다.
  if (hasBatchim(source, only: BatchimType.single) && canBeJongseong('$lastJamo$nextCharacter')) {
    return combineCharacter(choseong, restJamos.sublist(1).join(), '$lastJamo$nextCharacter');
  }

  return '$source$nextCharacter';
}

/// 인자로 받은 한글 문장과 한글 문자 하나를 합성합니다.
///
/// ```dart
/// binaryAssemble('저는 고양이를 좋아합닏', 'ㅏ'); // 저는 고양이를 좋아합니다
/// binaryAssemble('저는 고양이를 좋아합', 'ㅅ'); // 저는 고양이를 좋아핪
/// binaryAssemble('저는 고양이를 좋아하', 'ㅏ'); // 저는 고양이를 좋아하ㅏ
/// ```
String binaryAssemble(String source, String nextCharacter) {
  // ponytail: 호출마다 source 전체를 runes → List 로 복사한다. assemble 의 fold 와 합치면 O(n²) 이지만 입력이 문장 단위라
  // 충분하다. 긴 입력이 생기면 StringBuffer 기반 fold 로 바꾼다.
  final excluded = excludeLastElement(source.runes.map(String.fromCharCode).toList());
  final rest = excluded.rest;
  final lastCharacter = excluded.last;

  // 공백이거나 한글 자모로 조합할 수 없는 문자(숫자, 기호 등)는 조합하지 않고 그대로 이어 붙인다.
  final needJoinString =
      isBlank(lastCharacter) ||
      isBlank(nextCharacter) ||
      !(isHangulCharacter(lastCharacter) || isHangulAlphabet(lastCharacter)) ||
      !isHangulAlphabet(nextCharacter);

  return '${rest.join()}${needJoinString ? '$lastCharacter$nextCharacter' : binaryAssembleCharacters(lastCharacter, nextCharacter)}';
}
