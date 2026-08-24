import 'package:dart_hangul/src/core/josa.dart';
import 'package:test/test.dart';

void main() {
  group('josa', () {
    test('주격조사', () {
      expect(josa('샴푸', JosaOption.iGa), equals('샴푸가'));
      expect(josa('칫솔', JosaOption.iGa), equals('칫솔이'));
    });

    test('목적격조사', () {
      expect(josa('샴푸', JosaOption.eulReul), equals('샴푸를'));
      expect(josa('칫솔', JosaOption.eulReul), equals('칫솔을'));
    });

    test('대조의 보조사', () {
      expect(josa('샴푸', JosaOption.eunNeun), equals('샴푸는'));
      expect(josa('칫솔', JosaOption.eunNeun), equals('칫솔은'));
    });

    test('방향의 격조사', () {
      expect(josa('바깥', JosaOption.euroRo), equals('바깥으로'));
      expect(josa('내부', JosaOption.euroRo), equals('내부로'));
    });

    test('방향의 격조사 ㄹ 받침 예외 처리', () {
      expect(josa('지름길', JosaOption.euroRo), equals('지름길로'));
    });

    test('비교의 격조사', () {
      expect(josa('샴푸', JosaOption.waGwa), equals('샴푸와'));
      expect(josa('칫솔', JosaOption.waGwa), equals('칫솔과'));
    });

    test('선택의 보조사', () {
      expect(josa('샴푸', JosaOption.inaNa), equals('샴푸나'));
      expect(josa('칫솔', JosaOption.inaNa), equals('칫솔이나'));
    });

    test('화제의 보조사', () {
      expect(josa('샴푸', JosaOption.iranRan), equals('샴푸란'));
      expect(josa('칫솔', JosaOption.iranRan), equals('칫솔이란'));
    });

    test('호격조사', () {
      expect(josa('철수', JosaOption.aYa), equals('철수야'));
      expect(josa('길동', JosaOption.aYa), equals('길동아'));
    });

    test('접속조사', () {
      expect(josa('고기', JosaOption.irangRang), equals('고기랑'));
      expect(josa('과일', JosaOption.irangRang), equals('과일이랑'));
    });

    test('주제의 보조사', () {
      expect(josa('의사', JosaOption.iraRa), equals('의사라'));
      expect(josa('선생님', JosaOption.iraRa), equals('선생님이라'));
    });

    test('서술격조사와 종결어미', () {
      expect(josa('사과', JosaOption.ieyoYeyo), equals('사과예요'));
      expect(josa('책', JosaOption.ieyoYeyo), equals('책이에요'));
    });

    test('서술격조사와 종결어미, "이" 로 끝나는 단어 예외 처리', () {
      expect(josa('때밀이', JosaOption.ieyoYeyo), equals('때밀이예요'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사', () {
      expect(josa('학생', JosaOption.euroseoRoseo), equals('학생으로서'));
      expect(josa('부모', JosaOption.euroseoRoseo), equals('부모로서'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사 ㄹ 받침 예외 처리', () {
      expect(josa('라이벌', JosaOption.euroseoRoseo), equals('라이벌로서'));
    });

    test('수단의 의미를 나타내는 도구격조사', () {
      expect(josa('토큰', JosaOption.eurosseoRosseo), equals('토큰으로써'));
      expect(josa('함수', JosaOption.eurosseoRosseo), equals('함수로써'));
    });

    test('수단의 의미를 나타내는 도구격조사 ㄹ 받침 예외 처리', () {
      expect(josa('건물', JosaOption.eurosseoRosseo), equals('건물로써'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사', () {
      expect(josa('역삼동', JosaOption.eurobuteoRobuteo), equals('역삼동으로부터'));
      expect(josa('저기', JosaOption.eurobuteoRobuteo), equals('저기로부터'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사 ㄹ 받침 예외 처리', () {
      expect(josa('동굴', JosaOption.eurobuteoRobuteo), equals('동굴로부터'));
    });

    test('단어가 빈 문자열일 경우 빈 문자열을 반환한다.', () {
      expect(josa('', JosaOption.iGa), equals(''));
    });
  });

  group('josaPick', () {
    test('첫 번째 매개변수가 빈 문자열이라면 옵션 중 첫 번째 값을 반환한다.', () {
      expect(josaPick('', JosaOption.iGa), equals('이'));
    });

    test('주격조사', () {
      expect(josaPick('샴푸', JosaOption.iGa), equals('가'));
      expect(josaPick('칫솔', JosaOption.iGa), equals('이'));
    });

    test('목적격조사', () {
      expect(josaPick('샴푸', JosaOption.eulReul), equals('를'));
      expect(josaPick('칫솔', JosaOption.eulReul), equals('을'));
    });

    test('대조의 보조사', () {
      expect(josaPick('샴푸', JosaOption.eunNeun), equals('는'));
      expect(josaPick('칫솔', JosaOption.eunNeun), equals('은'));
    });

    test('방향의 격조사', () {
      expect(josaPick('바깥', JosaOption.euroRo), equals('으로'));
      expect(josaPick('내부', JosaOption.euroRo), equals('로'));
    });

    test('방향의 격조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('지름길', JosaOption.euroRo), equals('로'));
    });

    test('비교의 격조사', () {
      expect(josaPick('샴푸', JosaOption.waGwa), equals('와'));
      expect(josaPick('칫솔', JosaOption.waGwa), equals('과'));
    });

    test('선택의 보조사', () {
      expect(josaPick('샴푸', JosaOption.inaNa), equals('나'));
      expect(josaPick('칫솔', JosaOption.inaNa), equals('이나'));
    });

    test('화제의 보조사', () {
      expect(josaPick('샴푸', JosaOption.iranRan), equals('란'));
      expect(josaPick('칫솔', JosaOption.iranRan), equals('이란'));
    });

    test('호격조사', () {
      expect(josaPick('철수', JosaOption.aYa), equals('야'));
      expect(josaPick('길동', JosaOption.aYa), equals('아'));
    });

    test('접속조사', () {
      expect(josaPick('고기', JosaOption.irangRang), equals('랑'));
      expect(josaPick('과일', JosaOption.irangRang), equals('이랑'));
    });

    test('서술격조사와 종결어미', () {
      expect(josaPick('사과', JosaOption.ieyoYeyo), equals('예요'));
      expect(josaPick('책', JosaOption.ieyoYeyo), equals('이에요'));
    });

    test('서술격조사와 종결어미, "이" 로 끝나는 단어 예외 처리', () {
      expect(josaPick('때밀이', JosaOption.ieyoYeyo), equals('예요'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사', () {
      expect(josaPick('학생', JosaOption.euroseoRoseo), equals('으로서'));
      expect(josaPick('부모', JosaOption.euroseoRoseo), equals('로서'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('라이벌', JosaOption.euroseoRoseo), equals('로서'));
    });

    test('수단의 의미를 나타내는 도구격조사', () {
      expect(josaPick('토큰', JosaOption.eurosseoRosseo), equals('으로써'));
      expect(josaPick('함수', JosaOption.eurosseoRosseo), equals('로써'));
    });

    test('수단의 의미를 나타내는 도구격조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('건물', JosaOption.eurosseoRosseo), equals('로써'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사', () {
      expect(josaPick('역삼동', JosaOption.eurobuteoRobuteo), equals('으로부터'));
      expect(josaPick('저기', JosaOption.eurobuteoRobuteo), equals('로부터'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('동굴', JosaOption.eurobuteoRobuteo), equals('로부터'));
    });

    test('영어로된 약어일 경우, 마지막 알파벳을 한국어로 바꾼뒤 조사를 붙인다.', () {
      expect(josa('URL', JosaOption.eulReul), equals('URL을'));
      expect(josa('CSS', JosaOption.eulReul), equals('CSS를'));

      expect(josa('URL', JosaOption.eunNeun), equals('URL은'));
      expect(josa('CSS', JosaOption.eunNeun), equals('CSS는'));

      expect(josa('URL', JosaOption.iGa), equals('URL이'));
      expect(josa('CSS', JosaOption.iGa), equals('CSS가'));

      expect(josa('URL', JosaOption.waGwa), equals('URL과'));
      expect(josa('CSS', JosaOption.waGwa), equals('CSS와'));

      expect(josa('URL', JosaOption.euroRo), equals('URL로'));

      expect(josa('URL', JosaOption.inaNa), equals('URL이나'));
      expect(josa('CSS', JosaOption.inaNa), equals('CSS나'));

      expect(josa('URL', JosaOption.iranRan), equals('URL이란'));
      expect(josa('CSS', JosaOption.iranRan), equals('CSS란'));

      expect(josa('URL', JosaOption.aYa), equals('URL아'));
      expect(josa('CSS', JosaOption.aYa), equals('CSS야'));

      expect(josa('URL', JosaOption.irangRang), equals('URL이랑'));
      expect(josa('CSS', JosaOption.irangRang), equals('CSS랑'));

      expect(josa('URL', JosaOption.ieyoYeyo), equals('URL이에요'));
      expect(josa('CSS', JosaOption.ieyoYeyo), equals('CSS예요'));
    });
  });

  group('JosaOption.tryParse', () {
    test('유효한 조사 쌍 문자열을 JosaOption 으로 변환한다.', () {
      expect(JosaOption.tryParse('이/가'), equals(JosaOption.iGa));
      expect(JosaOption.tryParse('을/를'), equals(JosaOption.eulReul));
      expect(JosaOption.tryParse('으로부터/로부터'), equals(JosaOption.eurobuteoRobuteo));
    });

    test('모든 JosaOption 은 toString 결과로 다시 파싱된다.', () {
      for (final option in JosaOption.values) {
        expect(JosaOption.tryParse(option.toString()), equals(option));
      }
    });

    test('유효하지 않은 조사 쌍이면 null 을 반환한다.', () {
      expect(JosaOption.tryParse('이/을'), isNull); // 앞뒤가 다른 쌍의 조합
      expect(JosaOption.tryParse('을/가'), isNull);
      expect(JosaOption.tryParse('가/이'), isNull); // 순서 뒤집힘
      expect(JosaOption.tryParse('을를'), isNull); // 구분자 없음
      expect(JosaOption.tryParse('을'), isNull); // 한쪽만
      expect(JosaOption.tryParse(''), isNull);
    });
  });

  group('JosaOption.parse', () {
    test('유효한 조사 쌍 문자열을 JosaOption 으로 변환한다.', () {
      expect(JosaOption.parse('을/를'), equals(JosaOption.eulReul));
    });

    test('유효하지 않은 조사 쌍이면 ArgumentError 를 던진다.', () {
      expect(() => JosaOption.parse('이/을'), throwsArgumentError);
      expect(() => JosaOption.parse('을를'), throwsArgumentError);
    });
  });
}
