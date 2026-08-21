import 'dart:convert' show jsonEncode;

import '../core/can_be_choseong.dart';
import '../core/can_be_jongseong.dart';
import '../core/can_be_jungseong.dart';
import '../core/combine_character.dart';
import '../core/combine_vowels.dart';
import '../core/disassemble_to_groups.dart';
import '../core/has_batchim.dart';
import '../core/remove_last_character.dart';
import '../types/either.dart';
import 'utils.dart';

bool isHangulCharacter(String character) => RegExp(r'^[가-힣]$').hasMatch(character);

bool isHangulAlphabet(String character) => RegExp(r'^[ㄱ-ㅣ]$').hasMatch(character);

bool isBlank(String character) => RegExp(r'^\s$').hasMatch(character);

bool isHangul(Object? actual) {
  return actual is String && RegExp(r'^[가-힣ㄱ-ㅣ\s]+$').hasMatch(actual);
}

String _jsonStringify(Object? value) {
  try {
    return jsonEncode(value);
  } catch (_) {
    return '$value';
  }
}

void assertHangul(Object? actual, {String? message}) {
  if (!isHangul(actual)) {
    throw ArgumentError.value(actual, 'actual', message ?? '${_jsonStringify(actual)} is not a valid hangul string');
  }
}

String parseHangul(Object? actual, {String? message}) {
  assertHangul(actual, message: message);
  return actual as String;
}

/// 한글 파싱 에러 정보
class ParseHangulError {
  final Object error;
  final StackTrace stackTrace;

  const ParseHangulError(this.error, this.stackTrace);

  @override
  String toString() => 'ParseHangulError: $error';

  @override
  bool operator ==(Object other) => identical(this, other) || other is ParseHangulError && error == other.error;

  @override
  int get hashCode => error.hashCode;
}

/// 한글 파싱 결과 타입 (Either 기반)
typedef ParseHangulResult = Either<ParseHangulError, String>;

/// 안전한 한글 파싱 (Either 반환)
///
/// ```dart
/// safeParseHangul('안녕')
///   .map((s) => disassemble(s))
///   .fold(
///     (error) => 'Error: $error',
///     (result) => result,
///   );
/// ```
ParseHangulResult safeParseHangul(Object? actual, {String? message}) {
  try {
    final parsedHangul = parseHangul(actual, message: message);
    return Right(parsedHangul);
  } catch (e, st) {
    return Left(ParseHangulError(e, st));
  }
}

// 하위 호환성을 위한 레거시 타입 (deprecated)
@Deprecated('Use ParseHangulResult (Either<ParseHangulError, String>) instead')
typedef SafeParseHangulResult = ParseHangulResult;

@Deprecated('Use Right(data) instead')
typedef SafeParseHangulSuccess = Right<ParseHangulError, String>;

@Deprecated('Use Left(ParseHangulError(error, stackTrace)) instead')
typedef SafeParseHangulError = Left<ParseHangulError, String>;

/// 두 개의 한글 자모를 합칩니다. 완성된 한글 문자는 취급하지 않습니다.
///
/// ```dart
/// binaryAssembleAlphabets('ㄱ', 'ㅏ'); // 가
/// binaryAssembleAlphabets('ㅗ', 'ㅏ'); // ㅘ
/// ```
String binaryAssembleAlphabets(String source, String nextCharacter) {
  if (canBeJungseong('$source$nextCharacter')) {
    return combineVowels(source, nextCharacter);
  }

  final isConsonantSource = canBeJungseong(source) == false;
  if (isConsonantSource && canBeJungseong(nextCharacter)) {
    return combineCharacter(source, nextCharacter);
  }

  return '$source$nextCharacter';
}

/// 연음 법칙을 적용하여 두 개의 한글 문자를 연결합니다.
String linkHangulCharacters(String source, String nextCharacter) {
  final sourceJamo = disassembleToGroups(source)[0];
  final lastJamo = excludeLastElement(sourceJamo).last;

  return '${removeLastCharacter(source)}${combineCharacter(lastJamo, nextCharacter)}';
}

