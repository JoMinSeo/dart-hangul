# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 개요

Dart/Flutter용 한글 처리 유틸리티 패키지. [es-hangul](https://github.com/toss/es-hangul)(TypeScript)의 포팅으로, 함수명·동작·테스트 케이스가 원본을 따른다. 새 함수를 추가하거나 동작이 애매할 때는 es-hangul의 동일 함수를 기준으로 삼을 것.

`Agents.md`(gitignore됨, 로컬 전용)에 API 표와 알고리즘 설명이 있다. 있으면 참고하되, clone 환경에는 없을 수 있다.

## 명령어

```bash
flutter pub get
flutter test                                   # 전체 테스트
flutter test test/src/core/josa_test.dart      # 파일 단위
flutter test test/src/core/josa_test.dart --plain-name '주격조사'   # 단일 테스트
flutter analyze
dart format --line-length 120 .                # 포맷
```

- `flutter_test` 의존이므로 `dart test`가 아니라 `flutter test`를 쓴다.
- **포맷 line length는 120**이다. 기본값(80)으로 `dart format`을 돌리면 15개 파일이 바뀌니 반드시 `--line-length 120`.
- `flutter analyze`는 현재 `example/main.dart`의 `avoid_print` info 1건만 남아 있다(플레이스홀더).

## 구조

```
lib/dart_hangul.dart        # 배럴 — _internal/ 포함 전부 export (내부 헬퍼도 사실상 공개 API)
lib/src/types/              # extension type Choseong/Jungseong/Jongseong (String 래핑, tryParse/index)
lib/src/_internal/constants.dart  # 자모 테이블 (choseongs/jungseongs/jongseongs, 분해 맵, alphabetToKorean)
lib/src/_internal/hangul.dart     # 조합 엔진: binaryAssemble*, linkHangulCharacters, isHangul*, curriedCombineCharacter
lib/src/core/               # 공개 함수 1개 = 파일 1개
test/src/                   # lib/src와 1:1 미러, package:dart_hangul/src/... 직접 import
```

의존 방향: `core/assemble.dart` → `_internal/hangul.dart` → `core/{combine_character,can_be_*,disassemble_to_groups,...}` → `types/` → `constants.dart`. `_internal/hangul.dart`가 core 위에 얹힌 조합 엔진이고, `assemble`만 다시 그걸 쓴다.

### 핵심 불변식: 자모는 "분해형" 문자열로 다룬다

- 중성/종성의 정규 표현은 **분해된 다중 문자**다: `ㅘ`→`'ㅗㅏ'`, `ㄳ`→`'ㄱㅅ'`, 종성 없음→`''`.
- `jungseongs`(21)/`jongseongs`(28) 리스트가 이 분해형으로 정의되어 있고, 리스트 **인덱스가 곧 유니코드 오프셋**이다: `0xAC00 + 초성idx×21×28 + 중성idx×28 + 종성idx`. 리스트 순서를 바꾸면 조합/분해가 전부 깨진다.
- `Jungseong.tryParse`는 조합형(`ㅘ`)을 분해형으로 정규화하지만, **`Jongseong.tryParse`는 정규화하지 않는다** — 종성은 반드시 `'ㄱㅅ'` 형태로 넘겨야 한다(`'ㄳ'`는 null).
- `disassembleToGroups`가 분해의 원시 함수. `disassemble`은 그걸 flat join, `assemble`은 입력을 전부 분해한 뒤 `binaryAssemble`로 left-fold.
- `canBeJungseong('ㅗㅏ')`, `canBeJongseong('ㄱㅅ')`처럼 2글자 문자열을 받는 게 정상이다.

### 기타

- `josa`: `hasBatchim`으로 이/가 계열 선택 + `으로/로` 계열은 ㄹ받침 예외 + 대문자 영어 약어는 `alphabetToKorean`으로 마지막 글자 발음을 치환해 판정.
- `getChoseong`은 `unorm_dart` NFD 분해를 써서 초성을 뽑는다 (유일한 외부 의존).

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
- PR 전에 `flutter test` / `flutter analyze` / `dart format --line-length 120 --set-exit-if-changed .` 가 통과해야 한다.

## Release & Versioning (태그 관리)

**merge ≠ release** — main 에 머지는 자유롭게 쌓고, 배포할 시점에만 릴리즈를 끊는다.

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
