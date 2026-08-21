import "package:unorm_dart/unorm_dart.dart" as unorm;

final List<int> jasoHangulNfd =
    unorm.nfd('각힣').split('').map((char) => char.codeUnitAt(0)).toList(); // NFC 에 정의되지 않은 문자는 포함하지 않음

final int completeHangulStartCharCode = '가'.codeUnitAt(0);
final int completeHangulEndCharCode = '힣'.codeUnitAt(0);

const int numberOfJongseong = 28;
const int numberOfJungseong = 21;

/// ㄱ -> 'ㄱ'
/// ㄳ -> 'ㄱㅅ' 으로 나눈다.
const Map<String, String> disassembledConsonantsByConsonant = {
  // 종성이 없는 경우 '빈' 초성으로 관리하는 것이 편리하여, 빈 문자열도 포함한다.
  '': '',
  'ㄱ': 'ㄱ',
  'ㄲ': 'ㄲ',
  'ㄳ': 'ㄱㅅ',
  'ㄴ': 'ㄴ',
  'ㄵ': 'ㄴㅈ',
  'ㄶ': 'ㄴㅎ',
  'ㄷ': 'ㄷ',
  'ㄸ': 'ㄸ',
  'ㄹ': 'ㄹ',
  'ㄺ': 'ㄹㄱ',
  'ㄻ': 'ㄹㅁ',
  'ㄼ': 'ㄹㅂ',
  'ㄽ': 'ㄹㅅ',
  'ㄾ': 'ㄹㅌ',
  'ㄿ': 'ㄹㅍ',
  'ㅀ': 'ㄹㅎ',
  'ㅁ': 'ㅁ',
  'ㅂ': 'ㅂ',
  'ㅃ': 'ㅃ',
  'ㅄ': 'ㅂㅅ',
  'ㅅ': 'ㅅ',
  'ㅆ': 'ㅆ',
  'ㅇ': 'ㅇ',
  'ㅈ': 'ㅈ',
  'ㅉ': 'ㅉ',
  'ㅊ': 'ㅊ',
  'ㅋ': 'ㅋ',
  'ㅌ': 'ㅌ',
  'ㅍ': 'ㅍ',
  'ㅎ': 'ㅎ',
};

const Map<String, String> disassembledVowelsByVowel = {
  'ㅏ': 'ㅏ',
  'ㅐ': 'ㅐ',
  'ㅑ': 'ㅑ',
  'ㅒ': 'ㅒ',
  'ㅓ': 'ㅓ',
  'ㅔ': 'ㅔ',
  'ㅕ': 'ㅕ',
  'ㅖ': 'ㅖ',
  'ㅗ': 'ㅗ',
  'ㅘ': 'ㅗㅏ',
  'ㅙ': 'ㅗㅐ',
  'ㅚ': 'ㅗㅣ',
  'ㅛ': 'ㅛ',
  'ㅜ': 'ㅜ',
  'ㅝ': 'ㅜㅓ',
  'ㅞ': 'ㅜㅔ',
  'ㅟ': 'ㅜㅣ',
  'ㅠ': 'ㅠ',
  'ㅡ': 'ㅡ',
  'ㅢ': 'ㅡㅣ',
  'ㅣ': 'ㅣ',
};

/// 초성으로 올 수 있는 한글 글자
const List<String> choseongs = [
  'ㄱ',
  'ㄲ',
  'ㄴ',
  'ㄷ',
  'ㄸ',
  'ㄹ',
  'ㅁ',
  'ㅂ',
  'ㅃ',
  'ㅅ',
  'ㅆ',
  'ㅇ',
  'ㅈ',
  'ㅉ',
  'ㅊ',
  'ㅋ',
  'ㅌ',
  'ㅍ',
  'ㅎ',
];

/// 중성으로 올 수 있는 한글 글자
final List<String> jungseongs = disassembledVowelsByVowel.values.toList();

/// 종성으로 올 수 있는 한글 글자
final List<String> jongseongs =
    [
      '',
      'ㄱ',
      'ㄲ',
      'ㄳ',
      'ㄴ',
      'ㄵ',
      'ㄶ',
      'ㄷ',
      'ㄹ',
      'ㄺ',
      'ㄻ',
      'ㄼ',
      'ㄽ',
      'ㄾ',
      'ㄿ',
      'ㅀ',
      'ㅁ',
      'ㅂ',
      'ㅄ',
      'ㅅ',
      'ㅆ',
      'ㅇ',
      'ㅈ',
      'ㅊ',
      'ㅋ',
      'ㅌ',
      'ㅍ',
      'ㅎ',
    ].map((consonant) => disassembledConsonantsByConsonant[consonant]!).toList();

const Map<String, String> alphabetToKorean = {
  'A': '에이',
  'B': '비',
  'C': '씨',
  'D': '디',
  'E': '이',
  'F': '에프',
  'G': '지',
  'H': '에이치',
  'I': '아이',
  'J': '제이',
  'K': '케이',
  'L': '엘',
  'M': '엠',
  'N': '엔',
  'O': '오',
  'P': '피',
  'Q': '큐',
  'R': '알',
  'S': '에스',
  'T': '티',
  'U': '유',
  'V': '브이',
  'W': '더블유',
  'X': '엑스',
  'Y': '와이',
  'Z': '지',
};

/// 만 단위 자릿수 이름 — 인덱스 = 4자리 묶음 순서 (0: 일의 자리 묶음, 1: 만, 2: 억, ...)
const List<String> hangulDigits = [
  '',
  '만',
  '억',
  '조',
  '경',
  '해',
  '자',
  '양',
  '구',
  '간',
  '정',
  '재',
  '극',
  '항하사',
  '아승기',
  '나유타',
  '불가사의',
  '무량대수',
  '겁',
  '업',
];

/// 한자어 숫자 (0은 빈 문자열 — 정수부에서 0은 읽지 않음)
const List<String> hangulNumbers = ['', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];

/// 소수부용 한자어 숫자 (0을 '영'으로 읽음)
const List<String> hangulNumbersForDecimal = ['영', '일', '이', '삼', '사', '오', '육', '칠', '팔', '구'];

/// 천 이하 자릿수 이름 — 인덱스 = 10의 거듭제곱
const List<String> hangulCardinal = ['', '십', '백', '천'];
