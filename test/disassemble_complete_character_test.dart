import 'package:dart_hangul/src/core/disassemble_complete_character.dart';
import 'package:dart_hangul/src/types/choseong.dart';
import 'package:dart_hangul/src/types/jongseong.dart';
import 'package:dart_hangul/src/types/jungseong.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('disassembleCompleteCharacter', () {
    test('값', () {
      expect(
        disassembleCompleteCharacter('값'),
        equals((choseong: Choseong('ㄱ'), jungseong: Jungseong('ㅏ'), jongseong: Jongseong('ㅂㅅ'))),
      );
    });

    test('리', () {
      expect(
        disassembleCompleteCharacter('리'),
        equals((choseong: Choseong('ㄹ'), jungseong: Jungseong('ㅣ'), jongseong: Jongseong(''))),
      );
    });

    test('빚', () {
      expect(
        disassembleCompleteCharacter('빚'),
        equals((choseong: Choseong('ㅂ'), jungseong: Jungseong('ㅣ'), jongseong: Jongseong('ㅈ'))),
      );
    });

    test('박', () {
      expect(
        disassembleCompleteCharacter('박'),
        equals((choseong: Choseong('ㅂ'), jungseong: Jungseong('ㅏ'), jongseong: Jongseong('ㄱ'))),
      );
    });

    test('완전한 한글 문자열이 아니면 null을 반환해야 한다.', () {
      expect(disassembleCompleteCharacter('ㄱ'), isNull);
      expect(disassembleCompleteCharacter('ㅏ'), isNull);
    });
  });
}
