import 'package:dart_hangul/src/number/susa.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('susa', () {
    const validNumbers = [
      (num: 1, word: '하나', classifier: '한'),
      (num: 2, word: '둘', classifier: '두'),
      (num: 3, word: '셋', classifier: '세'),
      (num: 4, word: '넷', classifier: '네'),
      (num: 5, word: '다섯', classifier: '다섯'),
      (num: 6, word: '여섯', classifier: '여섯'),
      (num: 7, word: '일곱', classifier: '일곱'),
      (num: 8, word: '여덟', classifier: '여덟'),
      (num: 9, word: '아홉', classifier: '아홉'),
      (num: 10, word: '열', classifier: '열'),
      (num: 11, word: '열하나', classifier: '열한'),
      (num: 12, word: '열둘', classifier: '열두'),
      (num: 20, word: '스물', classifier: '스무'),
      (num: 21, word: '스물하나', classifier: '스물한'),
      (num: 30, word: '서른', classifier: '서른'),
      (num: 99, word: '아흔아홉', classifier: '아흔아홉'),
      (num: 100, word: '백', classifier: '백'),
    ];

    const invalidNumbers = [0, -1, 101];

    for (final c in validNumbers) {
      test('${c.num} - 순 우리말 수사(${c.word})로 바꿔 반환해야 한다.', () {
        expect(susa(c.num), equals(c.word));
      });

      test('${c.num} - 순 우리말 수 관형사가 있다면 수 관형사(${c.classifier})로 없다면 수사(${c.word})로 반환해야 한다.', () {
        expect(susa(c.num, classifier: true), equals(c.classifier));
      });
    }

    for (final n in invalidNumbers) {
      test('$n - 유효하지 않은 숫자에 대해 오류를 발생시켜야 한다.', () {
        final matcher = throwsA(isA<ArgumentError>().having((e) => e.message, 'message', '지원하지 않는 숫자입니다.'));
        expect(() => susa(n), matcher);
        expect(() => susa(n, classifier: true), matcher);
      });
    }
  });
}
