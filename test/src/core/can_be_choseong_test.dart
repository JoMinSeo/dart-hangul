import 'package:dart_hangul/src/core/can_be_choseong.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('canBeChoseong', () {
    group('초성이 될 수 있다고 판단되는 경우', () {
      test('ㄱ', () {
        expect(canBeChoseong('ㄱ'), isTrue);
      });

      test('ㅃ', () {
        expect(canBeChoseong('ㅃ'), isTrue);
      });
    });

    group('초성이 될 수 없다고 판단되는 경우', () {
      test('ㅏ', () {
        expect(canBeChoseong('ㅏ'), isFalse);
      });

      test('ㅘ', () {
        expect(canBeChoseong('ㅘ'), isFalse);
      });

      test('ㄱㅅ', () {
        expect(canBeChoseong('ㄱㅅ'), isFalse);
      });

      test('가', () {
        expect(canBeChoseong('가'), isFalse);
      });
    });
  });
}
