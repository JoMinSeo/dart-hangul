import '../_internal/constants.dart';

/// 받침 종류
enum BatchimType {
  /// 홑받침 (ㄱ, ㄴ, ㄷ 등)
  single,

  /// 겹받침 (ㄳ, ㄵ, ㄺ 등)
  double,
}

/// 한글 문자열의 마지막 글자가 받침이 있는지 확인합니다.
///
/// [str] 글자에 받침이 있는지 확인하고 싶은 문자열
/// [only] 체크할 받침의 종류. 사용하지 않으면 둘 다 체크합니다.
///
/// ```dart
/// hasBatchim('값'); // true
/// hasBatchim('토'); // false
/// hasBatchim('갑', only: BatchimType.single); // true
/// hasBatchim('값', only: BatchimType.single); // false
/// hasBatchim('값', only: BatchimType.double); // true
/// hasBatchim('토', only: BatchimType.double); // false
/// ```
bool hasBatchim(String str, {BatchimType? only}) {
  if (str.isEmpty) {
    return false;
  }

  final lastChar = str[str.length - 1];
  final charCode = lastChar.codeUnitAt(0);

  final isNotCompleteHangul = charCode < completeHangulStartCharCode || charCode > completeHangulEndCharCode;

  if (isNotCompleteHangul) {
    return false;
  }

  final batchimCode = (charCode - completeHangulStartCharCode) % numberOfJongseong;
  final batchimLength = jongseongs[batchimCode].length;

  switch (only) {
    case BatchimType.single:
      return batchimLength == 1;
    case BatchimType.double:
      return batchimLength == 2;
    case null:
      return batchimCode > 0;
  }
}
