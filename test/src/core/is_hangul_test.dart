import 'package:dart_hangul/src/core/is_hangul.dart';
import 'package:test/test.dart';

void main() {
  group('isHangul', () {
    test('완성형 한글·자모·공백으로만 이루어진 문자열이면 true', () {
      expect(isHangul('값'), isTrue);
      expect(isHangul('ㄱ'), isTrue);
      expect(isHangul('ㅏ'), isTrue);
      expect(isHangul('저는 고양이를 좋아합니다'), isTrue);
    });

    test('한글 외 문자가 섞이거나 빈 문자열이면 false', () {
      expect(isHangul('a'), isFalse);
      expect(isHangul('한글a'), isFalse);
      expect(isHangul('123'), isFalse);
      expect(isHangul(''), isFalse);
    });
  });
}
