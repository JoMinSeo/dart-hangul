# dart_hangul

Dart/Flutter용 한글 처리 유틸리티. [toss/es-hangul](https://github.com/toss/es-hangul)의 Dart 포팅으로, 함수 이름과 동작이 원본을 따릅니다.

- 자모 분해·조합 — `disassemble`, `assemble`, `combineCharacter` …
- 조사 처리 — `josa('사과', JosaOption.waGwa)` → `'사과와'`
- 받침·초성 판별/추출 — `hasBatchim`, `getChoseong` …
- 숫자 → 한글 — `numberToHangul`, `susa`, `seosusa`, `days` …

순수 Dart 패키지입니다 (Flutter 의존 없음).

## 설치

아직 pub.dev 에 배포되지 않았습니다. git 의존으로 사용하세요.

```yaml
dependencies:
  dart_hangul:
    git: https://github.com/JoMinSeo/dart-hangul.git
```

## 사용

```dart
import 'package:dart_hangul/dart_hangul.dart';

disassemble('값');                              // 'ㄱㅏㅂㅅ'
disassembleToGroups('사과');                     // [['ㅅ','ㅏ'], ['ㄱ','ㅗ','ㅏ']]
assemble(['ㅇ', 'ㅏ', 'ㅂ', 'ㅓ', 'ㅈ', 'ㅣ']);    // '아버지'
combineCharacter('ㄱ', 'ㅏ', 'ㅂㅅ');              // '값'
removeLastCharacter('프론트엔드');                // '프론트엔ㄷ'

josa('사과', JosaOption.eulReul);                // '사과를'
josa('책', JosaOption.eulReul);                  // '책을'
josa('지름길', JosaOption.euroRo);               // '지름길로'  (ㄹ 받침 예외)
josa('URL', JosaOption.iGa);                     // 'URL이'    (영어 약어)
josaPick('사과', JosaOption.eulReul);            // '를'

hasBatchim('값');                                // true
hasBatchim('값', only: BatchimType.single);      // false (겹받침)
getChoseong('프론트엔드');                        // 'ㅍㄹㅌㅇㄷ'
getChoseong('네이버123', keepNonHangul: true);   // 'ㄴㅇㅂ123'
getJungseong('사과');                             // 'ㅏㅘ'
getJongseong('값');                               // 'ㅄ'

numberToHangul(12345);                           // '일만이천삼백사십오'
numberToHangul(12345, spacing: true);            // '일만 이천삼백사십오'
numberToHangulMixed(12345);                      // '1만2,345'
susa(3);                                         // '셋'
susa(3, classifier: true);                       // '세'
seosusa(12);                                     // '열두째'
days(11);                                        // '열하루'
```

## API

| 분류 | 함수 |
|---|---|
| 분해 | `disassemble`, `disassembleToGroups`, `disassembleCompleteCharacter`, `removeLastCharacter` |
| 조합 | `assemble`, `combineCharacter`, `combineVowels` |
| 판별 | `canBeChoseong`, `canBeJungseong`, `canBeJongseong`, `hasBatchim`, `isHangul` |
| 추출 | `getChoseong`, `getJungseong`, `getJongseong` |
| 조사 | `josa`, `josaPick`, `JosaOption` |
| 숫자 | `numberToHangul`, `numberToHangulMixed`, `susa`, `seosusa`, `days` |
| 타입 | `Choseong`, `Jungseong`, `Jongseong` (extension type, String 으로 사용 가능), `BatchimType` |

### es-hangul 과 다른 점

- 옵션은 JS 객체 대신 named parameter — `hasBatchim(s, only: BatchimType.single)`, `getChoseong(s, keepNonHangul: true)`, `susa(n, classifier: true)`, `numberToHangul(n, spacing: true)`
- 조사는 문자열 `'을/를'` 대신 enum `JosaOption.eulReul` — 이름 규칙: 앞 형태 로마자 + 뒤 형태 로마자(첫 글자 대문자). `iGa` 이/가, `eulReul` 을/를, `eunNeun` 은/는, `euroRo` 으로/로, `waGwa` 와/과, `inaNa` 이나/나, `iranRan` 이란/란, `aYa` 아/야, `irangRang` 이랑/랑, `ieyoYeyo` 이에요/예요, `euroseoRoseo` 으로서/로서, `eurosseoRosseo` 으로써/로써, `eurobuteoRobuteo` 으로부터/로부터, `iraRa` 이라/라
- `canBeJongseong`/`combineCharacter`는 합성형 겹받침(`'ㄳ'`, `'ㅄ'`)도 받아 분해형으로 정규화한다 (es-hangul 은 분해형 `'ㄱㅅ'`만 허용)
- 잘못된 입력은 `ArgumentError`
- `keyboard`(QWERTY 변환), `pronunciation`(표준 발음·로마자) 모듈은 미포팅

## License

[MIT](LICENSE)
