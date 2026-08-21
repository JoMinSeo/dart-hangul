import 'package:unorm_dart/unorm_dart.dart' as unorm;

import '../_internal/constants.dart';

/// 단어에서 중성을 추출합니다.
///
/// [word] 중성을 추출할 단어
///
/// ```dart
/// getJungseong('사과'); // 'ㅏㅘ'
/// getJungseong('띄어 쓰기'); // 'ㅢㅓ ㅡㅣ'
/// getJungseong('ㅗㅏ'); // 'ㅗㅏ'
/// ```
String getJungseong(String word) {
  return unorm
      .nfd(word)
      .replaceAll(_extractJungseongRegex, '') // NFD ㅏ-ㅣ, NFC ㅏ-ㅣ 외 문자 삭제
      .replaceAllMapped(
        _chooseNfdJungseongRegex,
        (match) => _jungseongsComposite[match.group(0)!.codeUnitAt(0) - 0x1161],
      ); // NFD -> 합성 중성 문자
}

/// NFD 중성 시작/끝 문자
final _nfdJungseongStart = String.fromCharCode(jasoHangulNfd[1]); // ᅡ (U+1161)
final _nfdJungseongEnd = String.fromCharCode(jasoHangulNfd[4]); // ᅵ (U+1175)

/// 중성/모음/공백 외 문자 제거 정규식
final _extractJungseongRegex = RegExp('[^$_nfdJungseongStart-$_nfdJungseongEndㅏ-ㅣ\\s]+', unicode: true);

/// NFD 중성 매칭 정규식
final _chooseNfdJungseongRegex = RegExp('[$_nfdJungseongStart-$_nfdJungseongEnd]', unicode: true);

/// 합성 중성 목록 (ㅏ, ㅐ, ..., ㅣ) — 인덱스가 NFD 중성 오프셋과 일치
final _jungseongsComposite = disassembledVowelsByVowel.keys.toList();
