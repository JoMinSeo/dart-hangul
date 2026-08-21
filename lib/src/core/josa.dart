import '../_internal/constants.dart' show alphabetToKorean;
import 'disassemble_complete_character.dart';
import 'has_batchim.dart';

/// 조사 쌍. 이름 규칙: 앞 형태 로마자 + 뒤 형태 로마자(첫 글자 대문자) — `eulReul` = 을/를
enum JosaOption {
  /// 이/가
  iGa('이', '가'),

  /// 을/를
  eulReul('을', '를'),

  /// 은/는
  eunNeun('은', '는'),

  /// 으로/로
  euroRo('으로', '로'),

  /// 와/과
  waGwa('와', '과'),

  /// 이나/나
  inaNa('이나', '나'),

  /// 이란/란
  iranRan('이란', '란'),

  /// 아/야
  aYa('아', '야'),

  /// 이랑/랑
  irangRang('이랑', '랑'),

  /// 이에요/예요
  ieyoYeyo('이에요', '예요'),

  /// 으로서/로서
  euroseoRoseo('으로서', '로서'),

  /// 으로써/로써
  eurosseoRosseo('으로써', '로써'),

  /// 으로부터/로부터
  eurobuteoRobuteo('으로부터', '로부터'),

  /// 이라/라
  iraRa('이라', '라');

  /// 받침 있는 단어에 붙는 형태 (이, 을, 은, 으로 ...)
  final String first;

  /// 받침 없는 단어에 붙는 형태 (가, 를, 는, 로 ...)
  final String second;

  const JosaOption(this.first, this.second);

  @override
  String toString() => '$first/$second';
}

/// '으로/로' 계열 조사
final Set<JosaOption> _roJosa = {
  JosaOption.euroRo,
  JosaOption.euroseoRoseo,
  JosaOption.eurosseoRosseo,
  JosaOption.eurobuteoRobuteo,
};

/// 인자로 받은 단어에 조사를 붙입니다.
///
/// ```dart
/// josa('사과', JosaOption.waGwa); // 사과와
/// josa('집', JosaOption.waGwa); // 집과
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
  final isJongseongRieul = hasBatchimValue && disassembleCompleteCharacter(lastChar)?.jongseong == 'ㄹ';

  // '으로/로' 계열 + 종성 ㄹ 예외 처리
  final isCaseOfRo = hasBatchimValue && isJongseongRieul && _roJosa.contains(josaOption);

  if (josaOption == JosaOption.waGwa || isCaseOfRo) {
    index = index == 0 ? 1 : 0;
  }

  return index == 0 ? josaOption.first : josaOption.second;
}
