import 'package:dart_hangul/src/core/disassemble_to_groups.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('disassembleToGroups', () {
    test('값', () {
      expect(
        disassembleToGroups('값'),
        equals([
          ['ㄱ', 'ㅏ', 'ㅂ', 'ㅅ'],
        ]),
      );
    });

    test('값이 비싸다', () {
      expect(
        disassembleToGroups('값이 비싸다'),
        equals([
          ['ㄱ', 'ㅏ', 'ㅂ', 'ㅅ'],
          ['ㅇ', 'ㅣ'],
          [' '],
          ['ㅂ', 'ㅣ'],
          ['ㅆ', 'ㅏ'],
          ['ㄷ', 'ㅏ'],
        ]),
      );
    });

    test('사과 짱', () {
      expect(
        disassembleToGroups('사과 짱'),
        equals([
          ['ㅅ', 'ㅏ'],
          ['ㄱ', 'ㅗ', 'ㅏ'],
          [' '],
          ['ㅉ', 'ㅏ', 'ㅇ'],
        ]),
      );
    });

    test('ㄵ', () {
      expect(
        disassembleToGroups('ㄵ'),
        equals([
          ['ㄴ', 'ㅈ'],
        ]),
      );
    });

    test('ㅘ', () {
      expect(
        disassembleToGroups('ㅘ'),
        equals([
          ['ㅗ', 'ㅏ'],
        ]),
      );
    });
  });
}
