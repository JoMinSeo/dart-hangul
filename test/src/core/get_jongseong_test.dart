import 'package:dart_hangul/src/core/get_jongseong.dart';
import 'package:test/test.dart';

void main() {
  group('getJongseong', () {
    test('"값" 단어에서 종성 "ㅄ"을 추출한다.', () {
      expect(getJongseong('값'), equals('ㅄ'));
    });

    test('"사람" 단어에서 종성 "ㅁ"을 추출한다.', () {
      expect(getJongseong('사람'), equals('ㅁ'));
    });

    test('"사과" 단어에서 종성 ""을 추출한다.', () {
      expect(getJongseong('사과'), equals(''));
    });

    test('"ㄴㅈ" 자모 입력에서는 종성 ""을 추출한다.', () {
      expect(getJongseong('ㄴㅈ'), equals(''));
    });

    test('"리액트" 단어에서 종성 "ㄱ"을 추출한다.', () {
      expect(getJongseong('리액트'), equals('ㄱ'));
    });

    test('"띄어 쓰기" 문장에서 종성 " "을 추출한다.', () {
      expect(getJongseong('띄어 쓰기'), equals(' '));
    });

    test('"파이팅" 단어에서 종성 "ㅇ"을 추출한다.', () {
      expect(getJongseong('파이팅'), equals('ㅇ'));
    });
  });
}
