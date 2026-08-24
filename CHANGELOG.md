## 0.1.1

### 추가
- `JosaOption.tryParse` / `JosaOption.parse` — `'을/를'` 형식의 런타임 문자열(사용자 입력, 설정값 등)을 검증해 `JosaOption` 으로 변환. 유효하지 않은 쌍(`'이/을'`)은 `null` / `ArgumentError`. es-hangul 은 런타임 검증 없이 잘못된 쌍도 그대로 사용한다 — 의도적 차이.

### 문서
- 공개 API dartdoc 주석 보강 (`disassemble`, `disassembleToGroups`, `Choseong`/`Jungseong`/`Jongseong`, 라이브러리 doc)
- LICENSE 에 es-hangul (MIT, Viva Republica, Inc) 저작권 고지 추가

## 0.1.0

첫 릴리즈. [toss/es-hangul](https://github.com/toss/es-hangul) v2.4.0 의 `core`·`number` 모듈을 Dart 로 포팅했다. 순수 Dart 패키지 (Flutter 의존 없음).

### 추가
- 분해·조합: `disassemble`, `disassembleToGroups`, `disassembleCompleteCharacter`, `assemble`, `combineCharacter`, `combineVowels`, `removeLastCharacter`
- 판별·추출: `canBeChoseong`, `canBeJungseong`, `canBeJongseong`, `hasBatchim`, `isHangul`, `getChoseong`, `getJungseong`, `getJongseong`
- 조사: `josa`, `josaPick`, `JosaOption`
- 숫자: `numberToHangul`, `numberToHangulMixed`, `susa`, `seosusa`, `days`
- 타입: `Choseong`, `Jungseong`, `Jongseong` (extension type, `implements String`), `BatchimType`

### es-hangul 과 다른 점
- 옵션은 named parameter (`hasBatchim(s, only:)`, `getChoseong(s, keepNonHangul:)`, `susa(n, classifier:)`, `numberToHangul(n, spacing:)`)
- 조사는 문자열 대신 `JosaOption` enum (`JosaOption.eulReul` = 을/를)
- 오류는 `ArgumentError`
- `canBeJongseong`/`combineCharacter` 는 합성형 겹받침(`'ㄳ'`)도 분해형으로 정규화해 허용
- `keyboard`, `pronunciation` 모듈은 미포팅
