import 'package:dart_hangul/src/number/number_to_hangul.dart';
import 'package:test/test.dart';

void main() {
  group('numberToHangul', () {
    test('기본 변환', () {
      expect(numberToHangul(210000), equals('이십일만'));
      expect(numberToHangul(12345), equals('일만이천삼백사십오'));
      expect(numberToHangul(123456780), equals('일억이천삼백사십오만육천칠백팔십'));
      expect(numberToHangul(100000000), equals('일억'));
      expect(numberToHangul(1000000000000), equals('일조'));
    });

    test('공백 포함 변환', () {
      expect(numberToHangul(210000, spacing: true), equals('이십일만'));
      expect(numberToHangul(12345, spacing: true), equals('일만 이천삼백사십오'));
      expect(numberToHangul(123456780, spacing: true), equals('일억 이천삼백사십오만 육천칠백팔십'));
    });

    test('0 이상 10,000 미만인 경우', () {
      expect(numberToHangul(0), equals('영'));
      expect(numberToHangul(1), equals('일'));
      expect(numberToHangul(2), equals('이'));
      expect(numberToHangul(3), equals('삼'));
      expect(numberToHangul(4), equals('사'));
      expect(numberToHangul(5), equals('오'));
      expect(numberToHangul(6), equals('육'));
      expect(numberToHangul(7), equals('칠'));
      expect(numberToHangul(8), equals('팔'));
      expect(numberToHangul(9), equals('구'));
      expect(numberToHangul(10), equals('십'));
      expect(numberToHangul(11), equals('십일'));
      expect(numberToHangul(20), equals('이십'));
      expect(numberToHangul(30), equals('삼십'));
      expect(numberToHangul(100), equals('백'));
      expect(numberToHangul(101), equals('백일'));
      expect(numberToHangul(110), equals('백십'));
      expect(numberToHangul(200), equals('이백'));
      expect(numberToHangul(300), equals('삼백'));
      expect(numberToHangul(1000), equals('천'));
      expect(numberToHangul(1001), equals('천일'));
      expect(numberToHangul(1100), equals('천백'));
      expect(numberToHangul(1200), equals('천이백'));
      expect(numberToHangul(1234), equals('천이백삼십사'));
      expect(numberToHangul(9999), equals('구천구백구십구'));
    });

    test('음수', () {
      expect(numberToHangul(-210000), equals('마이너스이십일만'));
      expect(numberToHangul(-12345), equals('마이너스일만이천삼백사십오'));
      expect(numberToHangul(-123456780), equals('마이너스일억이천삼백사십오만육천칠백팔십'));
      expect(numberToHangul(-210000, spacing: true), equals('마이너스 이십일만'));
      expect(numberToHangul(-12345, spacing: true), equals('마이너스 일만 이천삼백사십오'));
      expect(numberToHangul(-123456780, spacing: true), equals('마이너스 일억 이천삼백사십오만 육천칠백팔십'));
    });

    test('Infinity', () {
      expect(numberToHangul(double.infinity), equals('무한대'));
      expect(numberToHangul(double.negativeInfinity), equals('마이너스무한대'));
      expect(numberToHangul(double.negativeInfinity, spacing: true), equals('마이너스 무한대'));
    });

    test('소수', () {
      expect(numberToHangul(0.1), equals('영점일'));
      expect(numberToHangul(12345.678), equals('일만이천삼백사십오점육칠팔'));
      expect(numberToHangul(-0.1), equals('마이너스영점일'));
      expect(numberToHangul(-12345.678), equals('마이너스일만이천삼백사십오점육칠팔'));
      expect(numberToHangul(0.0102), equals('영점영일영이'));
      expect(numberToHangul(0.1, spacing: true), equals('영점 일'));
      expect(numberToHangul(12345.678, spacing: true), equals('일만 이천삼백사십오점 육칠팔'));
      expect(numberToHangul(-0.1, spacing: true), equals('마이너스 영점 일'));
      expect(numberToHangul(-12345.678, spacing: true), equals('마이너스 일만 이천삼백사십오점 육칠팔'));
    });

    test('소수부가 0인 double 은 정수로 취급한다.', () {
      expect(numberToHangul(12345.0), equals('일만이천삼백사십오'));
      expect(numberToHangul(0.0), equals('영'));
    });

    test('유효하지 않은 입력에 대한 오류 처리', () {
      expect(
        () => numberToHangul(double.nan),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', '유효한 숫자를 입력해주세요.')),
      );
    });
  });
}
