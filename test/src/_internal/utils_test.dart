import 'package:dart_hangul/src/_internal/utils.dart';
import 'package:test/test.dart';

void main() {
  group('excludeLastElement', () {
    test('마지막 요소를 제외한 모든 요소와 마지막 요소를 반환한다', () {
      final result = excludeLastElement(['apple', 'banana', 'cherry']);
      expect(result.rest, equals(['apple', 'banana']));
      expect(result.last, equals('cherry'));
    });

    test('입력 배열이 비어 있으면 빈 배열과 빈 문자열을 반환한다', () {
      final result = excludeLastElement([]);
      expect(result.rest, isEmpty);
      expect(result.last, equals(''));
    });

    test('배열에 단 하나의 요소만 있는 경우, 빈배열과 그 요소를 반환한다', () {
      final result = excludeLastElement(['apple']);
      expect(result.rest, isEmpty);
      expect(result.last, equals('apple'));
    });
  });

  group('hasValueInReadOnlyStringList', () {
    const testList = ['ㄱ', 'ㄴ', 'ㄷ'];

    test('문자열 리스트에 요소가 존재한다면 true를 반환한다.', () {
      expect(hasValueInReadOnlyStringList(testList, 'ㄱ'), isTrue);
    });

    test('문자열 리스트에 요소가 존재하지 않으면 false를 반환한다.', () {
      expect(hasValueInReadOnlyStringList(testList, 'ㄹ'), isFalse);
    });
  });
}
