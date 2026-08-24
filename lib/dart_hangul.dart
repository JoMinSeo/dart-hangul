/// 한글 자모 분해·조합, 조사 처리, 받침·초성 추출, 숫자 한글 변환 유틸리티.
///
/// [toss/es-hangul](https://github.com/toss/es-hangul)의 Dart 포팅으로,
/// 함수 이름과 동작이 원본을 따릅니다.
library;

export 'src/_internal/hangul.dart' show isHangul;
export 'src/core/assemble.dart';
export 'src/core/can_be_choseong.dart';
export 'src/core/can_be_jongseong.dart';
export 'src/core/can_be_jungseong.dart';
export 'src/core/combine_character.dart';
export 'src/core/combine_vowels.dart';
export 'src/core/disassemble.dart';
export 'src/core/disassemble_complete_character.dart';
export 'src/core/disassemble_to_groups.dart';
export 'src/core/get_choseong.dart';
export 'src/core/get_jongseong.dart';
export 'src/core/get_jungseong.dart';
export 'src/core/has_batchim.dart';
export 'src/core/josa.dart';
export 'src/core/remove_last_character.dart';
export 'src/number/days.dart';
export 'src/number/number_to_hangul.dart';
export 'src/number/number_to_hangul_mixed.dart';
export 'src/number/seosusa.dart';
export 'src/number/susa.dart';
export 'src/types/choseong.dart';
export 'src/types/disassemble_complete_character.dart';
export 'src/types/jongseong.dart';
export 'src/types/jungseong.dart';
