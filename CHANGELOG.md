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
