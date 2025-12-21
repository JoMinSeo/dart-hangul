import 'package:dart_hangul/src/_internal/hangul.dart';

import '../core/disassemble.dart';

/// 인자로 받은 배열에 담긴 한글 문장과 문자를 한글 규칙에 맞게 합성합니다.
///
/// ```dart
/// assemble(['아버지가', ' ', '방ㅇ', 'ㅔ ', '들ㅇ', 'ㅓ갑니다']); // 아버지가 방에 들어갑니다
/// assemble(['아버지가', ' ', '방에 ', '들어갑니다']); // 아버지가 방에 들어갑니다
/// assemble(['ㅇ', 'ㅏ', 'ㅂ', 'ㅓ', 'ㅈ', 'ㅣ']); // 아버지
/// ```
String assemble(List<String> fragments) {
  final disassembled = disassemble(fragments.join('')).split('');

  if (disassembled.isEmpty) return '';

  return disassembled.skip(1).fold(disassembled.first, binaryAssemble);
}
