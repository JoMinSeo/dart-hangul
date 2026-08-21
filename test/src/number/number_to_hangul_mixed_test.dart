import 'package:dart_hangul/src/number/number_to_hangul_mixed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('numberToHangulMixed', () {
    test('기본 변환', () {
      expect(numberToHangulMixed(210000), equals('21만'));
      expect(numberToHangulMixed(12345), equals('1만2,345'));
      expect(numberToHangulMixed(123456780), equals('1억2,345만6,780'));
    });

    test('공백 포함 변환', () {
      expect(numberToHangulMixed(210000, spacing: true), equals('21만'));
      expect(numberToHangulMixed(12345, spacing: true), equals('1만 2,345'));
      expect(numberToHangulMixed(123456780, spacing: true), equals('1억 2,345만 6,780'));
    });

    test('0 이상 10,000 미만인 경우', () {
      expect(numberToHangulMixed(0), equals('0'));
      expect(numberToHangulMixed(1), equals('1'));
      expect(numberToHangulMixed(2), equals('2'));
      expect(numberToHangulMixed(3), equals('3'));
      expect(numberToHangulMixed(4), equals('4'));
      expect(numberToHangulMixed(5), equals('5'));
      expect(numberToHangulMixed(6), equals('6'));
      expect(numberToHangulMixed(7), equals('7'));
      expect(numberToHangulMixed(8), equals('8'));
      expect(numberToHangulMixed(9), equals('9'));
      expect(numberToHangulMixed(10), equals('10'));
      expect(numberToHangulMixed(11), equals('11'));
      expect(numberToHangulMixed(20), equals('20'));
      expect(numberToHangulMixed(30), equals('30'));
      expect(numberToHangulMixed(100), equals('100'));
      expect(numberToHangulMixed(101), equals('101'));
      expect(numberToHangulMixed(110), equals('110'));
      expect(numberToHangulMixed(200), equals('200'));
      expect(numberToHangulMixed(300), equals('300'));
      expect(numberToHangulMixed(1000), equals('1,000'));
      expect(numberToHangulMixed(1001), equals('1,001'));
      expect(numberToHangulMixed(1100), equals('1,100'));
      expect(numberToHangulMixed(1200), equals('1,200'));
      expect(numberToHangulMixed(1234), equals('1,234'));
      expect(numberToHangulMixed(9999), equals('9,999'));
    });

    test('음수', () {
      expect(numberToHangulMixed(-210000), equals('-21만'));
      expect(numberToHangulMixed(-12345), equals('-1만2,345'));
      expect(numberToHangulMixed(-123456780), equals('-1억2,345만6,780'));
      expect(numberToHangulMixed(-210000, spacing: true), equals('-21만'));
      expect(numberToHangulMixed(-12345, spacing: true), equals('-1만 2,345'));
      expect(numberToHangulMixed(-123456780, spacing: true), equals('-1억 2,345만 6,780'));
    });

    test('Infinity', () {
      expect(numberToHangulMixed(double.infinity), equals('무한대'));
      expect(numberToHangulMixed(double.negativeInfinity), equals('-무한대'));
      expect(numberToHangulMixed(double.negativeInfinity, spacing: true), equals('-무한대'));
    });

    test('소수', () {
      expect(numberToHangulMixed(0.1), equals('0.1'));
      expect(numberToHangulMixed(12345.678), equals('1만2,345.678'));
      expect(numberToHangulMixed(-0.1), equals('-0.1'));
      expect(numberToHangulMixed(-12345.678), equals('-1만2,345.678'));
      expect(numberToHangulMixed(0.1, spacing: true), equals('0.1'));
      expect(numberToHangulMixed(12345.678, spacing: true), equals('1만 2,345.678'));
      expect(numberToHangulMixed(-0.1, spacing: true), equals('-0.1'));
      expect(numberToHangulMixed(-12345.678, spacing: true), equals('-1만 2,345.678'));
    });

    test('소수부가 0인 double 은 정수로 취급한다.', () {
      expect(numberToHangulMixed(12345.0), equals('1만2,345'));
    });

    test('유효하지 않은 입력에 대한 오류 처리', () {
      expect(
        () => numberToHangulMixed(double.nan),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', '유효한 숫자를 입력해주세요.')),
      );
    });
  });
}
