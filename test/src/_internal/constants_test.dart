import 'package:dart_hangul/src/_internal/constants.dart';
import 'package:test/test.dart';

void main() {
  group('자모 테이블 불변식', () {
    test('jungseongs 는 disassembledVowelsByVowel 의 값 순서와 같다 (인덱스 = 유니코드 오프셋)', () {
      expect(jungseongs, equals(disassembledVowelsByVowel.values.toList()));
      expect(jungseongs, hasLength(numberOfJungseong));
    });

    test('jongseongs 는 합성형 종성 순서를 분해한 결과와 같다 (인덱스 = 유니코드 오프셋)', () {
      const composite = 'ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ';
      final expected = ['', ...composite.split('').map((c) => disassembledConsonantsByConsonant[c]!)];
      expect(jongseongs, equals(expected));
      expect(jongseongs, hasLength(numberOfJongseong));
    });

    test('완성형 한글 범위는 가~힣 이다', () {
      expect(completeHangulStartCharCode, equals('가'.codeUnitAt(0)));
      expect(completeHangulEndCharCode, equals('힣'.codeUnitAt(0)));
    });
  });
}
