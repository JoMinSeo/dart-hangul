import 'package:dart_hangul/src/core/get_choseong.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getChoseong', () {
    test('"사과" 단어에서 초성 "ㅅㄱ"을 추출한다.', () {
      expect(getChoseong('사과'), equals('ㅅㄱ'));
    });

    test('"프론트엔드" 단어에서 초성 "ㅍㄹㅌㅇㄷ"을 추출한다.', () {
      expect(getChoseong('프론트엔드'), equals('ㅍㄹㅌㅇㄷ'));
    });

    test('"플러터" 단어에서 초성 "ㅍㄹㅌ"을 추출한다.', () {
      expect(getChoseong('플러터'), equals('ㅍㄹㅌ'));
    });

    test('"ㄴㅈ" 문자에서 초성 "ㄴㅈ"을 추출한다.', () {
      expect(getChoseong('ㄴㅈ'), equals('ㄴㅈ'));
    });

    test('"리액트" 단어에서 초성 "ㄹㅇㅌ"을 추출한다.', () {
      expect(getChoseong('리액트'), equals('ㄹㅇㅌ'));
    });

    test('"띄어 쓰기" 문장에서 초성 "ㄸㅇ ㅆㄱ"을 추출한다.', () {
      expect(getChoseong('띄어 쓰기'), equals('ㄸㅇ ㅆㄱ'));
    });
  });
}
