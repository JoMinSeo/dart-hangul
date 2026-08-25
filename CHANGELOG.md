## 0.2.0

### Breaking
- `JosaOption` → `Josa` 이름 변경. 멤버·동작 동일. (#15)
- `Josa.first`/`second` → `afterBatchim`/`afterVowel` (+ ㄹ 받침 예외용 `afterRieul`). 와/과 뒤집기·ㄹ 예외 집합이 `josaPick` 의 분기에서 enum 데이터로 이동. (#14)
- `Choseong`/`Jungseong`/`Jongseong` 의 공개 생성자 제거 — `tryParse` / `fromIndex` 로만 생성. `Jongseong('ㅄ').index == -1` 처럼 "저장값은 항상 분해형" 불변식을 우회하던 경로 차단. (#14)
- `isHangul(Object?)` → `isHangul(String)`. (#14)

### 추가
- `Josa.pick(word)` — 단어 뒤에 붙을 조사 형태를 고른다. `josaPick` 은 이 위임. (#14)
- `Choseong.fromIndex` / `Jungseong.fromIndex` / `Jongseong.fromIndex` — `index` 의 역연산. `index` 는 O(1). (#14)

### 수정
- `removeLastCharacter('가😀')` 가 이모지의 상위 서로게이트만 남긴 깨진 문자열을 반환하던 문제. `hasBatchim`/`assemble` 도 코드포인트 단위로 순회. (#12)

### 변경
- `days`/`susa`/`seosusa` 의 범위 오류는 `RangeError` (`ArgumentError` 의 하위 타입이라 기존 catch 유지). NaN 은 `ArgumentError.value`. (#13)
- `assemble` 이 `Iterable<String>` 을 받는다. (#13)
- 자모 테이블(`jungseongs`/`jongseongs`)을 `const` 로. 내부 `_internal/hangul.dart` 를 `core/assemble.dart` 로 흡수, `isHangul` 은 `core/is_hangul.dart`. (#13, #14)

### 문서
- README 를 pub.dev 공개용으로 재작성 — es-hangul 에서 영감을 받아 Dart 에 맞게 재설계했다는 포지셔닝, 설치·설계 절. (#16)
- pubspec description 에서 "포팅" 표현 제거.

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
