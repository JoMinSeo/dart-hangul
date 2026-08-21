import '../_internal/constants.dart';
import '../_internal/utils.dart';

/// 숫자를 아라비아 숫자 + 만 단위 한글 혼용 표기로 변환합니다.
///
/// [input] 변환할 숫자 (정수·소수·음수·무한대 지원)
/// [spacing] `true`이면 만 단위마다 공백을 넣습니다.
///
/// ```dart
/// numberToHangulMixed(12345); // '1만2,345'
/// numberToHangulMixed(12345, spacing: true); // '1만 2,345'
/// numberToHangulMixed(-12345.678); // '-1만2,345.678'
/// numberToHangulMixed(double.infinity); // '무한대'
/// ```
///
/// NaN 이면 [ArgumentError] 를 던집니다.
String numberToHangulMixed(num input, {bool spacing = false}) {
  if (input.isNaN) throw ArgumentError('유효한 숫자를 입력해주세요.');
  if (input == double.infinity) return '무한대';
  if (input == double.negativeInfinity) return '-무한대';
  if (input == 0) return '0';

  final isNegative = input < 0;
  final (:integer, :decimal) = splitNumberString(input.abs());

  final parts = <String>[];
  var remainingDigits = integer;
  var placeIndex = 0;

  while (remainingDigits.isNotEmpty) {
    final cut = remainingDigits.length > 4 ? remainingDigits.length - 4 : 0;
    final value = int.parse(remainingDigits.substring(cut));
    if (value > 0) parts.insert(0, '${_withComma(value)}${hangulDigits[placeIndex]}');

    remainingDigits = remainingDigits.substring(0, cut);
    placeIndex++;
  }

  var result = integer == '0' ? '0' : parts.join(spacing ? ' ' : '');
  if (decimal != null) result += '.$decimal';

  return isNegative ? '-$result' : result;
}

// ponytail: 4자리 묶음(≤ 9999)에만 쓰이므로 천 단위 콤마 하나면 충분. intl 의존 없이 처리.
String _withComma(int value) =>
    value >= 1000 ? '${value ~/ 1000},${(value % 1000).toString().padLeft(3, '0')}' : '$value';
