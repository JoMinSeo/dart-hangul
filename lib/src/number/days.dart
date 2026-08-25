/// 숫자를 순우리말 날짜 표현으로 변환합니다. 1 이상 30 이하의 정수만 지원합니다.
///
/// ```dart
/// days(1); // '하루'
/// days(10); // '열흘'
/// days(11); // '열하루'
/// days(20); // '스무날'
/// days(21); // '스무하루'
/// days(30); // '서른날'
/// ```
///
/// 범위 밖이면 [RangeError] 를 던집니다.
String days(int number) {
  if (number < 1 || number > 30) throw RangeError.range(number, 1, 30, 'number', '지원하지 않는 숫자입니다.');

  final tens = number ~/ 10 * 10;
  final ones = number % 10;

  if (ones == 0) return _daysOnlyTensMap[tens]!;

  return '${_daysMap[tens] ?? ''}${_daysMap[ones]!}';
}

const Map<int, String> _daysMap = {
  1: '하루',
  2: '이틀',
  3: '사흘',
  4: '나흘',
  5: '닷새',
  6: '엿새',
  7: '이레',
  8: '여드레',
  9: '아흐레',
  10: '열',
  20: '스무',
};

/// 십 단위 단독일 때의 표현
const Map<int, String> _daysOnlyTensMap = {10: '열흘', 20: '스무날', 30: '서른날'};
