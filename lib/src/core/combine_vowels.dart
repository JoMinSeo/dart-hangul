import '../_internal/constants.dart';

/// 인자로 두 개의 모음을 받아 합성하여 겹모음을 생성합니다.
/// 합성할 수 없는 조합이면 단순히 문자열을 이어 붙입니다.
///
/// ```dart
/// combineVowels('ㅗ', 'ㅏ'); // 'ㅘ'
/// combineVowels('ㅗ', 'ㅐ'); // 'ㅙ'
/// combineVowels('ㅗ', 'ㅛ'); // 'ㅗㅛ'
/// ```
String combineVowels(String vowel1, String vowel2) {
  return _combinedVowelByDisassembled['$vowel1$vowel2'] ?? '$vowel1$vowel2';
}

/// 'ㅗㅏ' -> 'ㅘ' 형태로 역매핑
final Map<String, String> _combinedVowelByDisassembled = {
  for (final entry in disassembledVowelsByVowel.entries) entry.value: entry.key,
};
