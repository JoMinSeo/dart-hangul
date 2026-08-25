import '../_internal/constants.dart' show alphabetToKorean;
import 'disassemble_complete_character.dart';

/// 조사 쌍. 이름 규칙: 앞 형태 로마자 + 뒤 형태 로마자(첫 글자 대문자) — `eulReul` = 을/를
///
/// 어떤 형태를 붙일지는 [pick] 이 정한다 — 받침 유무, ㄹ 받침 예외([afterRieul])가 전부 여기 데이터로 있다.
enum Josa {
  /// 이/가
  iGa('이', '가'),

  /// 을/를
  eulReul('을', '를'),

  /// 은/는
  eunNeun('은', '는'),

  /// 으로/로 — ㄹ 받침 뒤에서는 '로' (지름길로)
  euroRo('으로', '로', afterRieul: '로'),

  /// 와/과 — 다른 조사와 반대로 받침 없으면 '와', 있으면 '과'. 표기는 관례대로 '와/과'
  waGwa('과', '와', label: '와/과'),

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
  euroseoRoseo('으로서', '로서', afterRieul: '로서'),

  /// 으로써/로써
  eurosseoRosseo('으로써', '로써', afterRieul: '로써'),

  /// 으로부터/로부터
  eurobuteoRobuteo('으로부터', '로부터', afterRieul: '로부터'),

  /// 이라/라
  iraRa('이라', '라');

  /// 받침 있는 단어 뒤 형태 (이, 을, 은, 과 …)
  final String afterBatchim;

  /// 받침 없는 단어 뒤 형태 (가, 를, 는, 와 …)
  final String afterVowel;

  /// ㄹ 받침 뒤 형태. `null` 이면 [afterBatchim] 과 같다 — '으로/로' 계열만 '로' (지름길로)
  final String? afterRieul;

  final String? _label;

  const Josa(this.afterBatchim, this.afterVowel, {this.afterRieul, String? label}) : _label = label;

  static final Map<String, Josa> _byLabel = {for (final option in values) option.toString(): option};

  /// `'을/를'` 형식의 문자열을 [Josa]로 변환합니다. 유효한 조사 쌍이 아니면 `null`을 반환합니다.
  ///
  /// 사용자 입력·설정값처럼 런타임에 문자열로 들어오는 조사 쌍을 검증하는 진입점입니다.
  /// (es-hangul 은 런타임 검증 없이 잘못된 쌍도 그대로 사용한다 — 의도적 차이)
  ///
  /// ```dart
  /// Josa.tryParse('을/를'); // Josa.eulReul
  /// Josa.tryParse('이/을'); // null
  /// ```
  static Josa? tryParse(String input) => _byLabel[input];

  /// `'을/를'` 형식의 문자열을 [Josa]로 변환합니다. 유효한 조사 쌍이 아니면 [ArgumentError]를 던집니다.
  static Josa parse(String input) =>
      tryParse(input) ?? (throw ArgumentError.value(input, 'input', '유효한 조사 쌍이 아닙니다. 유효한 값: ${values.join(', ')}'));

  /// [word] 뒤에 붙을 형태를 고릅니다. 마지막 글자가 완성형 한글이 아니면 받침 없음으로 봅니다.
  ///
  /// ```dart
  /// Josa.eulReul.pick('사과'); // '를'
  /// Josa.eulReul.pick('책'); // '을'
  /// Josa.euroRo.pick('지름길'); // '로' (ㄹ 받침 예외)
  /// ```
  String pick(String word) {
    // es-hangul 과 동일: 빈 단어면 표기('을/를')의 앞 형태
    if (word.isEmpty) return toString().split('/').first;

    final last = disassembleCompleteCharacter(String.fromCharCode(word.runes.last));
    if (last == null || last.jongseong.isEmpty) return afterVowel;
    if (last.jongseong == 'ㄹ') return afterRieul ?? afterBatchim;

    return afterBatchim;
  }

  /// `'을/를'` 형식
  @override
  String toString() => _label ?? '$afterBatchim/$afterVowel';
}

final _upperAlphabetOnly = RegExp(r'^[A-Z]+$');

/// 인자로 받은 단어에 조사를 붙입니다.
///
/// ```dart
/// josa('사과', Josa.waGwa); // 사과와
/// josa('집', Josa.waGwa); // 집과
/// josa('URL', Josa.iGa); // URL이
/// ```
String josa(String word, Josa josa) {
  if (word.isEmpty) return word;

  // 대문자 영어 약어(URL, CSS)는 마지막 알파벳의 한글 발음으로 받침을 판정한다
  if (_upperAlphabetOnly.hasMatch(word)) {
    return '$word${josa.pick(alphabetToKorean[word[word.length - 1]]!)}';
  }

  return '$word${josa.pick(word)}';
}

/// 조사를 선택만 해서 반환합니다. [Josa.pick] 과 같습니다.
///
/// ```dart
/// josaPick('사과', Josa.eulReul); // 를
/// josaPick('책', Josa.eulReul); // 을
/// ```
String josaPick(String word, Josa josa) => josa.pick(word);
