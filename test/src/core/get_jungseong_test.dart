import 'package:dart_hangul/src/core/get_jungseong.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getJungseong', () {
    test('"사과" 단어에서 중성 "ㅏㅘ"을 추출한다.', () {
      expect(getJungseong('사과'), equals('ㅏㅘ'));
    });

    test('"프론트엔드" 단어에서 중성 "ㅡㅗㅡㅔㅡ"을 추출한다.', () {
      expect(getJungseong('프론트엔드'), equals('ㅡㅗㅡㅔㅡ'));
    });

    test('"ㅗㅏ" 문자에서 중성 "ㅗㅏ"을 추출한다.', () {
      expect(getJungseong('ㅗㅏ'), equals('ㅗㅏ'));
    });

    test('"리액트" 단어에서 중성 "ㅣㅐㅡ"을 추출한다.', () {
      expect(getJungseong('리액트'), equals('ㅣㅐㅡ'));
    });

    test('"띄어 쓰기" 문장에서 중성 "ㅢㅓ ㅡㅣ"을 추출한다.', () {
      expect(getJungseong('띄어 쓰기'), equals('ㅢㅓ ㅡㅣ'));
    });
  });
}
