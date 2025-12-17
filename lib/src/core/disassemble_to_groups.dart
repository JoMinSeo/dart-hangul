import '../_internal/constants.dart';
import 'disassemble_complete_character.dart';

List<List<String>> disassembleToGroups(String str) {
  final result = <List<String>>[];

  for (final rune in str.runes) {
    final letter = String.fromCharCode(rune);
    final disassembledComplete = disassembleCompleteCharacter(letter);

    if (disassembledComplete != null) {
      result.add([
        ...disassembledComplete.choseong.value.split(''),
        ...disassembledComplete.jungseong.value.split(''),
        ...disassembledComplete.jongseong.value.split(''),
      ]);
      continue;
    }

    if (disassembledConsonantsByConsonant.containsKey(letter)) {
      final disassembledConsonant = disassembledConsonantsByConsonant[letter]!;

      result.add(disassembledConsonant.split(''));

      continue;
    }

    if (disassembledVowelsByVowel.containsKey(letter)) {
      final disassembledVowel = disassembledVowelsByVowel[letter]!;

      result.add(disassembledVowel.split(''));

      continue;
    }

    result.add([letter]);
  }

  return result;
}
