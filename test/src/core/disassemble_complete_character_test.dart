import 'package:dart_hangul/src/core/disassemble_complete_character.dart';
import 'package:test/test.dart';

void main() {
  group('disassembleCompleteCharacter', () {
    test('값', () {
      expect(disassembleCompleteCharacter('값'), equals((choseong: 'ㄱ', jungseong: 'ㅏ', jongseong: 'ㅂㅅ')));
    });

    test('리', () {
      expect(disassembleCompleteCharacter('리'), equals((choseong: 'ㄹ', jungseong: 'ㅣ', jongseong: '')));
    });

    test('빚', () {
      expect(disassembleCompleteCharacter('빚'), equals((choseong: 'ㅂ', jungseong: 'ㅣ', jongseong: 'ㅈ')));
    });

    test('박', () {
      expect(disassembleCompleteCharacter('박'), equals((choseong: 'ㅂ', jungseong: 'ㅏ', jongseong: 'ㄱ')));
    });

    test('완전한 한글 문자열이 아니면 null을 반환해야 한다.', () {
      expect(disassembleCompleteCharacter('ㄱ'), isNull);
      expect(disassembleCompleteCharacter('ㅏ'), isNull);
    });
  });
}
