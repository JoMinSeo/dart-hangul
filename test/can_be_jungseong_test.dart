import 'package:dart_hangul/src/core/can_be_jungseong.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('canBeJungseong', () {
    group('중성이 될 수 있다고 판단되는 경우', () {
      test('ㅗㅏ', () {
        expect(canBeJungseong('ㅗㅏ'), isTrue);
      });

      test('ㅘ', () {
        expect(canBeJungseong('ㅘ'), isTrue);
      });

      test('ㅏ', () {
        expect(canBeJungseong('ㅏ'), isTrue);
      });
    });

    group('중성이 될 수 없다고 판단되는 경우', () {
      test('ㄱ', () {
        expect(canBeJungseong('ㄱ'), isFalse);
      });

      test('ㄱㅅ', () {
        expect(canBeJungseong('ㄱㅅ'), isFalse);
      });

      test('가', () {
        expect(canBeJungseong('가'), isFalse);
      });
    });
  });
}
