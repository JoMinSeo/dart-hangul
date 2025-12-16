import 'package:dart_hangul/src/core/combine_vowels.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('combineVowels', () {
    test('겹모음이 될 수 있는 모음이 순서대로 입력되면 겹모음으로 합성한다.', () {
      expect(combineVowels('ㅗ', 'ㅏ'), equals('ㅘ'));
      expect(combineVowels('ㅜ', 'ㅔ'), equals('ㅞ'));
      expect(combineVowels('ㅡ', 'ㅣ'), equals('ㅢ'));
    });

    test('겹모음이 될 수 있는 모음이라고 해도 틀린 순서로 입력되면 Join한다.', () {
      expect(combineVowels('ㅏ', 'ㅗ'), equals('ㅏㅗ'));
      expect(combineVowels('ㅣ', 'ㅡ'), equals('ㅣㅡ'));
    });

    test('이미 겹모음인 문자와 모음을 합성하려고 시도하면 Join한다.', () {
      expect(combineVowels('ㅘ', 'ㅏ'), equals('ㅘㅏ'));
      expect(combineVowels('ㅝ', 'ㅣ'), equals('ㅝㅣ'));
    });
  });
}
