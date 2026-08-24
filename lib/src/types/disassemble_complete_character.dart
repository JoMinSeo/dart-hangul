import 'choseong.dart';
import 'jongseong.dart';
import 'jungseong.dart';

/// `disassembleCompleteCharacter`의 반환 타입. 완성형 한 글자를 초성·중성·종성으로 나눈 결과입니다.
///
/// 중성·종성은 분해형이며(`ㅘ` → `'ㅗㅏ'`, `ㄳ` → `'ㄱㅅ'`), 종성이 없으면 빈 문자열입니다.
typedef DisassembleCompleteCharacterResult = ({Choseong choseong, Jungseong jungseong, Jongseong jongseong});
