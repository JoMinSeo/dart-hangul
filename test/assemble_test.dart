import 'package:dart_hangul/src/core/assemble.dart';
import 'package:flutter_test/flutter_test.dart';

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
  });
}
