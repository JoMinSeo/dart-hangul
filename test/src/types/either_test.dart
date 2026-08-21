import 'package:dart_hangul/src/types/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Either', () {
    const right = Right<String, int>(5);
    const left = Left<String, int>('oops');

    test('isLeft / isRight', () {
      expect(right.isRight, isTrue);
      expect(right.isLeft, isFalse);
      expect(left.isLeft, isTrue);
      expect(left.isRight, isFalse);
    });

    test('map은 Right에만 적용되고 Left는 그대로 전달한다.', () {
      expect(right.map((x) => x * 2), equals(const Right<String, int>(10)));
      expect(left.map((x) => x * 2), equals(const Left<String, int>('oops')));
    });

    test('flatMap은 Right에만 적용되고 Left는 그대로 전달한다.', () {
      expect(right.flatMap((x) => Right<String, int>(x * 2)), equals(const Right<String, int>(10)));
      expect(right.flatMap((x) => const Left<String, int>('fail')), equals(const Left<String, int>('fail')));
      expect(left.flatMap((x) => Right<String, int>(x * 2)), equals(const Left<String, int>('oops')));
    });

    test('fold는 Left/Right를 각각 처리한다.', () {
      String f(Either<String, int> e) => e.fold((l) => 'Error: $l', (r) => 'Value: $r');
      expect(f(right), equals('Value: 5'));
      expect(f(left), equals('Error: oops'));
    });

    test('getOrElse / getOrNull', () {
      expect(right.getOrElse(() => 0), equals(5));
      expect(left.getOrElse(() => 0), equals(0));
      expect(right.getOrNull(), equals(5));
      expect(left.getOrNull(), isNull);
    });

    test('동등성과 toString', () {
      expect(const Right<String, int>(5), equals(const Right<String, int>(5)));
      expect(const Right<String, int>(5), isNot(equals(const Right<String, int>(6))));
      expect(const Left<String, int>('a'), equals(const Left<String, int>('a')));
      expect(right.toString(), equals('Right(5)'));
      expect(left.toString(), equals('Left(oops)'));
    });
  });
}
