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

List<List<String>> disassembleToGroups(String str) {
  return str.runes.map(String.fromCharCode).map(_disassembleLetter).toList();
}
