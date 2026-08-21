import 'package:unorm_dart/unorm_dart.dart' as unorm;

import '../_internal/constants.dart';

/// 단어에서 종성을 추출합니다.
///
/// [word] 종성을 추출할 단어
///
/// ```dart
/// getJongseong('값'); // 'ㅄ'
/// getJongseong('사람'); // 'ㅁ'
/// getJongseong('사과'); // ''
/// getJongseong('띄어 쓰기'); // ' '
/// ```
String getJongseong(String word) {
  return unorm
      .nfd(word)
      .replaceAll(_extractJongseongRegex, '') // NFD 종성, 공백 외 문자 삭제
      .replaceAllMapped(
        _chooseNfdJongseongRegex,
        (match) => _jongseongsComposite[match.group(0)!.codeUnitAt(0) - 0x11a8],
      ); // NFD -> 합성 종성 문자
}

/// NFD 종성 시작/끝 문자
final _nfdJongseongStart = String.fromCharCode(jasoHangulNfd[2]); // ᆨ (U+11A8)
final _nfdJongseongEnd = String.fromCharCode(jasoHangulNfd[5]); // ᇂ (U+11C2)

/// 종성/공백 외 문자 제거 정규식
final _extractJongseongRegex = RegExp('[^$_nfdJongseongStart-$_nfdJongseongEnd\\s]+', unicode: true);

/// NFD 종성 매칭 정규식
final _chooseNfdJongseongRegex = RegExp('[$_nfdJongseongStart-$_nfdJongseongEnd]', unicode: true);

/// 합성 종성 목록 (ㄱ, ㄲ, ㄳ, ..., ㅎ) — 인덱스가 NFD 종성 오프셋과 일치
final _jongseongsComposite = () {
  final compositeByDisassembled = {for (final e in disassembledConsonantsByConsonant.entries) e.value: e.key};
  return jongseongs.skip(1).map((d) => compositeByDisassembled[d]!).toList();
}();
