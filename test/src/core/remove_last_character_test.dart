import 'package:dart_hangul/src/core/remove_last_character.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('removeLastCharacter', () {
    test('마지막 문자가 겹받침인 경우 홑받침으로 바꾼다.', () {
      expect(removeLastCharacter('안녕하세요 값'), equals('안녕하세요 갑'));
      expect(removeLastCharacter('안녕하세요 값이'), equals('안녕하세요 값ㅇ'));
    });

    test('마지막 문자가 초성과 중성의 조합으로 끝날 경우 초성만 남긴다.', () {
      expect(removeLastCharacter('프론트엔드'), equals('프론트엔ㄷ'));
      expect(removeLastCharacter('끓다'), equals('끓ㄷ'));
      expect(removeLastCharacter('관사'), equals('관ㅅ'));
      expect(removeLastCharacter('괴사'), equals('괴ㅅ'));
    });

    test('마지막 문자가 초성과 중성과 종성의 조합으로 끝날 경우 초성과 중성이 조합된 문자만 남긴다.', () {
      expect(removeLastCharacter('일요일'), equals('일요이'));
      expect(removeLastCharacter('완전'), equals('완저'));
      expect(removeLastCharacter('왅전'), equals('왅저'));
      expect(removeLastCharacter('깎'), equals('까'));
    });

    test(
      '마지막 문자가 초성과 중성의 조합으로 끝나며, 중성 입력 시 국제 표준 한글 레이아웃 기준 단일키로 처리되지 않는 이중모음 (ㅗ/ㅜ/ㅡ 계 이중모음) 인 경우 초성과 중성의 시작 모음만 남긴다.',
      () {
        expect(removeLastCharacter('전화'), equals('전호'));
        expect(removeLastCharacter('예의'), equals('예으'));
        expect(removeLastCharacter('신세계'), equals('신세ㄱ')); // 'ㅖ'는 단일키 처리가 가능한 이중모음이라 모음이 남지 않는다.
      },
    );

    test(
      '마지막 문자가 초성과 중성과 종성의 조합으로 끝나며, 중성 입력 시 국제 표준 한글 레이아웃 기준 단일키로 처리되지 않는 이중모음 (ㅗ/ㅜ/ㅡ 계 이중모음) 인 경우 초성과 중성만 남긴다.',
      () {
        expect(removeLastCharacter('수확'), equals('수화'));
      },
    );

    test('마지막 문자가 초성과 중성과 종성의 조합으로 끝나며, 종성이 겹자음인 경우 초성과 중성과 종성의 시작 자음만 남긴다.', () {
      expect(removeLastCharacter('끓'), equals('끌'));
    });

    test(
      '마지막 문자가 초성과 중성과 종성의 조합으로 끝나며, 중성 입력 시 국제 표준 한글 레이아웃 기준 단일키로 처리되지 않는 이중모음 (ㅗ/ㅜ/ㅡ 계 이중모음)이고 종성이 겹자음인 경우 초성과 중성과 종성의 시작 자음만 남긴다.',
      () {
        expect(removeLastCharacter('왅'), equals('완'));
      },
    );

    test('빈 문자열일 경우 빈 문자열을 반환한다.', () {
      expect(removeLastCharacter(''), equals(''));
    });
  });
}
