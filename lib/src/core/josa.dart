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

  static final Map<String, JosaOption> _byLabel = {for (final option in values) option.toString(): option};

  /// `'을/를'` 형식의 문자열을 [JosaOption]으로 변환합니다. 유효한 조사 쌍이 아니면 `null`을 반환합니다.
  ///
  /// 사용자 입력·설정값처럼 런타임에 문자열로 들어오는 조사 쌍을 검증하는 진입점입니다.
  /// (es-hangul 은 런타임 검증 없이 잘못된 쌍도 그대로 사용한다 — 의도적 차이)
  ///
  /// ```dart
  /// JosaOption.tryParse('을/를'); // JosaOption.eulReul
  /// JosaOption.tryParse('이/을'); // null
  /// ```
  static JosaOption? tryParse(String input) => _byLabel[input];

  /// `'을/를'` 형식의 문자열을 [JosaOption]으로 변환합니다. 유효한 조사 쌍이 아니면 [ArgumentError]를 던집니다.
  static JosaOption parse(String input) =>
      tryParse(input) ?? (throw ArgumentError.value(input, 'input', '유효한 조사 쌍이 아닙니다. 유효한 값: ${values.join(', ')}'));

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

final _upperAlphabetOnly = RegExp(r'^[A-Z]+$');

/// 인자로 받은 단어에 조사를 붙입니다.
///
/// ```dart
/// josa('사과', JosaOption.waGwa); // 사과와
/// josa('집', JosaOption.waGwa); // 집과
/// josa('URL', JosaOption.iGa); // URL이
/// ```
String josa(String word, JosaOption josaOption) {
  if (word.isEmpty) return word;

  // 대문자 영어 약어(URL, CSS)는 마지막 알파벳의 한글 발음으로 받침을 판정한다
  if (_upperAlphabetOnly.hasMatch(word)) {
    final lastChar = word.substring(word.length - 1);
    return '$word${josaPick(alphabetToKorean[lastChar] ?? lastChar, josaOption)}';
  }

  return '$word${josaPick(word, josaOption)}';
}

/// 조사를 선택만 해서 반환합니다.
///
/// ```dart
/// josaPick('사과', JosaOption.eulReul); // 를
/// josaPick('책', JosaOption.eulReul); // 을
/// ```
String josaPick(String word, JosaOption josaOption) {
  if (word.isEmpty) return josaOption.first;

  final hasBatchimValue = hasBatchim(word);
  // '으로/로' 계열은 종성이 ㄹ이면 받침이 있어도 '로' (지름길로)
  final isJongseongRieul =
      hasBatchimValue && disassembleCompleteCharacter(word.substring(word.length - 1))?.jongseong == 'ㄹ';
  // 와/과는 다른 조사와 반대로 받침 없으면 앞 형태(와), 있으면 뒤 형태(과)
  final flip = josaOption == JosaOption.waGwa || (isJongseongRieul && _roJosa.contains(josaOption));
  final useFirst = flip ? !hasBatchimValue : hasBatchimValue;

  return useFirst ? josaOption.first : josaOption.second;
}
