import 'package:unorm_dart/unorm_dart.dart' as unorm;

import '../_internal/constants.dart';

/// 단어에서 초성을 추출합니다.
///
/// [word] 초성을 추출할 단어
/// [keepNonHangul] `true`이면 한글 외 문자(숫자, 영문 등)를 그대로 둡니다.
/// 기본값 `false`는 초성·호환 자모·공백만 남기고 나머지는 제거합니다.
///
/// ```dart
/// getChoseong('사과'); // 'ㅅㄱ'
/// getChoseong('띄어 쓰기'); // 'ㄸㅇ ㅆㄱ'
/// getChoseong('ㄴㅈ'); // 'ㄴㅈ'
/// getChoseong('네이버123'); // 'ㄴㅇㅂ'
/// getChoseong('네이버123', keepNonHangul: true); // 'ㄴㅇㅂ123'
/// ```
String getChoseong(String word, {bool keepNonHangul = false}) {
  final nfd = unorm.nfd(word);
  final choseongOnly =
      keepNonHangul
          ? nfd.replaceAll(_removeNfdJungJongRegex, '') // NFD 중성·종성만 삭제
          : nfd.replaceAll(_extractChoseongRegex, ''); // NFD ㄱ-ㅎ, NFC ㄱ-ㅎ 외 문자 삭제

  return choseongOnly.replaceAllMapped(
    _chooseNfdChoseongRegex,
    (match) => choseongs[match.group(0)!.codeUnitAt(0) - 0x1100],
  ); // NFD to NFC
}

/// NFD 초성/중성/종성 시작/끝 문자
final _nfdChoseongStart = String.fromCharCode(jasoHangulNfd[0]); // ᄀ (U+1100)
final _nfdJungseongStart = String.fromCharCode(jasoHangulNfd[1]); // ᅡ (U+1161)
final _nfdJongseongStart = String.fromCharCode(jasoHangulNfd[2]); // ᆨ (U+11A8)
final _nfdChoseongEnd = String.fromCharCode(jasoHangulNfd[3]); // ᄒ (U+1112)
final _nfdJungseongEnd = String.fromCharCode(jasoHangulNfd[4]); // ᅵ (U+1175)
final _nfdJongseongEnd = String.fromCharCode(jasoHangulNfd[5]); // ᇂ (U+11C2)

/// 초성/자음/공백 외 문자 제거 정규식
final _extractChoseongRegex = RegExp('[^$_nfdChoseongStart-$_nfdChoseongEndㄱ-ㅎ\\s]+', unicode: true);

/// NFD 초성 매칭 정규식
final _chooseNfdChoseongRegex = RegExp('[$_nfdChoseongStart-$_nfdChoseongEnd]', unicode: true);

/// NFD 중성·종성 제거 정규식 (keepNonHangul 용)
final _removeNfdJungJongRegex = RegExp(
  '[$_nfdJungseongStart-$_nfdJungseongEnd$_nfdJongseongStart-$_nfdJongseongEnd]+',
  unicode: true,
);
