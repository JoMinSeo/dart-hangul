# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 개요

Dart/Flutter용 한글 처리 유틸리티 패키지. [es-hangul](https://github.com/toss/es-hangul)(TypeScript)의 포팅으로, 함수명·동작·테스트 케이스가 원본을 따른다. 새 함수를 추가하거나 동작이 애매할 때는 es-hangul의 동일 함수를 기준으로 삼을 것.

`Agents.md`(gitignore됨, 로컬 전용)에 API 표와 알고리즘 설명이 있다. 있으면 참고하되, clone 환경에는 없을 수 있다.

## 명령어

```bash
dart pub get
dart test                                      # 전체 테스트
dart test test/src/core/josa_test.dart         # 파일 단위
dart test test/src/core/josa_test.dart --plain-name '주격조사'   # 단일 테스트
dart analyze
dart format --line-length 120 .                # 포맷
```

- 순수 Dart 패키지다 (`flutter` 의존 없음, dev 의존은 `test`/`lints`). `flutter test`가 아니라 `dart test`.
- **포맷 line length는 120**이다. 기본값(80)으로 `dart format`을 돌리면 15개 파일이 바뀌니 반드시 `--line-length 120`.
- `dart analyze`는 0 issues 가 기준이다.

## 구조

```
lib/dart_hangul.dart        # 배럴 — core/number/types + isHangul 만 export. _internal/ 은 비공개 (hangul.dart 는 `show isHangul`)
lib/src/types/              # extension type Choseong/Jungseong/Jongseong (String 래핑, implements String, tryParse/index)
lib/src/_internal/constants.dart  # 자모 테이블 (choseongs/jungseongs/jongseongs, 분해 맵, alphabetToKorean), 숫자 상수, NFD 경계
lib/src/_internal/hangul.dart     # 조합 엔진: binaryAssemble*, linkHangulCharacters, isHangul*
lib/src/_internal/utils.dart      # excludeLastElement, splitNumberString
lib/src/core/               # 공개 함수 1개 = 파일 1개
lib/src/number/             # 숫자 → 한글 (numberToHangul, numberToHangulMixed, susa, seosusa, days), 함수별 상수는 파일 내 private
test/src/                   # lib/src와 1:1 미러, package:dart_hangul/src/... 직접 import
```

의존 방향: `core/assemble.dart` → `_internal/hangul.dart` → `core/{combine_character,can_be_*,disassemble_to_groups,...}` → `types/` → `constants.dart`. `_internal/hangul.dart`가 core 위에 얹힌 조합 엔진이고, `assemble`만 다시 그걸 쓴다.

### 핵심 불변식: 자모는 "분해형" 문자열로 다룬다

- 중성/종성의 정규 표현은 **분해된 다중 문자**다: `ㅘ`→`'ㅗㅏ'`, `ㄳ`→`'ㄱㅅ'`, 종성 없음→`''`.
- `jungseongs`(21)/`jongseongs`(28) 리스트가 이 분해형으로 정의되어 있고, 리스트 **인덱스가 곧 유니코드 오프셋**이다: `0xAC00 + 초성idx×21×28 + 중성idx×28 + 종성idx`. 리스트 순서를 바꾸면 조합/분해가 전부 깨진다.
- `Jungseong.tryParse`/`Jongseong.tryParse` 모두 합성형(`ㅘ`, `ㄳ`)을 분해형(`'ㅗㅏ'`, `'ㄱㅅ'`)으로 정규화한다. 저장값은 항상 분해형이다. (es-hangul은 종성을 정규화하지 않아 `canBeJongseong('ㄳ')`가 false — 의도적 차이)
- `disassembleToGroups`가 분해의 원시 함수. `disassemble`은 그걸 flat join, `assemble`은 입력을 전부 분해한 뒤 `binaryAssemble`로 left-fold.
- `canBeJungseong('ㅗㅏ')`, `canBeJongseong('ㄱㅅ')`처럼 2글자 문자열을 받는 게 정상이다.

### 기타

- `josa`: `hasBatchim`으로 이/가 계열 선택 + `으로/로` 계열은 ㄹ받침 예외 + 대문자 영어 약어는 `alphabetToKorean`으로 마지막 글자 발음을 치환해 판정.
- `getChoseong`/`getJungseong`/`getJongseong`은 `unorm_dart` NFD 분해를 쓴다 (유일한 외부 의존).
- `JosaOption` 이름 규칙: 앞 형태 로마자 + 뒤 형태 로마자(첫 글자 대문자) — `eulReul`=을/를, `euroRo`=으로/로. `toString()`은 `'을/를'`.

## Git Workflow (GitHub Flow)

이 리포는 GitHub Flow 로 관리한다. **main 에 직접 커밋·push 하지 않는다** —
브랜치 보호가 없으므로 이 규칙이 유일한 방어선이다.

1. **작업 시작**: 최신 main 에서 브랜치를 만든다.
   ```bash
   git checkout main && git pull origin main
   git checkout -b <type>/<설명적-브랜치명>   # 예: feat/josa-option-추가, fix/remove-last-character-공백, release/v0.1.0
   ```
2. **커밋**: `type: 한국어 설명` 형식 (`feat:`, `fix:`, `refactor:`, `chore:`, `test:`, `docs:`).
3. **push + PR**: 브랜치를 push 하고 `gh pr create` 로 main 대상 PR 을 만든다.
   PR 제목은 커밋과 같은 `type: 한국어 설명` 형식. 본문에는 변경 이유와 영향 범위
   (어떤 함수의 입출력이 어떻게 바뀌는지, es-hangul 과의 차이가 생기는지)를 적는다.
4. **공유**: PR 링크를 사용자에게 보여준다. **merge 는 사용자가 GitHub 에서 진행한다 —
   AI 가 직접 merge 하지 않는다.**

- 커밋/push 요청 시점에 현재 브랜치가 main 이면, 1번을 먼저 수행한 뒤 진행한다.
- 이미 main 에 커밋해 버렸다면 push 하지 말고 커밋을 브랜치로 옮긴다:
  `git switch -c <브랜치명>` (커밋이 새 브랜치로 따라옴) →
  `git branch -f main origin/main` (로컬 main 원복) → 새 브랜치에서 push + PR.
- PR 전에 `dart test` / `dart analyze` / `dart format --line-length 120 --set-exit-if-changed .` 가 통과해야 한다.

## Release & Versioning (태그 관리)

**merge ≠ release** — main 에 머지는 자유롭게 쌓고, 배포할 시점에만 릴리즈를 끊는다.

### 첫 릴리즈 이전 (~v0.1.0)

v0.1.0 이전에는 사용처가 없어 bump·deprecation 없이 breaking 변경을 `0.0.1` 에 쌓았다. **v0.1.0 부터 아래 규칙을 적용한다.**

### 불변식

- **태그명 = `v` + pubspec.yaml 의 `version`** — 둘이 어긋난 태그를 만들지 않는다.
- **push 한 태그는 이동·삭제 금지** — 잘못 나간 릴리즈는 고쳐서 다음 patch 태그로 낸다.
- `CHANGELOG.md` 최상단 항목 = pubspec 버전. 버전을 올리면 항목도 같이 추가한다.

### 버전 규칙 (0.x 시맨틱)

| 변경 | bump | 예 |
|---|---|---|
| 공개 함수 시그니처·반환값·예외 동작 breaking | minor | 0.0.1 → 0.1.0 |
| 함수 추가, 버그픽스, 내부 리팩터링 | patch | 0.0.1 → 0.0.2 |

### 릴리즈 절차

1. **release PR**: `release/vX.Y.Z` 브랜치에 `pubspec.yaml` version bump + `CHANGELOG.md`
   항목 추가를 담아 `chore: vX.Y.Z 릴리즈 준비` PR 로 머지한다.
2. **태그 + Release** (머지 후 main 에서):
   ```bash
   git checkout main && git pull origin main
   gh release create vX.Y.Z --generate-notes
   ```
   `--generate-notes` 가 머지된 PR 제목들로 릴리즈 노트를 만든다 — PR 제목을
   `type: 설명` 으로 쓰는 규칙이 노트 품질의 전제다.
