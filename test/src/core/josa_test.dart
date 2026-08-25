import 'package:dart_hangul/src/core/josa.dart';
import 'package:test/test.dart';

void main() {
  group('josa', () {
    test('주격조사', () {
      expect(josa('샴푸', Josa.iGa), equals('샴푸가'));
      expect(josa('칫솔', Josa.iGa), equals('칫솔이'));
    });

    test('목적격조사', () {
      expect(josa('샴푸', Josa.eulReul), equals('샴푸를'));
      expect(josa('칫솔', Josa.eulReul), equals('칫솔을'));
    });

    test('대조의 보조사', () {
      expect(josa('샴푸', Josa.eunNeun), equals('샴푸는'));
      expect(josa('칫솔', Josa.eunNeun), equals('칫솔은'));
    });

    test('방향의 격조사', () {
      expect(josa('바깥', Josa.euroRo), equals('바깥으로'));
      expect(josa('내부', Josa.euroRo), equals('내부로'));
    });

    test('방향의 격조사 ㄹ 받침 예외 처리', () {
      expect(josa('지름길', Josa.euroRo), equals('지름길로'));
    });

    test('비교의 격조사', () {
      expect(josa('샴푸', Josa.waGwa), equals('샴푸와'));
      expect(josa('칫솔', Josa.waGwa), equals('칫솔과'));
    });

    test('선택의 보조사', () {
      expect(josa('샴푸', Josa.inaNa), equals('샴푸나'));
      expect(josa('칫솔', Josa.inaNa), equals('칫솔이나'));
    });

    test('화제의 보조사', () {
      expect(josa('샴푸', Josa.iranRan), equals('샴푸란'));
      expect(josa('칫솔', Josa.iranRan), equals('칫솔이란'));
    });

    test('호격조사', () {
      expect(josa('철수', Josa.aYa), equals('철수야'));
      expect(josa('길동', Josa.aYa), equals('길동아'));
    });

    test('접속조사', () {
      expect(josa('고기', Josa.irangRang), equals('고기랑'));
      expect(josa('과일', Josa.irangRang), equals('과일이랑'));
    });

    test('주제의 보조사', () {
      expect(josa('의사', Josa.iraRa), equals('의사라'));
      expect(josa('선생님', Josa.iraRa), equals('선생님이라'));
    });

    test('서술격조사와 종결어미', () {
      expect(josa('사과', Josa.ieyoYeyo), equals('사과예요'));
      expect(josa('책', Josa.ieyoYeyo), equals('책이에요'));
    });

    test('서술격조사와 종결어미, "이" 로 끝나는 단어 예외 처리', () {
      expect(josa('때밀이', Josa.ieyoYeyo), equals('때밀이예요'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사', () {
      expect(josa('학생', Josa.euroseoRoseo), equals('학생으로서'));
      expect(josa('부모', Josa.euroseoRoseo), equals('부모로서'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사 ㄹ 받침 예외 처리', () {
      expect(josa('라이벌', Josa.euroseoRoseo), equals('라이벌로서'));
    });

    test('수단의 의미를 나타내는 도구격조사', () {
      expect(josa('토큰', Josa.eurosseoRosseo), equals('토큰으로써'));
      expect(josa('함수', Josa.eurosseoRosseo), equals('함수로써'));
    });

    test('수단의 의미를 나타내는 도구격조사 ㄹ 받침 예외 처리', () {
      expect(josa('건물', Josa.eurosseoRosseo), equals('건물로써'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사', () {
      expect(josa('역삼동', Josa.eurobuteoRobuteo), equals('역삼동으로부터'));
      expect(josa('저기', Josa.eurobuteoRobuteo), equals('저기로부터'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사 ㄹ 받침 예외 처리', () {
      expect(josa('동굴', Josa.eurobuteoRobuteo), equals('동굴로부터'));
    });

    test('단어가 빈 문자열일 경우 빈 문자열을 반환한다.', () {
      expect(josa('', Josa.iGa), equals(''));
    });
  });

  group('josaPick', () {
    test('첫 번째 매개변수가 빈 문자열이라면 옵션 중 첫 번째 값을 반환한다.', () {
      expect(josaPick('', Josa.iGa), equals('이'));
    });

    test('주격조사', () {
      expect(josaPick('샴푸', Josa.iGa), equals('가'));
      expect(josaPick('칫솔', Josa.iGa), equals('이'));
    });

    test('목적격조사', () {
      expect(josaPick('샴푸', Josa.eulReul), equals('를'));
      expect(josaPick('칫솔', Josa.eulReul), equals('을'));
    });

    test('대조의 보조사', () {
      expect(josaPick('샴푸', Josa.eunNeun), equals('는'));
      expect(josaPick('칫솔', Josa.eunNeun), equals('은'));
    });

    test('방향의 격조사', () {
      expect(josaPick('바깥', Josa.euroRo), equals('으로'));
      expect(josaPick('내부', Josa.euroRo), equals('로'));
    });

    test('방향의 격조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('지름길', Josa.euroRo), equals('로'));
    });

    test('비교의 격조사', () {
      expect(josaPick('샴푸', Josa.waGwa), equals('와'));
      expect(josaPick('칫솔', Josa.waGwa), equals('과'));
    });

    test('선택의 보조사', () {
      expect(josaPick('샴푸', Josa.inaNa), equals('나'));
      expect(josaPick('칫솔', Josa.inaNa), equals('이나'));
    });

    test('화제의 보조사', () {
      expect(josaPick('샴푸', Josa.iranRan), equals('란'));
      expect(josaPick('칫솔', Josa.iranRan), equals('이란'));
    });

    test('호격조사', () {
      expect(josaPick('철수', Josa.aYa), equals('야'));
      expect(josaPick('길동', Josa.aYa), equals('아'));
    });

    test('접속조사', () {
      expect(josaPick('고기', Josa.irangRang), equals('랑'));
      expect(josaPick('과일', Josa.irangRang), equals('이랑'));
    });

    test('서술격조사와 종결어미', () {
      expect(josaPick('사과', Josa.ieyoYeyo), equals('예요'));
      expect(josaPick('책', Josa.ieyoYeyo), equals('이에요'));
    });

    test('서술격조사와 종결어미, "이" 로 끝나는 단어 예외 처리', () {
      expect(josaPick('때밀이', Josa.ieyoYeyo), equals('예요'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사', () {
      expect(josaPick('학생', Josa.euroseoRoseo), equals('으로서'));
      expect(josaPick('부모', Josa.euroseoRoseo), equals('로서'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('라이벌', Josa.euroseoRoseo), equals('로서'));
    });

    test('수단의 의미를 나타내는 도구격조사', () {
      expect(josaPick('토큰', Josa.eurosseoRosseo), equals('으로써'));
      expect(josaPick('함수', Josa.eurosseoRosseo), equals('로써'));
    });

    test('수단의 의미를 나타내는 도구격조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('건물', Josa.eurosseoRosseo), equals('로써'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사', () {
      expect(josaPick('역삼동', Josa.eurobuteoRobuteo), equals('으로부터'));
      expect(josaPick('저기', Josa.eurobuteoRobuteo), equals('로부터'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('동굴', Josa.eurobuteoRobuteo), equals('로부터'));
    });

    test('영어로된 약어일 경우, 마지막 알파벳을 한국어로 바꾼뒤 조사를 붙인다.', () {
      expect(josa('URL', Josa.eulReul), equals('URL을'));
      expect(josa('CSS', Josa.eulReul), equals('CSS를'));

      expect(josa('URL', Josa.eunNeun), equals('URL은'));
      expect(josa('CSS', Josa.eunNeun), equals('CSS는'));

      expect(josa('URL', Josa.iGa), equals('URL이'));
      expect(josa('CSS', Josa.iGa), equals('CSS가'));

      expect(josa('URL', Josa.waGwa), equals('URL과'));
      expect(josa('CSS', Josa.waGwa), equals('CSS와'));

      expect(josa('URL', Josa.euroRo), equals('URL로'));

      expect(josa('URL', Josa.inaNa), equals('URL이나'));
      expect(josa('CSS', Josa.inaNa), equals('CSS나'));

      expect(josa('URL', Josa.iranRan), equals('URL이란'));
      expect(josa('CSS', Josa.iranRan), equals('CSS란'));

      expect(josa('URL', Josa.aYa), equals('URL아'));
      expect(josa('CSS', Josa.aYa), equals('CSS야'));

      expect(josa('URL', Josa.irangRang), equals('URL이랑'));
      expect(josa('CSS', Josa.irangRang), equals('CSS랑'));

      expect(josa('URL', Josa.ieyoYeyo), equals('URL이에요'));
      expect(josa('CSS', Josa.ieyoYeyo), equals('CSS예요'));
    });
  });

  group('Josa.tryParse', () {
    test('유효한 조사 쌍 문자열을 Josa 으로 변환한다.', () {
      expect(Josa.tryParse('이/가'), equals(Josa.iGa));
      expect(Josa.tryParse('을/를'), equals(Josa.eulReul));
      expect(Josa.tryParse('으로부터/로부터'), equals(Josa.eurobuteoRobuteo));
    });

    test('모든 Josa 은 toString 결과로 다시 파싱된다.', () {
      for (final option in Josa.values) {
        expect(Josa.tryParse(option.toString()), equals(option));
      }
    });

    test('유효하지 않은 조사 쌍이면 null 을 반환한다.', () {
      expect(Josa.tryParse('이/을'), isNull); // 앞뒤가 다른 쌍의 조합
      expect(Josa.tryParse('을/가'), isNull);
      expect(Josa.tryParse('가/이'), isNull); // 순서 뒤집힘
      expect(Josa.tryParse('을를'), isNull); // 구분자 없음
      expect(Josa.tryParse('을'), isNull); // 한쪽만
      expect(Josa.tryParse(''), isNull);
    });
  });

  group('Josa.parse', () {
    test('유효한 조사 쌍 문자열을 Josa 으로 변환한다.', () {
      expect(Josa.parse('을/를'), equals(Josa.eulReul));
    });

    test('유효하지 않은 조사 쌍이면 ArgumentError 를 던진다.', () {
      expect(() => Josa.parse('이/을'), throwsArgumentError);
      expect(() => Josa.parse('을를'), throwsArgumentError);
    });
  });
}
