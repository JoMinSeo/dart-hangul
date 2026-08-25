import 'package:dart_hangul/src/types/choseong.dart';
import 'package:dart_hangul/src/types/jongseong.dart';
import 'package:dart_hangul/src/types/jungseong.dart';
import 'package:test/test.dart';

void main() {
  group('Choseong/Jungseong/Jongseong', () {
    test('fromIndex 와 index 는 서로 역연산이다', () {
      for (var i = 0; i < 19; i++) {
        expect(Choseong.fromIndex(i).index, equals(i));
      }
      for (var i = 0; i < 21; i++) {
        expect(Jungseong.fromIndex(i).index, equals(i));
      }
      for (var i = 0; i < 28; i++) {
        expect(Jongseong.fromIndex(i).index, equals(i));
      }
    });

    test('tryParse 는 합성형을 분해형으로 정규화하고, index 도 분해형 기준이다', () {
      expect(Jungseong.tryParse('ㅘ'), equals('ㅗㅏ'));
      expect(Jungseong.tryParse('ㅘ')!.index, equals(Jungseong.tryParse('ㅗㅏ')!.index));
      expect(Jongseong.tryParse('ㅄ'), equals('ㅂㅅ'));
      expect(Jongseong.tryParse('ㅄ')!.index, equals(Jongseong.tryParse('ㅂㅅ')!.index));
      expect(Jongseong.tryParse('')!.index, equals(0));
    });

    test('유효하지 않은 값은 tryParse 가 null, fromIndex 가 RangeError', () {
      expect(Choseong.tryParse('ㅏ'), isNull);
      expect(Jungseong.tryParse(''), isNull);
      expect(Jongseong.tryParse('ㅎㄹ'), isNull);
      expect(() => Choseong.fromIndex(19), throwsRangeError);
      expect(() => Jongseong.fromIndex(-1), throwsRangeError);
    });
  });
}
