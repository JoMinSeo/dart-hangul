import 'package:dart_hangul/src/core/disassemble.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('disassemble', () {
    test('값', () {
      expect(disassemble('값'), equals('ㄱㅏㅂㅅ'));
    });

    test('값이 비싸다', () {
      expect(disassemble('값이 비싸다'), equals('ㄱㅏㅂㅅㅇㅣ ㅂㅣㅆㅏㄷㅏ'));
    });

    test('사과 짱', () {
      expect(disassemble('사과 짱'), equals('ㅅㅏㄱㅗㅏ ㅉㅏㅇ'));
    });

    test('ㄵ', () {
      expect(disassemble('ㄵ'), equals('ㄴㅈ'));
    });

    test('ㅘ', () {
      expect(disassemble('ㅘ'), equals('ㅗㅏ'));
    });
  });
}
