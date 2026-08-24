import 'disassemble_to_groups.dart';

/// 한글 문자열을 자모 단위로 분해하여 하나의 문자열로 반환합니다.
///
/// 이중모음·겹받침은 낱자로 분해되며(`ㅘ` → `ㅗㅏ`, `ㅄ` → `ㅂㅅ`),
/// 한글이 아닌 문자는 그대로 유지됩니다.
///
/// ```dart
/// disassemble('값'); // 'ㄱㅏㅂㅅ'
/// disassemble('값이 비싸다'); // 'ㄱㅏㅂㅅㅇㅣ ㅂㅣㅆㅏㄷㅏ'
/// disassemble('ㅘ'); // 'ㅗㅏ'
/// ```
String disassemble(String str) {
  return disassembleToGroups(str).map((group) => group.join('')).join('');
}
