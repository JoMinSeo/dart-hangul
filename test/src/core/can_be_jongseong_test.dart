import 'package:dart_hangul/src/core/can_be_jongseong.dart';
import 'package:test/test.dart';

void main() {
  group('canBeJongseong', () {
    group('종성이 될 수 있다고 판단되는 경우', () {
      test('ㄱ', () {
        expect(canBeJongseong('ㄱ'), isTrue);
      });

      test('ㄱㅅ', () {
        expect(canBeJongseong('ㄱㅅ'), isTrue);
      });

      test('ㅂㅅ', () {
        expect(canBeJongseong('ㅂㅅ'), isTrue);
      });

      test('합성형 겹받침(ㄳ, ㅄ, ㅀ)도 분해형으로 정규화해 허용한다.', () {
        expect(canBeJongseong('ㄳ'), isTrue);
        expect(canBeJongseong('ㅄ'), isTrue);
        expect(canBeJongseong('ㅀ'), isTrue);
      });
    });

    group('종성이 될 수 없다고 판단되는 경우', () {
      test('ㅎㄹ', () {
        expect(canBeJongseong('ㅎㄹ'), isFalse);
      });

      test('ㅗㅏ', () {
        expect(canBeJongseong('ㅗㅏ'), isFalse);
      });

      test('ㅏ', () {
        expect(canBeJongseong('ㅏ'), isFalse);
      });

      test('가', () {
        expect(canBeJongseong('가'), isFalse);
      });
    });
  });
}
