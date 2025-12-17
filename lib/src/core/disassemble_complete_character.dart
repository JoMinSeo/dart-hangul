import '../_internal/constants.dart';
import '../types/choseong.dart';
import '../types/disassemble_complete_character.dart';
import '../types/jongseong.dart';
import '../types/jungseong.dart';

/// 완성형 한글(가~힣) 1글자를 초성/중성/종성으로 분리합니다.
///
/// ```dart
/// disassembleCompleteCharacter('값'); // (choseong: ㄱ, jungseong: ㅏ, jongseong: ㅂㅅ)
/// disassembleCompleteCharacter('리'); // (choseong: ㄹ, jungseong: ㅣ, jongseong: '')
/// disassembleCompleteCharacter('빚'); // (choseong: ㅂ, jungseong: ㅣ, jongseong: ㅈ)
/// disassembleCompleteCharacter('박'); // (choseong: ㅂ, jungseong: ㅏ, jongseong: ㄱ)
/// ```
///
/// 대상이 완성형 한글이 아니면 `null`을 반환합니다.
DisassembleCompleteCharacterResult? disassembleCompleteCharacter(String letter) {
  if (letter.isEmpty) return null;

  final charCode = letter.codeUnitAt(0);
  final isCompleteHangul = completeHangulStartCharCode <= charCode && charCode <= completeHangulEndCharCode;
  if (!isCompleteHangul) return null;

  final hangulCode = charCode - completeHangulStartCharCode;

  final jongseongIndex = hangulCode % numberOfJongseong;
  final jungseongIndex = ((hangulCode - jongseongIndex) ~/ numberOfJongseong) % numberOfJungseong;
  final choseongIndex = ((hangulCode - jongseongIndex) ~/ (numberOfJongseong * numberOfJungseong));

  return (
    choseong: Choseong(choseongs[choseongIndex]),
    jungseong: Jungseong(jungseongs[jungseongIndex]),
    jongseong: Jongseong(jongseongs[jongseongIndex]),
  );
}
