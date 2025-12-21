import '../_internal/constants.dart';
import 'disassemble_complete_character.dart';

List<String> _splitChars(String s) => s.isEmpty ? const [] : s.split('');

List<List<String>> disassembleToGroups(String str) {
  final result = <List<String>>[];

  for (final rune in str.runes) {
    final letter = String.fromCharCode(rune);
    final disassembledComplete = disassembleCompleteCharacter(letter);

    if (disassembledComplete != null) {
      result.add([
        ..._splitChars(disassembledComplete.choseong.value),
        ..._splitChars(disassembledComplete.jungseong.value),
        ..._splitChars(disassembledComplete.jongseong.value),
      ]);
      continue;
    }

    if (disassembledConsonantsByConsonant.containsKey(letter)) {
      final disassembledConsonant = disassembledConsonantsByConsonant[letter]!;

      result.add(_splitChars(disassembledConsonant));

      continue;
    }

    if (disassembledVowelsByVowel.containsKey(letter)) {
      final disassembledVowel = disassembledVowelsByVowel[letter]!;

      result.add(_splitChars(disassembledVowel));

      continue;
    }

    result.add([letter]);
  }

  return result;
}
