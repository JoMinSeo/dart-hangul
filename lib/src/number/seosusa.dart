import 'number_to_hangul.dart';

/// 숫자를 한글 서수사로 변환합니다.
///
/// - 1 ~ 99: 순우리말 서수사 ('첫째', '둘째', '열두째', '스무째' ...)
/// - 100 이상: 한자어 서수사 ('백째', '백일째' ...)
///
/// ```dart
/// seosusa(1); // '첫째'
/// seosusa(3); // '셋째'
/// seosusa(12); // '열두째'
/// seosusa(20); // '스무째'
/// seosusa(100); // '백째'
/// ```
///
/// 1 미만이면 [RangeError] 를 던집니다.
String seosusa(int number) {
  if (number < 1) throw RangeError.range(number, 1, null, 'number', '유효하지 않은 입력입니다. 1이상의 정수만 지원합니다.');

  if (number <= 99) return '${_ordinalWord(number)}째';

  return '${numberToHangul(number)}째';
}

String _ordinalWord(int number) {
  final special = _seosusaSpecialCaseMap[number];
  if (special != null) return special;

  final tens = number ~/ 10 * 10;
  final ones = number % 10;

  return '${_seosusaMap[tens] ?? ''}${_seosusaMap[ones] ?? ''}';
}

const Map<int, String> _seosusaMap = {
  1: '한',
  2: '두',
  3: '셋',
  4: '넷',
  5: '다섯',
  6: '여섯',
  7: '일곱',
  8: '여덟',
  9: '아홉',
  10: '열',
  20: '스물',
  30: '서른',
  40: '마흔',
  50: '쉰',
  60: '예순',
  70: '일흔',
  80: '여든',
  90: '아흔',
  100: '백',
};

/// 1, 2, 20 은 단독일 때 형태가 다르다 (첫째, 둘째, 스무째). 십 단위 이상에 붙으면 '한', '두', '스물' (표준어 사정 원칙 제6항)
const Map<int, String> _seosusaSpecialCaseMap = {1: '첫', 2: '둘', 20: '스무'};
