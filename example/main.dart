// ignore_for_file: avoid_print
import 'package:dart_hangul/dart_hangul.dart';

void main() {
  print(disassemble('값')); // ㄱㅏㅂㅅ
  print(assemble(['ㅇ', 'ㅏ', 'ㅂ', 'ㅓ', 'ㅈ', 'ㅣ'])); // 아버지
  print(josa('사과', JosaOption.eulReul)); // 사과를
  print(josa('책', JosaOption.eulReul)); // 책을
  print(hasBatchim('값')); // true
  print(getChoseong('프론트엔드')); // ㅍㄹㅌㅇㄷ
  print(removeLastCharacter('프론트엔드')); // 프론트엔ㄷ
  print(numberToHangul(12345)); // 일만이천삼백사십오
  print(numberToHangulMixed(12345)); // 1만2,345
  print(susa(3, classifier: true)); // 세
  print(seosusa(12)); // 열두째
  print(days(11)); // 열하루
}
