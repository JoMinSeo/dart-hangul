import 'package:dart_hangul/src/_internal/hangul.dart';
import 'package:test/test.dart';

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
  });
}
