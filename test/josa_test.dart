import 'package:dart_hangul/src/core/josa.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('josa', () {
    test('주격조사', () {
      expect(josa('샴푸', JosaOption.iga), equals('샴푸가'));
      expect(josa('칫솔', JosaOption.iga), equals('칫솔이'));
    });

    test('목적격조사', () {
      expect(josa('샴푸', JosaOption.eulreul), equals('샴푸를'));
      expect(josa('칫솔', JosaOption.eulreul), equals('칫솔을'));
    });

    test('대조의 보조사', () {
      expect(josa('샴푸', JosaOption.eunneun), equals('샴푸는'));
      expect(josa('칫솔', JosaOption.eunneun), equals('칫솔은'));
    });

    test('방향의 격조사', () {
      expect(josa('바깥', JosaOption.eurolo), equals('바깥으로'));
      expect(josa('내부', JosaOption.eurolo), equals('내부로'));
    });

    test('방향의 격조사 ㄹ 받침 예외 처리', () {
      expect(josa('지름길', JosaOption.eurolo), equals('지름길로'));
    });

    test('비교의 격조사', () {
      expect(josa('샴푸', JosaOption.wagwa), equals('샴푸와'));
      expect(josa('칫솔', JosaOption.wagwa), equals('칫솔과'));
    });

    test('선택의 보조사', () {
      expect(josa('샴푸', JosaOption.inana), equals('샴푸나'));
      expect(josa('칫솔', JosaOption.inana), equals('칫솔이나'));
    });

    test('화제의 보조사', () {
      expect(josa('샴푸', JosaOption.iranran), equals('샴푸란'));
      expect(josa('칫솔', JosaOption.iranran), equals('칫솔이란'));
    });

    test('호격조사', () {
      expect(josa('철수', JosaOption.aya), equals('철수야'));
      expect(josa('길동', JosaOption.aya), equals('길동아'));
    });

    test('접속조사', () {
      expect(josa('고기', JosaOption.irangrang), equals('고기랑'));
      expect(josa('과일', JosaOption.irangrang), equals('과일이랑'));
    });

    test('주제의 보조사', () {
      expect(josa('의사', JosaOption.irara), equals('의사라'));
      expect(josa('선생님', JosaOption.irara), equals('선생님이라'));
    });

    test('서술격조사와 종결어미', () {
      expect(josa('사과', JosaOption.iyeyo), equals('사과예요'));
      expect(josa('책', JosaOption.iyeyo), equals('책이에요'));
    });

    test('서술격조사와 종결어미, "이" 로 끝나는 단어 예외 처리', () {
      expect(josa('때밀이', JosaOption.iyeyo), equals('때밀이예요'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사', () {
      expect(josa('학생', JosaOption.euroseoro), equals('학생으로서'));
      expect(josa('부모', JosaOption.euroseoro), equals('부모로서'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사 ㄹ 받침 예외 처리', () {
      expect(josa('라이벌', JosaOption.euroseoro), equals('라이벌로서'));
    });

    test('수단의 의미를 나타내는 도구격조사', () {
      expect(josa('토큰', JosaOption.eurosseorosseo), equals('토큰으로써'));
      expect(josa('함수', JosaOption.eurosseorosseo), equals('함수로써'));
    });

    test('수단의 의미를 나타내는 도구격조사 ㄹ 받침 예외 처리', () {
      expect(josa('건물', JosaOption.eurosseorosseo), equals('건물로써'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사', () {
      expect(josa('역삼동', JosaOption.eurobuteoro), equals('역삼동으로부터'));
      expect(josa('저기', JosaOption.eurobuteoro), equals('저기로부터'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사 ㄹ 받침 예외 처리', () {
      expect(josa('동굴', JosaOption.eurobuteoro), equals('동굴로부터'));
    });

    test('단어가 빈 문자열일 경우 빈 문자열을 반환한다.', () {
      expect(josa('', JosaOption.iga), equals(''));
    });
  });

  group('josaPick', () {
    test('첫 번째 매개변수가 빈 문자열이라면 옵션 중 첫 번째 값을 반환한다.', () {
      expect(josaPick('', JosaOption.iga), equals('이'));
    });

    test('주격조사', () {
      expect(josaPick('샴푸', JosaOption.iga), equals('가'));
      expect(josaPick('칫솔', JosaOption.iga), equals('이'));
    });

    test('목적격조사', () {
      expect(josaPick('샴푸', JosaOption.eulreul), equals('를'));
      expect(josaPick('칫솔', JosaOption.eulreul), equals('을'));
    });

    test('대조의 보조사', () {
      expect(josaPick('샴푸', JosaOption.eunneun), equals('는'));
      expect(josaPick('칫솔', JosaOption.eunneun), equals('은'));
    });

    test('방향의 격조사', () {
      expect(josaPick('바깥', JosaOption.eurolo), equals('으로'));
      expect(josaPick('내부', JosaOption.eurolo), equals('로'));
    });

    test('방향의 격조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('지름길', JosaOption.eurolo), equals('로'));
    });

    test('비교의 격조사', () {
      expect(josaPick('샴푸', JosaOption.wagwa), equals('와'));
      expect(josaPick('칫솔', JosaOption.wagwa), equals('과'));
    });

    test('선택의 보조사', () {
      expect(josaPick('샴푸', JosaOption.inana), equals('나'));
      expect(josaPick('칫솔', JosaOption.inana), equals('이나'));
    });

    test('화제의 보조사', () {
      expect(josaPick('샴푸', JosaOption.iranran), equals('란'));
      expect(josaPick('칫솔', JosaOption.iranran), equals('이란'));
    });

    test('호격조사', () {
      expect(josaPick('철수', JosaOption.aya), equals('야'));
      expect(josaPick('길동', JosaOption.aya), equals('아'));
    });

    test('접속조사', () {
      expect(josaPick('고기', JosaOption.irangrang), equals('랑'));
      expect(josaPick('과일', JosaOption.irangrang), equals('이랑'));
    });

    test('서술격조사와 종결어미', () {
      expect(josaPick('사과', JosaOption.iyeyo), equals('예요'));
      expect(josaPick('책', JosaOption.iyeyo), equals('이에요'));
    });

    test('서술격조사와 종결어미, "이" 로 끝나는 단어 예외 처리', () {
      expect(josaPick('때밀이', JosaOption.iyeyo), equals('예요'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사', () {
      expect(josaPick('학생', JosaOption.euroseoro), equals('으로서'));
      expect(josaPick('부모', JosaOption.euroseoro), equals('로서'));
    });

    test('지위나 신분 또는 자격을 나타내는 위격조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('라이벌', JosaOption.euroseoro), equals('로서'));
    });

    test('수단의 의미를 나타내는 도구격조사', () {
      expect(josaPick('토큰', JosaOption.eurosseorosseo), equals('으로써'));
      expect(josaPick('함수', JosaOption.eurosseorosseo), equals('로써'));
    });

    test('수단의 의미를 나타내는 도구격조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('건물', JosaOption.eurosseorosseo), equals('로써'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사', () {
      expect(josaPick('역삼동', JosaOption.eurobuteoro), equals('으로부터'));
      expect(josaPick('저기', JosaOption.eurobuteoro), equals('로부터'));
    });

    test('어떤 행동의 출발점이나 비롯되는 대상임을 나타내는 격 조사 ㄹ 받침 예외 처리', () {
      expect(josaPick('동굴', JosaOption.eurobuteoro), equals('로부터'));
    });

    test('영어로된 약어일 경우, 마지막 알파벳을 한국어로 바꾼뒤 조사를 붙인다.', () {
      expect(josa('URL', JosaOption.eulreul), equals('URL을'));
      expect(josa('CSS', JosaOption.eulreul), equals('CSS를'));

      expect(josa('URL', JosaOption.eunneun), equals('URL은'));
      expect(josa('CSS', JosaOption.eunneun), equals('CSS는'));

      expect(josa('URL', JosaOption.iga), equals('URL이'));
      expect(josa('CSS', JosaOption.iga), equals('CSS가'));

      expect(josa('URL', JosaOption.wagwa), equals('URL과'));
      expect(josa('CSS', JosaOption.wagwa), equals('CSS와'));

      expect(josa('URL', JosaOption.eurolo), equals('URL로'));

      expect(josa('URL', JosaOption.inana), equals('URL이나'));
      expect(josa('CSS', JosaOption.inana), equals('CSS나'));

      expect(josa('URL', JosaOption.iranran), equals('URL이란'));
      expect(josa('CSS', JosaOption.iranran), equals('CSS란'));

      expect(josa('URL', JosaOption.aya), equals('URL아'));
      expect(josa('CSS', JosaOption.aya), equals('CSS야'));

      expect(josa('URL', JosaOption.irangrang), equals('URL이랑'));
      expect(josa('CSS', JosaOption.irangrang), equals('CSS랑'));

      expect(josa('URL', JosaOption.iyeyo), equals('URL이에요'));
      expect(josa('CSS', JosaOption.iyeyo), equals('CSS예요'));
    });
  });
}
