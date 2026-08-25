import '../_internal/constants.dart';
import '../_internal/utils.dart';

/// 숫자를 한자어 한글 표기로 변환합니다.
///
/// [input] 변환할 숫자 (정수·소수·음수·무한대 지원)
/// [spacing] `true`이면 만 단위마다 공백을 넣습니다.
///
/// ```dart
/// numberToHangul(12345); // '일만이천삼백사십오'
/// numberToHangul(12345, spacing: true); // '일만 이천삼백사십오'
/// numberToHangul(-0.1); // '마이너스영점일'
/// numberToHangul(double.infinity); // '무한대'
/// ```
///
/// NaN 이면 [ArgumentError] 를 던집니다.
String numberToHangul(num input, {bool spacing = false}) {
  if (input.isNaN) throw ArgumentError.value(input, 'input', '유효한 숫자를 입력해주세요.');
  if (input == double.infinity) return '무한대';
  if (input == double.negativeInfinity) return spacing ? '마이너스 무한대' : '마이너스무한대';
  if (input == 0) return '영';

  final isNegative = input < 0;
  final (:integer, :decimal) = splitNumberString(input.abs());

  final koreanParts = <String>[];
  var remainingDigits = integer;
  var placeIndex = 0;

  while (remainingDigits.isNotEmpty) {
    final cut = remainingDigits.length > 4 ? remainingDigits.length - 4 : 0;
    final koreanNumber = _numberToKoreanUpToThousand(int.parse(remainingDigits.substring(cut)));
    if (koreanNumber.isNotEmpty) koreanParts.insert(0, '$koreanNumber${hangulDigits[placeIndex]}');

    remainingDigits = remainingDigits.substring(0, cut);
    placeIndex++;
  }

  var result = integer == '0' ? '영' : koreanParts.join(spacing ? ' ' : '');

  if (decimal != null) {
    final decimalKorean = decimal.split('').map((d) => _hangulNumbersForDecimal[int.parse(d)]).join();
    result += spacing ? '점 $decimalKorean' : '점$decimalKorean';
  }

  if (isNegative) result = spacing ? '마이너스 $result' : '마이너스$result';

  return result;
}

/// 0 ~ 9999 를 한자어로 변환. 맨 앞 '일'은 생략한다 (일천 → 천, 일백 → 백, 일십 → 십).
String _numberToKoreanUpToThousand(int number) {
  final digits = number.toString().split('').reversed.toList(); // digits[i] = 10^i 자리
  final korean =
      [
        for (var i = digits.length - 1; i >= 0; i--)
          if (digits[i] != '0') '${_hangulNumbers[int.parse(digits[i])]}${_hangulCardinal[i]}',
      ].join();

  return korean.replaceFirst('일천', '천').replaceFirst('일백', '백').replaceFirst('일십', '십');
}

/// 한자어 숫자 (0은 빈 문자열 — 정수부에서 0은 읽지 않음)
const List<String> _hangulNumbers = ['', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];

/// 소수부용 한자어 숫자 (0을 '영'으로 읽음)
const List<String> _hangulNumbersForDecimal = ['영', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];

/// 천 이하 자릿수 이름 — 인덱스 = 10의 거듭제곱
const List<String> _hangulCardinal = ['', '십', '백', '천'];
