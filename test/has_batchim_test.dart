import 'package:dart_hangul/src/core/has_batchim.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('hasBatchim', () {
    group('받침이 있다고 판단되는 경우', () {
      test('"값" 문자에서 받침이 있으므로 true를 반환한다.', () {
        expect(hasBatchim('값'), isTrue);
      });

      test('"공" 문자에서 받침이 있으므로 true를 반환한다.', () {
        expect(hasBatchim('공'), isTrue);
      });

      test('"읊" 문자에서 받침이 있으므로 true를 반환한다.', () {
        expect(hasBatchim('읊'), isTrue);
      });
    });

    group('받침이 없다고 판단되는 경우', () {
      test('"토" 문자에서 받침이 없으므로 false를 반환한다.', () {
        expect(hasBatchim('토'), isFalse);
      });

      test('"서" 문자에서 받침이 없으므로 false를 반환한다.', () {
        expect(hasBatchim('서'), isFalse);
      });

      test('빈 문자열은 받침이 없으므로 false를 반환한다.', () {
        expect(hasBatchim(''), isFalse);
      });
    });

    group('완성된 한글이 아닌 경우', () {
      test('한글이 자음 또는 모음으로만 구성된 경우 false를 반환한다.', () {
        expect(hasBatchim('ㄱ'), isFalse);
        expect(hasBatchim('ㅏ'), isFalse);
      });

      test('한글 외의 문자를 입력하면 false를 반환한다.', () {
        expect(hasBatchim('cat'), isFalse);
        expect(hasBatchim('!'), isFalse);
      });
    });
  });

  group('홑받침', () {
    test('홑받침을 받으면 true를 반환한다.', () {
      expect(hasBatchim('공', only: BatchimType.single), isTrue);
      expect(hasBatchim('핫', only: BatchimType.single), isTrue);
      expect(hasBatchim('양', only: BatchimType.single), isTrue);
      expect(hasBatchim('신', only: BatchimType.single), isTrue);
      expect(hasBatchim('확', only: BatchimType.single), isTrue);
    });

    group('홑받침이 아니라고 판단되는 경우', () {
      test('겹받침을 받으면 false를 반환한다.', () {
        expect(hasBatchim('값', only: BatchimType.single), isFalse);
        expect(hasBatchim('읊', only: BatchimType.single), isFalse);
        expect(hasBatchim('웱', only: BatchimType.single), isFalse);
      });

      test('받침이 없는 문자를 받으면 false를 반환한다.', () {
        expect(hasBatchim('토', only: BatchimType.single), isFalse);
        expect(hasBatchim('서', only: BatchimType.single), isFalse);
        expect(hasBatchim('와', only: BatchimType.single), isFalse);
      });

      test('한글 외의 문자를 입력하면 false를 반환한다.', () {
        expect(hasBatchim('cat', only: BatchimType.single), isFalse);
        expect(hasBatchim('', only: BatchimType.single), isFalse);
        expect(hasBatchim('?', only: BatchimType.single), isFalse);
      });
    });
  });

  group('겹받침', () {
    test('겹받침을 받으면 true를 반환한다.', () {
      expect(hasBatchim('값', only: BatchimType.double), isTrue);
      expect(hasBatchim('읊', only: BatchimType.double), isTrue);
      expect(hasBatchim('웱', only: BatchimType.double), isTrue);
    });

    group('겹받침이 아니라고 판단되는 경우', () {
      test('홑받침을 받으면 false를 반환한다.', () {
        expect(hasBatchim('공', only: BatchimType.double), isFalse);
        expect(hasBatchim('핫', only: BatchimType.double), isFalse);
        expect(hasBatchim('양', only: BatchimType.double), isFalse);
        expect(hasBatchim('신', only: BatchimType.double), isFalse);
        expect(hasBatchim('확', only: BatchimType.double), isFalse);
      });

      test('받침이 없는 문자를 받으면 false를 반환한다.', () {
        expect(hasBatchim('토', only: BatchimType.double), isFalse);
        expect(hasBatchim('서', only: BatchimType.double), isFalse);
        expect(hasBatchim('와', only: BatchimType.double), isFalse);
      });

      test('한글 외의 문자를 입력하면 false를 반환한다.', () {
        expect(hasBatchim('cat', only: BatchimType.double), isFalse);
        expect(hasBatchim('', only: BatchimType.double), isFalse);
        expect(hasBatchim('?', only: BatchimType.double), isFalse);
      });
    });
  });
}
