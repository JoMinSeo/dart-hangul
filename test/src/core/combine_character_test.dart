import 'package:dart_hangul/src/core/combine_character.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher _throwsInvalidHangulCharacters(String value) {
  return throwsA(
    predicate(
      (e) =>
          e is ArgumentError &&
          e.name == 'hangulCharacters' &&
          e.message == 'Invalid hangul characters' &&
          e.invalidValue == value,
      'ArgumentError(name=hangulCharacters, message=Invalid hangul characters, invalidValue=$value)',
    ),
  );
}

void main() {
  group('combineCharacter', () {
    test('종성으로 겹받침으로 구성될 수 있는 문자 두 개를 받으면 겹받침을 생성한다. (ㄱ, ㅏ, ㅂㅅ)', () {
      expect(combineCharacter('ㄱ', 'ㅏ', 'ㅂㅅ'), equals('값'));
    });

    test('종성이 입력되지 않았다면 받침이 없는 문자로 합성한다. (ㅌ, ㅗ)', () {
      expect(combineCharacter('ㅌ', 'ㅗ'), equals('토'));
    });

    test('종성이 입력되었다면 받침을 추가한다. (ㅌ, ㅗ, ㅅ)', () {
      expect(combineCharacter('ㅌ', 'ㅗ', 'ㅅ'), equals('톳'));
    });

    test('초성이 될 수 없는 문자가 초성으로 입력되면 에러를 반환한다. (ㅏ, ㅏ, ㄱ)', () {
      expect(() => combineCharacter('ㅏ', 'ㅏ', 'ㄱ'), _throwsInvalidHangulCharacters('ㅏ, ㅏ, ㄱ'));
    });

    test('중성이 될 수 없는 문자가 중성으로 입력되면 에러를 반환한다. (ㄱ, ㄴ, ㅃ)', () {
      expect(() => combineCharacter('ㄱ', 'ㄴ', 'ㅃ'), _throwsInvalidHangulCharacters('ㄱ, ㄴ, ㅃ'));
    });

    test('종성이 될 수 없는 문자가 종성으로 입력되면 에러를 반환한다. (ㄱ, ㅏ, ㅃ)', () {
      expect(() => combineCharacter('ㄱ', 'ㅏ', 'ㅃ'), _throwsInvalidHangulCharacters('ㄱ, ㅏ, ㅃ'));
    });

    test('온전한 한글 문자가 하나라도 입력되면 에러를 반환한다. (가, ㅏ, ㄱ)', () {
      expect(() => combineCharacter('가', 'ㅏ', 'ㄱ'), _throwsInvalidHangulCharacters('가, ㅏ, ㄱ'));
    });
  });
}
