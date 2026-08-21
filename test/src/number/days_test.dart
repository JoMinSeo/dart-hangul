import 'package:dart_hangul/src/number/days.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('days', () {
    const validNumbers = [
      (num: 1, word: '하루'),
      (num: 2, word: '이틀'),
      (num: 3, word: '사흘'),
      (num: 4, word: '나흘'),
      (num: 5, word: '닷새'),
      (num: 6, word: '엿새'),
      (num: 7, word: '이레'),
      (num: 8, word: '여드레'),
      (num: 9, word: '아흐레'),
      (num: 10, word: '열흘'),
      (num: 11, word: '열하루'),
      (num: 20, word: '스무날'),
      (num: 21, word: '스무하루'),
      (num: 30, word: '서른날'),
    ];

    const invalidNumbers = [0, -1, 31];

    for (final c in validNumbers) {
      test('${c.num} - 순 우리말 날짜(${c.word})로 바꿔 반환해야 한다.', () {
        expect(days(c.num), equals(c.word));
      });
    }

    for (final n in invalidNumbers) {
      test('$n - 유효하지 않은 숫자에 대해 오류를 발생시켜야 한다.', () {
        expect(() => days(n), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', '지원하지 않는 숫자입니다.')));
      });
    }
  });
}
