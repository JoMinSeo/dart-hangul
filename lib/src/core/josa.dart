import 'package:dart_hangul/src/_internal/constants.dart' show alphabetToKorean;
import 'package:dart_hangul/src/core/disassemble_complete_character.dart';
import 'package:dart_hangul/src/core/has_batchim.dart';

enum JosaOption {
  /// 이/가
  iga('이', '가'),

  /// 을/를
  eulreul('을', '를'),

  /// 은/는
  eunneun('은', '는'),

  /// 으로/로
  eurolo('으로', '로'),

  /// 와/과
  wagwa('와', '과'),

  /// 이나/나
  inana('이나', '나'),

  /// 이란/란
  iranran('이란', '란'),

  /// 아/야
  aya('아', '야'),

  /// 이랑/랑
  irangrang('이랑', '랑'),

  /// 이에요/예요
  iyeyo('이에요', '예요'),

  /// 으로서/로서
  euroseoro('으로서', '로서'),

  /// 으로써/로써
  eurosseorosseo('으로써', '로써'),

  /// 으로부터/로부터
  eurobuteoro('으로부터', '로부터'),

  /// 이라/라
  irara('이라', '라');

  final String first;
  final String second;

  const JosaOption(this.first, this.second);
}

/// '으로/로' 계열 조사
final Set<JosaOption> _roJosa = {
  JosaOption.eurolo,
  JosaOption.euroseoro,
  JosaOption.eurosseorosseo,
  JosaOption.eurobuteoro,
};

/// 인자로 받은 단어에 조사를 붙입니다.
///
/// ```dart
/// josa('사과', JosaOption.wagwa); // 사과와
/// josa('집', JosaOption.wagwa); // 집과
/// ```
String josa(String word, JosaOption josaOption) {
  if (word.isEmpty) return word;

  final isUpperAlphabetOnly = RegExp(r'^[A-Z]+$').hasMatch(word);

  if (isUpperAlphabetOnly) {
    final lastChar = word.substring(word.length - 1);
    final koreanPronunciationOfLastChar = alphabetToKorean[lastChar] ?? lastChar;
    return '$word${josaPick(koreanPronunciationOfLastChar, josaOption)}';
  }

  return '$word${josaPick(word, josaOption)}';
}

/// 조사를 선택만 해서 반환합니다.
String josaPick(String word, JosaOption josaOption) {
  if (word.isEmpty) return josaOption.first;

  final hasBatchimValue = hasBatchim(word);
  var index = hasBatchimValue ? 0 : 1;

  final lastChar = word.substring(word.length - 1);

  // 종성이 'ㄹ'인지 확인
  final isJongseongRieul = hasBatchimValue && disassembleCompleteCharacter(lastChar)?.jongseong.value == 'ㄹ';

  // '으로/로' 계열 + 종성 ㄹ 예외 처리
  final isCaseOfRo = hasBatchimValue && isJongseongRieul && _roJosa.contains(josaOption);

  if (josaOption == JosaOption.wagwa || isCaseOfRo) {
    index = index == 0 ? 1 : 0;
  }

  return index == 0 ? josaOption.first : josaOption.second;
}
