import '../_internal/constants.dart';
import 'disassemble_complete_character.dart';

List<String> _splitChars(String s) => s.isEmpty ? const [] : s.split('');

/// 한 글자를 자소 배열로 분해
List<String> _disassembleLetter(String letter) {
  // 완성형 한글 (가~힣)
  final disassembledComplete = disassembleCompleteCharacter(letter);
  if (disassembledComplete != null) {
    return [
      ..._splitChars(disassembledComplete.choseong),
      ..._splitChars(disassembledComplete.jungseong),
      ..._splitChars(disassembledComplete.jongseong),
    ];
  }

  // 자음 (ㄱ, ㄳ 등)
  if (disassembledConsonantsByConsonant.containsKey(letter)) {
    return _splitChars(disassembledConsonantsByConsonant[letter]!);
  }

  // 모음 (ㅏ, ㅘ 등)
  if (disassembledVowelsByVowel.containsKey(letter)) {
    return _splitChars(disassembledVowelsByVowel[letter]!);
  }

  // 기타 문자 (공백, 숫자, 특수문자 등)
  return [letter];
}

/// 한글 문자열을 글자 단위로 나눈 뒤, 각 글자를 자모 배열로 분해하여 반환합니다.
///
/// 이중모음·겹받침은 낱자로 분해되며(`ㅘ` → `ㅗ`, `ㅏ`), 한글이 아닌 문자는
/// 한 글자짜리 그룹으로 그대로 유지됩니다.
///
/// ```dart
/// disassembleToGroups('사과'); // [['ㅅ', 'ㅏ'], ['ㄱ', 'ㅗ', 'ㅏ']]
/// disassembleToGroups('값'); // [['ㄱ', 'ㅏ', 'ㅂ', 'ㅅ']]
/// disassembleToGroups('ㅘ'); // [['ㅗ', 'ㅏ']]
/// ```
List<List<String>> disassembleToGroups(String str) {
  return str.runes.map(String.fromCharCode).map(_disassembleLetter).toList();
}
