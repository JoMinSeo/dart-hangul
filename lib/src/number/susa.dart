/// 숫자를 순우리말 수사로 변환합니다. 1 이상 100 이하의 정수만 지원합니다.
///
/// [number] 변환할 숫자
/// [classifier] `true`이면 수관형사('한', '두', '세', '네', '스무' 등)로 변환합니다.
///
/// ```dart
/// susa(1); // '하나'
/// susa(11); // '열하나'
/// susa(21); // '스물하나'
/// susa(100); // '백'
/// susa(1, classifier: true); // '한'
/// susa(20, classifier: true); // '스무'
/// susa(21, classifier: true); // '스물한'
/// ```
///
/// 범위 밖이면 [RangeError] 를 던집니다.
String susa(int number, {bool classifier = false}) {
  if (number < 1 || number > 100) throw RangeError.range(number, 1, 100, 'number', '지원하지 않는 숫자입니다.');

  return classifier ? _classifierWord(number) : _numberWord(number);
}

String _numberWord(int number) {
  if (number == 100) return _susaMap[100]!;

  final tens = number ~/ 10 * 10;
  final ones = number % 10;

  return '${_susaMap[tens] ?? ''}${_susaMap[ones] ?? ''}';
}

String _classifierWord(int number) {
  if (number == 20) return _susaClassifierMap[20]!;

  final tens = number ~/ 10 * 10;
  final ones = number % 10;
  final tensWord = _susaMap[tens] ?? '';

  if (ones == 0) return tensWord;

  return '$tensWord${_susaClassifierMap[ones] ?? _susaMap[ones]!}';
}

const Map<int, String> _susaMap = {
  1: '하나',
  2: '둘',
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

const Map<int, String> _susaClassifierMap = {1: '한', 2: '두', 3: '세', 4: '네', 20: '스무'};
