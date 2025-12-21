import 'package:dart_hangul/src/_internal/hangul.dart';
import 'package:flutter_test/flutter_test.dart';

Matcher _throwsArgumentErrorMessage(String message) {
  return throwsA(predicate((e) => e is ArgumentError && e.message == message, 'ArgumentError(message: $message)'));
}

void main() {
  group('isHangul*', () {
    test('isHangulCharacter는 완성된 한글 문자를 받으면 true를 반환한다.', () {
      expect(isHangulCharacter('가'), isTrue);
      expect(isHangulCharacter('값'), isTrue);
      expect(isHangulCharacter('ㄱ'), isFalse);
      expect(isHangulCharacter('ㅏ'), isFalse);
      expect(isHangulCharacter('a'), isFalse);
    });

    test('isHangulAlphabet은 조합되지않은 한글 문자를 받으면 true를 반환한다.', () {
      expect(isHangulAlphabet('가'), isFalse);
      expect(isHangulAlphabet('값'), isFalse);
      expect(isHangulAlphabet('ㄱ'), isTrue);
      expect(isHangulAlphabet('ㅏ'), isTrue);
      expect(isHangulAlphabet('a'), isFalse);
    });

    test('isHangul은 한글 문자열을 받으면 true를 반환한다.', () {
      expect(isHangul('값'), isTrue);
      expect(isHangul('ㄱ'), isTrue);
      expect(isHangul('ㅏ'), isTrue);
      expect(isHangul('저는 고양이를 좋아합니다'), isTrue);
      expect(isHangul('a'), isFalse);
      expect(isHangul(111), isFalse);
      expect(isHangul([111, 111]), isFalse);
      expect(isHangul({'a': 111}), isFalse);
    });
  });

  group('parse', () {
    test('parseHangul은 한글 문자열을 받으면 그대로 반환한다.', () {
      expect(parseHangul('값'), equals('값'));
      expect(parseHangul('ㄱ'), equals('ㄱ'));
      expect(parseHangul('ㅏ'), equals('ㅏ'));
      expect(parseHangul('저는 고양이를 좋아합니다'), equals('저는 고양이를 좋아합니다'));
    });

    test('parseHangul은 한글 문자열이 아닌 값을 받으면 에러를 발생시킨다.', () {
      expect(() => parseHangul(111), _throwsArgumentErrorMessage('111 is not a valid hangul string'));
      expect(() => parseHangul([111, 111]), _throwsArgumentErrorMessage('[111,111] is not a valid hangul string'));
      expect(() => parseHangul({'a': 111}), _throwsArgumentErrorMessage('{"a":111} is not a valid hangul string'));
    });

    test('safeParseHangul은 한글 문자열을 받으면 성공 객체를 반환한다.', () {
      final r1 = safeParseHangul('값');
      expect(r1, isA<SafeParseHangulSuccess>());
      expect((r1 as SafeParseHangulSuccess).data, equals('값'));

      final r2 = safeParseHangul('ㄱ');
      expect(r2, isA<SafeParseHangulSuccess>());
      expect((r2 as SafeParseHangulSuccess).data, equals('ㄱ'));

      final r3 = safeParseHangul('ㅏ');
      expect(r3, isA<SafeParseHangulSuccess>());
      expect((r3 as SafeParseHangulSuccess).data, equals('ㅏ'));

      final r4 = safeParseHangul('저는 고양이를 좋아합니다');
      expect(r4, isA<SafeParseHangulSuccess>());
      expect((r4 as SafeParseHangulSuccess).data, equals('저는 고양이를 좋아합니다'));
    });

    test('safeParseHangul은 한글 문자열이 아닌 값을 받으면 실패 객체를 반환한다.', () {
      final r1 = safeParseHangul(111);
      expect(r1, isA<SafeParseHangulError>());
      expect((r1 as SafeParseHangulError).error, isA<ArgumentError>());
      expect(((r1).error as ArgumentError).message, equals('111 is not a valid hangul string'));

      final r2 = safeParseHangul([111, 111]);
      expect(r2, isA<SafeParseHangulError>());
      expect((r2 as SafeParseHangulError).error, isA<ArgumentError>());
      expect(((r2).error as ArgumentError).message, equals('[111,111] is not a valid hangul string'));

      final r3 = safeParseHangul({'a': 111});
      expect(r3, isA<SafeParseHangulError>());
      expect((r3 as SafeParseHangulError).error, isA<ArgumentError>());
      expect(((r3).error as ArgumentError).message, equals('{"a":111} is not a valid hangul string'));
    });
  });

  group('binaryAssembleCharacters', () {
    test('초성과 중성만 조합', () {
      expect(binaryAssembleCharacters('ㄱ', 'ㅏ'), equals('가'));
    });

    test('초성과 중성이 합쳐진 문자와 종성을 조합', () {
      expect(binaryAssembleCharacters('가', 'ㅇ'), equals('강'));
    });

    test('초성과 중성과 종성이 합쳐진 문자와 자음을 조합하여 겹받침 만들기', () {
      expect(binaryAssembleCharacters('갑', 'ㅅ'), equals('값'));
    });

    test('초성과 중성이 합쳐진 문자와 모음을 조립하여 겹모음 만들기', () {
      expect(binaryAssembleCharacters('고', 'ㅏ'), equals('과'));
    });

    test('초성과 중성(겹모음)이 합쳐진 문자와 자음을 조합', () {
      expect(binaryAssembleCharacters('과', 'ㄱ'), equals('곽'));
    });

    test('초성과 중성(겹모음)과 종성이 합쳐진 문자와 자음을 조합하여 겹받침 만들기', () {
      expect(binaryAssembleCharacters('완', 'ㅈ'), equals('왅'));
    });

    test('모음만 있는 문자와 모음을 조합하여 겹모음 만들기', () {
      expect(binaryAssembleCharacters('ㅗ', 'ㅏ'), equals('ㅘ'));
    });

    test('초성과 중성과 종성이 합쳐진 문자의 연음 법칙', () {
      expect(binaryAssembleCharacters('톳', 'ㅡ'), equals('토스'));
    });

    test('초성과 종성(겹모음)과 종성이 합쳐진 문자의 연음 법칙', () {
      expect(binaryAssembleCharacters('왅', 'ㅓ'), equals('완저'));
    });

    test('초성과 중성과 종성(겹받침)이 합쳐진 문자의 연음 법칙', () {
      expect(binaryAssembleCharacters('닭', 'ㅏ'), equals('달가'));
      expect(binaryAssembleCharacters('깎', 'ㅏ'), equals('까까'));
    });

    test('문법에 맞지 않는 문자를 조합하면 단순 Join 한다. (문법 순서 틀림)', () {
      expect(binaryAssembleCharacters('ㅏ', 'ㄱ'), equals('ㅏㄱ'));
      expect(binaryAssembleCharacters('까', 'ㅃ'), equals('까ㅃ'));
      expect(binaryAssembleCharacters('ㅘ', 'ㅏ'), equals('ㅘㅏ'));
    });

    test('순서대로 입력했을 때 조합이 불가능한 문자라면 단순 Join 한다.', () {
      expect(binaryAssembleCharacters('뼈', 'ㅣ'), equals('뼈ㅣ'));
    });

    test('소스가 두 글자 이상이라면 Invalid source 에러를 발생시킨다.', () {
      expect(
        () => binaryAssembleCharacters('가나', 'ㄴ'),
        _throwsArgumentErrorMessage('Invalid source character: 가나. Source must be one character.'),
      );
      expect(
        () => binaryAssembleCharacters('ㄱㄴ', 'ㅏ'),
        _throwsArgumentErrorMessage('Invalid source character: ㄱㄴ. Source must be one character.'),
      );
    });

    test('다음 문자가 한글 문자 한 글자가 아니라면 Invalid next character 에러를 발생시킨다.', () {
      expect(
        () => binaryAssembleCharacters('ㄱ', 'a'),
        _throwsArgumentErrorMessage(
          'Invalid next character: a. Next character must be one of the choseong, jungseong, or jongseong.',
        ),
      );
      expect(
        () => binaryAssembleCharacters('ㄱ', 'ㅡㅏ'),
        _throwsArgumentErrorMessage(
          'Invalid next character: ㅡㅏ. Next character must be one of the choseong, jungseong, or jongseong.',
        ),
      );
    });
  });

  group('binaryAssemble', () {
    test('문장과 모음을 조합하여 다음 글자를 생성한다.', () {
      expect(binaryAssemble('저는 고양이를 좋아합닏', 'ㅏ'), equals('저는 고양이를 좋아합니다'));
    });

    test('문장과 자음을 조합하여 홑받침을 생성한다.', () {
      expect(binaryAssemble('저는 고양이를 좋아하', 'ㅂ'), equals('저는 고양이를 좋아합'));
    });

    test('문장과 자음을 조합하여 겹받침을 생성한다.', () {
      expect(binaryAssemble('저는 고양이를 좋아합', 'ㅅ'), equals('저는 고양이를 좋아핪'));
    });

    test('조합이 불가능한 자음이 입력되면 단순 Join 한다.', () {
      expect(binaryAssemble('저는 고양이를 좋아합', 'ㄲ'), equals('저는 고양이를 좋아합ㄲ'));
      expect(binaryAssemble('저는 고양이를 좋아합', 'ㅂ'), equals('저는 고양이를 좋아합ㅂ'));
    });

    test('조합이 불가능한 모음이 입력되면 단순 Join 한다.', () {
      expect(binaryAssemble('저는 고양이를 좋아하', 'ㅏ'), equals('저는 고양이를 좋아하ㅏ'));
      expect(binaryAssemble('저는 고양이를 좋아합니다', 'ㅜ'), equals('저는 고양이를 좋아합니다ㅜ'));
    });

    group('assertHangul', () {
      test('한글 문자열을 받으면 에러를 발생시키지 않는다.', () {
        expect(() => assertHangul('ㄱ'), returnsNormally);
        expect(() => assertHangul('고양이'), returnsNormally);
        expect(() => assertHangul('저는 고양이를 좋아합니다'), returnsNormally);
        expect(() => assertHangul('저는 고양이를 좋아합니ㄷ'), returnsNormally);
      });

      test("한글 문자열이 아닌 값을 받으면 '___ is not a valid hangul string' 에러를 발생시킨다.", () {
        expect(() => assertHangul('aaaaaa'), _throwsArgumentErrorMessage('"aaaaaa" is not a valid hangul string'));
        expect(() => assertHangul(111), _throwsArgumentErrorMessage('111 is not a valid hangul string'));
        expect(() => assertHangul([111, 111]), _throwsArgumentErrorMessage('[111,111] is not a valid hangul string'));
        expect(() => assertHangul({'a': 111}), _throwsArgumentErrorMessage('{"a":111} is not a valid hangul string'));
      });
    });
  });
}
