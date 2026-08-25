import 'package:dart_hangul/src/core/assemble.dart';
import 'package:test/test.dart';

void main() {
  group('assemble', () {
    test('온전한 한글과 한글 문자 조합', () {
      expect(assemble(['아버지가', ' ', '방ㅇ', 'ㅔ ', '들ㅇ', 'ㅓ갑니다']), equals('아버지가 방에 들어갑니다'));
    });

    test('온전한 한글만 조합', () {
      expect(assemble(['아버지가', ' ', '방에 ', '들어갑니다']), equals('아버지가 방에 들어갑니다'));
    });

    test('온전하지 않은 한글만 조합', () {
      expect(assemble(['ㅇ', 'ㅏ', 'ㅂ', 'ㅓ', 'ㅈ', 'ㅣ']), equals('아버지'));
    });

    test('숫자나 기호 등 한글이 아닌 문자는 조합하지 않고 그대로 유지한다', () {
      expect(assemble(['1', '2', '3']), equals('123'));
      expect(assemble(['아', 'ㅇ', 'ㅣ', '123']), equals('아이123'));
      expect(assemble(['ㄱ', 'ㅏ', '!', 'ㄴ', 'ㅏ']), equals('가!나'));
      expect(assemble(['ㅇ', 'ㅑ', '1', 'ㅎ', 'ㅏ']), equals('야1하'));
    });

    test('서로게이트 쌍(이모지)은 쪼개지 않고 그대로 유지한다', () {
      expect(assemble(['가', '😀', 'ㄱ']), equals('가😀ㄱ'));
    });
  });

  group('assemble — 두 조각 조합 (조합 엔진 케이스)', () {
    test('초성·중성·종성을 차례로 쌓는다', () {
      expect(assemble(['ㄱ', 'ㅏ']), equals('가'));
      expect(assemble(['가', 'ㅇ']), equals('강'));
      expect(assemble(['갑', 'ㅅ']), equals('값'));
      expect(assemble(['고', 'ㅏ']), equals('과'));
      expect(assemble(['과', 'ㄱ']), equals('곽'));
      expect(assemble(['완', 'ㅈ']), equals('왅'));
      expect(assemble(['ㅗ', 'ㅏ']), equals('ㅘ'));
    });

    test('받침 뒤에 모음이 오면 연음 법칙을 적용한다', () {
      expect(assemble(['톳', 'ㅡ']), equals('토스'));
      expect(assemble(['왅', 'ㅓ']), equals('완저'));
      expect(assemble(['닭', 'ㅏ']), equals('달가'));
      expect(assemble(['깎', 'ㅏ']), equals('까까'));
    });

    test('문법에 맞지 않거나 조합 불가능한 문자는 단순 Join 한다', () {
      expect(assemble(['ㅏ', 'ㄱ']), equals('ㅏㄱ'));
      expect(assemble(['까', 'ㅃ']), equals('까ㅃ'));
      expect(assemble(['ㅘ', 'ㅏ']), equals('ㅘㅏ'));
      expect(assemble(['뼈', 'ㅣ']), equals('뼈ㅣ'));
    });

    test('문장 끝 글자에 자모를 합성한다', () {
      expect(assemble(['저는 고양이를 좋아합닏', 'ㅏ']), equals('저는 고양이를 좋아합니다'));
      expect(assemble(['저는 고양이를 좋아하', 'ㅂ']), equals('저는 고양이를 좋아합'));
      expect(assemble(['저는 고양이를 좋아합', 'ㅅ']), equals('저는 고양이를 좋아핪'));
      expect(assemble(['저는 고양이를 좋아합', 'ㄲ']), equals('저는 고양이를 좋아합ㄲ'));
      expect(assemble(['저는 고양이를 좋아합', 'ㅂ']), equals('저는 고양이를 좋아합ㅂ'));
      expect(assemble(['저는 고양이를 좋아하', 'ㅏ']), equals('저는 고양이를 좋아하ㅏ'));
      expect(assemble(['저는 고양이를 좋아합니다', 'ㅜ']), equals('저는 고양이를 좋아합니다ㅜ'));
    });
  });
}
