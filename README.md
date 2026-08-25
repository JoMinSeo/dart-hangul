# dart_hangul

[![pub package](https://img.shields.io/pub/v/dart_hangul.svg)](https://pub.dev/packages/dart_hangul)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Dart/Flutter 를 위한 한글 처리 라이브러리. 자모 분해·조합, 조사 자동 선택, 받침·초성 추출, 숫자 한글 변환을 순수 Dart 로 제공합니다.

[toss/es-hangul](https://github.com/toss/es-hangul) 의 잘 정리된 API 설계에서 영감을 받아, 검증된 함수 이름과 동작을 참고하되 Dart 의 타입 시스템(named parameter, enum, extension type)에 맞게 다시 설계했습니다.

## 특징

- **순수 Dart** — Flutter 의존 없음. 모바일·웹·서버·CLI 어디서나 사용
- **타입 안전** — 조사는 `Josa` enum, 자모는 `Choseong`/`Jungseong`/`Jongseong` extension type. 잘못된 조합은 컴파일 타임에 차단
- **명확한 실패** — 잘못된 입력은 조용히 넘어가지 않고 `ArgumentError`
- **가벼운 의존성** — 외부 의존은 NFD 정규화용 `unorm_dart` 하나

## 설치

```sh
dart pub add dart_hangul      # Flutter 프로젝트는 flutter pub add dart_hangul
```

## 사용

```dart
import 'package:dart_hangul/dart_hangul.dart';
```

### 자모 분해·조합

```dart
disassemble('값');                              // 'ㄱㅏㅂㅅ'
disassembleToGroups('사과');                     // [['ㅅ','ㅏ'], ['ㄱ','ㅗ','ㅏ']]
disassembleCompleteCharacter('값');              // (choseong: 'ㄱ', jungseong: 'ㅏ', jongseong: 'ㅂㅅ')
assemble(['ㅇ', 'ㅏ', 'ㅂ', 'ㅓ', 'ㅈ', 'ㅣ']);    // '아버지'
combineCharacter('ㄱ', 'ㅏ', 'ㅂㅅ');              // '값'
combineVowels('ㅗ', 'ㅏ');                        // 'ㅘ'
removeLastCharacter('프론트엔드');                // '프론트엔ㄷ'
```

### 조사

받침 유무에 따라 알맞은 조사를 골라 붙입니다. `으로/로` 의 ㄹ 받침 예외, 대문자 영어 약어의 발음도 처리합니다.

```dart
josa('사과', Josa.eulReul);                // '사과를'
josa('책', Josa.eulReul);                  // '책을'
josa('지름길', Josa.euroRo);               // '지름길로'  (ㄹ 받침 예외)
josa('URL', Josa.iGa);                     // 'URL이'    (영어 약어)
Josa.eulReul.pick('사과');                 // '를'  — 조사만 고른다 (josaPick 과 같음)

// 사용자 입력·설정값 같은 런타임 문자열은 tryParse/parse 로 검증
Josa.tryParse('을/를');                    // Josa.eulReul
Josa.tryParse('이/을');                    // null (유효하지 않은 쌍)
```

### 받침·초성·중성·종성

```dart
hasBatchim('값');                                // true
hasBatchim('값', only: BatchimType.single);      // false (겹받침)
getChoseong('프론트엔드');                        // 'ㅍㄹㅌㅇㄷ'
getChoseong('네이버123', keepNonHangul: true);   // 'ㄴㅇㅂ123'
getJungseong('사과');                             // 'ㅏㅘ'
getJongseong('값');                               // 'ㅄ'
```

### 숫자 → 한글

```dart
numberToHangul(12345);                           // '일만이천삼백사십오'
numberToHangul(12345, spacing: true);            // '일만 이천삼백사십오'
numberToHangulMixed(12345);                      // '1만2,345'
susa(3);                                         // '셋'
susa(3, classifier: true);                       // '세'   (세 개, 세 명)
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
| 조사 | `josa`, `josaPick`, `Josa` |
| 숫자 | `numberToHangul`, `numberToHangulMixed`, `susa`, `seosusa`, `days` |
| 타입 | `Choseong`, `Jungseong`, `Jongseong` (extension type, `String` 으로 그대로 사용 가능. `tryParse`/`fromIndex` 로만 생성), `BatchimType` |

전체 시그니처와 동작은 [API 문서](https://pub.dev/documentation/dart_hangul/latest/) 를 참고하세요.

## 설계

### 옵션은 named parameter

`hasBatchim(s, only: BatchimType.single)`, `getChoseong(s, keepNonHangul: true)`, `susa(n, classifier: true)`, `numberToHangul(n, spacing: true)` 처럼 옵션 객체 대신 named parameter 를 씁니다.

### 조사는 enum

`'을/를'` 같은 문자열 대신 `Josa.eulReul` 을 받습니다. `'이/을'` 같은 잘못된 쌍은 컴파일 타임에 걸러지고, 런타임 문자열은 `Josa.tryParse` / `parse` 로 검증합니다.

어떤 형태를 붙일지는 `Josa.pick` 이 정합니다 — 받침 유무, `으로/로` 계열의 ㄹ 받침 예외가 모두 enum 의 데이터(`afterBatchim`/`afterVowel`/`afterRieul`)로 들어 있어 별도 분기가 없습니다.

이름은 **앞 형태 로마자 + 뒤 형태 로마자(첫 글자 대문자)** 규칙을 따릅니다. `toString()` 은 `'을/를'` 형식입니다.

| enum | 조사 | enum | 조사 |
|---|---|---|---|
| `iGa` | 이/가 | `iranRan` | 이란/란 |
| `eulReul` | 을/를 | `aYa` | 아/야 |
| `eunNeun` | 은/는 | `irangRang` | 이랑/랑 |
| `euroRo` | 으로/로 | `ieyoYeyo` | 이에요/예요 |
| `waGwa` | 와/과 | `euroseoRoseo` | 으로서/로서 |
| `inaNa` | 이나/나 | `eurosseoRosseo` | 으로써/로써 |
| `iraRa` | 이라/라 | `eurobuteoRobuteo` | 으로부터/로부터 |

### 자모는 분해형으로 다룬다

중성·종성의 정규 표현은 분해된 문자열입니다 — `ㅘ` 는 `'ㅗㅏ'`, `ㄳ` 은 `'ㄱㅅ'`. 합성형 입력(`'ㅘ'`, `'ㄳ'`)도 받아 분해형으로 정규화하므로, `combineCharacter('ㄱ', 'ㅏ', 'ㅄ')` 과 `combineCharacter('ㄱ', 'ㅏ', 'ㅂㅅ')` 은 같습니다.

`Choseong`/`Jungseong`/`Jongseong` 은 `tryParse`(정규화)·`fromIndex`(테이블 인덱스, `index` 의 역연산) 로만 만들 수 있어 저장값이 항상 유효한 분해형입니다.

### 잘못된 입력은 예외

지원하지 않는 값(예: 초성 자리에 모음)은 `ArgumentError`, 범위 밖 숫자(`susa(101)`)는 `RangeError` 를 던집니다. 조용히 넘어가지 않습니다.

## es-hangul 과의 관계

이 패키지는 [toss/es-hangul](https://github.com/toss/es-hangul) 에서 영감을 받았습니다. 함수 이름과 핵심 동작, 테스트 케이스 상당수를 es-hangul 을 기준으로 참고했으며, 그 위에 Dart 에 맞는 API 를 설계했습니다. es-hangul 의 저작권 고지는 [LICENSE](LICENSE) 에 포함되어 있습니다.

- **포함**: `core`(분해·조합·판별·추출·조사), `number`(숫자 한글 변환) 에 해당하는 기능
- **미포함**: `keyboard`(QWERTY ↔ 한글), `pronunciation`(표준 발음·로마자 표기) — 필요에 따라 추가를 검토합니다

동작이 다른 부분은 의도적인 것이며 위 [설계](#설계) 절에 정리되어 있습니다.

## 기여

버그 제보와 기능 제안은 [이슈](https://github.com/JoMinSeo/dart-hangul/issues) 로, 변경은 PR 로 보내주세요.

```sh
dart test
dart analyze
dart format --line-length 120 .
```

## License

[MIT](LICENSE)
