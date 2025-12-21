import 'package:dart_hangul/src/core/can_be_jongseong.dart';
import 'package:flutter_test/flutter_test.dart';

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
