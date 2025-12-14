import 'package:unorm_dart/unorm_dart.dart' as unorm;

import '../_internal/constants.dart';

/// 단어에서 초성을 추출합니다.
///
/// [word] 초성을 추출할 단어
///
/// ```dart
/// getChoseong('사과'); // 'ㅅㄱ'
/// getChoseong('띄어 쓰기'); // 'ㄸㅇ ㅆㄱ'
/// getChoseong('ㄴㅈ'); // 'ㄴㅈ'
/// ```
String getChoseong(String word) {
  return unorm
      .nfd(word)
      .replaceAll(_extractChoseongRegex, '') // NFD ㄱ-ㅎ, NFC ㄱ-ㅎ 외 문자 삭제
      .replaceAllMapped(
        _chooseNfdChoseongRegex,
        (match) => choseongs[match.group(0)!.codeUnitAt(0) - 0x1100],
      ); // NFD to NFC
}

/// NFD 초성 시작/끝 문자
final _nfdChoseongStart = String.fromCharCode(jasoHangulNfd[0]); // ᄀ (U+1100)
final _nfdChoseongEnd = String.fromCharCode(jasoHangulNfd[3]); // ᄒ (U+1112)

/// 초성/자음/공백 외 문자 제거 정규식
final _extractChoseongRegex = RegExp('[^$_nfdChoseongStart-$_nfdChoseongEndㄱ-ㅎ\\s]+', unicode: true);

/// NFD 초성 매칭 정규식
final _chooseNfdChoseongRegex = RegExp('[$_nfdChoseongStart-$_nfdChoseongEnd]', unicode: true);