/// 인자로 받은 한글 문자 2개를 합성합니다.
///
/// ```dart
/// binaryAssembleCharacters('ㄱ', 'ㅏ'); // 가
/// binaryAssembleCharacters('가', 'ㅇ'); // 강
/// binaryAssembleCharacters('갑', 'ㅅ'); // 값
/// binaryAssembleCharacters('깎', 'ㅏ'); // 까까
/// ```
String binaryAssembleCharacters(String source, String nextCharacter) {
  if (!isHangulCharacter(source) && !isHangulAlphabet(source)) {
    throw ArgumentError('Invalid source character: $source. Source must be one character.');
  }
  if (!isHangulAlphabet(nextCharacter)) {
    throw ArgumentError(
      'Invalid next character: $nextCharacter. Next character must be one of the choseong, jungseong, or jongseong.',
    );
  }

  final sourceJamos = disassembleToGroups(source)[0];

  if (sourceJamos.length == 1) {
    return binaryAssembleAlphabets(sourceJamos[0], nextCharacter);
  }

  final excluded = excludeLastElement(sourceJamos);
  final restJamos = excluded.rest;
  final lastJamo = excluded.last;
  final secondaryLastJamo = excludeLastElement(restJamos).last;

  final needLinking = canBeChoseong(lastJamo) && canBeJungseong(nextCharacter);
  if (needLinking) {
    return linkHangulCharacters(source, nextCharacter);
  }

  final combineJungseong = curriedCombineCharacter(restJamos[0]);

  if (canBeJungseong('$lastJamo$nextCharacter')) {
    return combineJungseong('$lastJamo$nextCharacter')();
  }

  if (canBeJungseong('$secondaryLastJamo$lastJamo') && canBeJongseong(nextCharacter)) {
    return combineJungseong('$secondaryLastJamo$lastJamo')(nextCharacter);
  }

  if (canBeJungseong(lastJamo) && canBeJongseong(nextCharacter)) {
    return combineJungseong(lastJamo)(nextCharacter);
  }

  // 인덱싱 안전 가드
  if (restJamos.length < 2) {
    return '$source$nextCharacter';
  }

  final baseJungseong =
      (restJamos.length >= 3 && canBeJungseong('${restJamos[1]}${restJamos[2]}'))
          ? '${restJamos[1]}${restJamos[2]}'
          : restJamos[1];

  final lastConsonant = lastJamo;

  if (hasBatchim(source, only: BatchimType.single) && canBeJongseong('$lastConsonant$nextCharacter')) {
    return combineJungseong(baseJungseong)('$lastConsonant$nextCharacter');
  }

  return '$source$nextCharacter';
}

/// 인자로 받은 한글 문장과 한글 문자 하나를 합성합니다.
///
/// ```dart
/// binaryAssemble('저는 고양이를 좋아합닏', 'ㅏ'); // 저는 고양이를 좋아합니다
/// binaryAssemble('저는 고양이를 좋아합', 'ㅅ'); // 저는 고양이를 좋아핪
/// binaryAssemble('저는 고양이를 좋아하', 'ㅏ'); // 저는 고양이를 좋아하ㅏ
/// ```
String binaryAssemble(String source, String nextCharacter) {
  final excluded = excludeLastElement(source.runes.map(String.fromCharCode).toList());
  final rest = excluded.rest;
  final lastCharacter = excluded.last;

  final needJoinString = isBlank(lastCharacter) || isBlank(nextCharacter);

  return '${rest.join()}${needJoinString ? '$lastCharacter$nextCharacter' : binaryAssembleCharacters(lastCharacter, nextCharacter)}';
}

typedef CombineCharacterWithJongseong = String Function([String jongseong]);
typedef CombineCharacterWithJungseong = CombineCharacterWithJongseong Function(String jungseong);

/// 인자로 초성, 중성, 종성을 받아 하나의 한글 문자를 반환하는 `combineCharacter` 함수의 커링된 버전입니다.
///
/// ```dart
/// final combineMiddleHangulCharacter = curriedCombineCharacter('ㄱ');
/// final combineLastHangulCharacter = combineMiddleHangulCharacter('ㅏ');
/// combineLastHangulCharacter('ㄱ'); // '각'
/// ```
CombineCharacterWithJungseong curriedCombineCharacter(String choseong) {
  return (String jungseong) {
    return ([String jongseong = '']) => combineCharacter(choseong, jungseong, jongseong);
  };
}
