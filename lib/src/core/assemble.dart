import '../_internal/utils.dart';
import 'can_be_choseong.dart';
import 'can_be_jongseong.dart';
import 'can_be_jungseong.dart';
import 'combine_character.dart';
import 'combine_vowels.dart';
import 'disassemble.dart';
import 'disassemble_to_groups.dart';
import 'has_batchim.dart';
import 'remove_last_character.dart';

/// 인자로 받은 배열에 담긴 한글 문장과 문자를 한글 규칙에 맞게 합성합니다.
///
/// ```dart
/// assemble(['아버지가', ' ', '방ㅇ', 'ㅔ ', '들ㅇ', 'ㅓ갑니다']); // 아버지가 방에 들어갑니다
/// assemble(['아버지가', ' ', '방에 ', '들어갑니다']); // 아버지가 방에 들어갑니다
/// assemble(['ㅇ', 'ㅏ', 'ㅂ', 'ㅓ', 'ㅈ', 'ㅣ']); // 아버지
/// ```
String assemble(Iterable<String> fragments) {
  final disassembled = disassemble(fragments.join('')).runes.map(String.fromCharCode).toList();

  if (disassembled.isEmpty) return '';

  return disassembled.skip(1).fold(disassembled.first, _binaryAssemble);
}

// ---- 조합 엔진: 문자열 하나 + 자모 하나를 왼쪽부터 접어 나간다 (assemble 전용)

final _completeHangulCharacter = RegExp(r'^[가-힣]$');
final _hangulAlphabet = RegExp(r'^[ㄱ-ㅣ]$');
final _blank = RegExp(r'^\s$');

/// 완성형 한글 한 글자(가~힣)인지
bool _isHangulCharacter(String character) => _completeHangulCharacter.hasMatch(character);

/// 한글 자모 한 글자(ㄱ~ㅣ)인지
bool _isHangulAlphabet(String character) => _hangulAlphabet.hasMatch(character);

bool _isBlank(String character) => _blank.hasMatch(character);

/// 두 개의 한글 자모를 합칩니다. 완성된 한글 문자는 취급하지 않습니다.
///
/// `('ㄱ', 'ㅏ')` → 가, `('ㅗ', 'ㅏ')` → ㅘ
String _binaryAssembleAlphabets(String source, String nextCharacter) {
  if (canBeJungseong('$source$nextCharacter')) {
    return combineVowels(source, nextCharacter);
  }

  final isConsonantSource = canBeJungseong(source) == false;
  if (isConsonantSource && canBeJungseong(nextCharacter)) {
    return combineCharacter(source, nextCharacter);
  }

  return '$source$nextCharacter';
}

/// 연음 법칙을 적용하여 두 개의 한글 문자를 연결합니다. `('톳', 'ㅡ')` → 토스
String _linkHangulCharacters(String source, String nextCharacter) {
  final lastJamo = disassembleToGroups(source)[0].last;

  return '${removeLastCharacter(source)}${combineCharacter(lastJamo, nextCharacter)}';
}

/// 한글 한 글자(완성형 또는 자모) [source] 와 자모 [nextCharacter] 를 합성합니다.
/// 호출 전 [_binaryAssemble] 이 두 인자가 그 조건을 만족함을 보장한다.
///
/// `('ㄱ', 'ㅏ')` → 가, `('가', 'ㅇ')` → 강, `('갑', 'ㅅ')` → 값, `('깎', 'ㅏ')` → 까까
String _binaryAssembleCharacters(String source, String nextCharacter) {
  final sourceJamos = disassembleToGroups(source)[0];

  if (sourceJamos.length == 1) {
    return _binaryAssembleAlphabets(sourceJamos[0], nextCharacter);
  }

  final excluded = excludeLastElement(sourceJamos);
  final restJamos = excluded.rest;
  final lastJamo = excluded.last;
  final secondaryLastJamo = restJamos.last;
  final choseong = restJamos[0];

  final needLinking = canBeChoseong(lastJamo) && canBeJungseong(nextCharacter);
  if (needLinking) {
    return _linkHangulCharacters(source, nextCharacter);
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

/// 한글 문장 [source] 뒤에 문자 하나 [nextCharacter] 를 합성합니다.
///
/// `('저는 고양이를 좋아합닏', 'ㅏ')` → 저는 고양이를 좋아합니다, `('저는 고양이를 좋아하', 'ㅏ')` → 저는 고양이를 좋아하ㅏ
String _binaryAssemble(String source, String nextCharacter) {
  // ponytail: 호출마다 source 전체를 runes → List 로 복사한다. assemble 의 fold 와 합치면 O(n²) 이지만 입력이 문장 단위라
  // 충분하다. 긴 입력이 생기면 StringBuffer 기반 fold 로 바꾼다.
  final excluded = excludeLastElement(source.runes.map(String.fromCharCode).toList());
  final rest = excluded.rest;
  final lastCharacter = excluded.last;

  // 공백이거나 한글 자모로 조합할 수 없는 문자(숫자, 기호 등)는 조합하지 않고 그대로 이어 붙인다.
  final needJoinString =
      _isBlank(lastCharacter) ||
      _isBlank(nextCharacter) ||
      !(_isHangulCharacter(lastCharacter) || _isHangulAlphabet(lastCharacter)) ||
      !_isHangulAlphabet(nextCharacter);

  return '${rest.join()}${needJoinString ? '$lastCharacter$nextCharacter' : _binaryAssembleCharacters(lastCharacter, nextCharacter)}';
}
