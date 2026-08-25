final _hangulString = RegExp(r'^[가-힣ㄱ-ㅣ\s]+$');

/// 완성형 한글·자모·공백으로만 이루어진 문자열인지 검사합니다. 빈 문자열은 `false`.
///
/// ```dart
/// isHangul('값'); // true
/// isHangul('저는 고양이를 좋아합니다'); // true
/// isHangul('a'); // false
/// ```
bool isHangul(String str) => _hangulString.hasMatch(str);
