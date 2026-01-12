# PR 제목

## 작업 내용 및 고민 내용

### 1. 언어 아이콘 이미지 에셋 추가 (8bfd387)
- Swift, Kotlin, Dart, Python 언어 아이콘 이미지 에셋을 추가했습니다.
- 각 언어별로 1x, 2x, 3x 해상도 이미지를 포함했습니다.

### 2. Pastel 컬러 에셋 추가 (d61c740)
- LanguageButton에서 사용할 Pastel Yellow, Pastel Pink, Pastel Blue, Pastel Green 컬러 셋을 추가했습니다.

### 3. AppColors 타입 추가 (9c29b87)
- Pastel 컬러들을 코드에서 사용할 수 있도록 AppColors 타입에 프로퍼티를 추가했습니다.

### 4. LanguageType 열거형 추가 (cf3f23a)
- Swift, Kotlin, Dart, Python 언어 타입을 정의하는 열거형을 추가했습니다.
- 향후 확장 가능성을 고려하여 GameCore/Models/Games/LanguageGame.swift에 추가했습니다.
- 각 언어별 이미지명, 배경색명 등의 정보를 포함합니다.

### 5. ButtonStyle 확장 구현 (1e77e15)
- 버튼이 눌리는 효과(pressable effect)가 프로젝트 전반에서 자주 사용될 것으로 예상되어, 공통으로 사용할 수 있는 `PressableButtonStyle`을 `Extensions/ButtonStyle+.swift`에 구현했습니다.
- `.buttonStyle(.pressable(isPressed: $isPressed))` 형식으로 간편하게 사용할 수 있도록 ButtonStyle extension을 추가했습니다.
- 기존에 `LanguageButton.swift`와 `TabBarView.swift`에 중복으로 존재하던 `PressableButtonStyle` 코드를 제거하고 공통 코드로 통합했습니다.
- TabBarView의 경우 이번 PR에 포함할지 고민했지만, ButtonStyle 변경 로직이 포함되어 있어 함께 포함했습니다.

### 6. LanguageButton 컴포넌트 구현 (e873904)
- 언어 선택 버튼 컴포넌트를 구현했습니다.
- 각 언어별 아이콘과 이름을 표시하며, Pastel 컬러 배경을 사용합니다.
- 버튼이 눌릴 때 시각적 피드백을 제공하는 pressable 효과를 적용했습니다.

## 리뷰 요구사항

1. **ButtonStyle 확장 구현**
   - 버튼이 눌리는 효과가 프로젝트 전반에서 자주 사용될 것으로 예상되어 공통 코드로 분리했습니다.
   - `Extensions/ButtonStyle+.swift`에 `PressableButtonStyle`을 구현하고, `.buttonStyle(.pressable(isPressed:))` 형식으로 사용할 수 있도록 했습니다.

2. **TabBarView 변경 포함**
   - TabBarView는 이번 PR에 포함할지 고민했지만, ButtonStyle 변경 로직이 포함되어 있어 함께 포함했습니다.
   - 기존 중복 코드를 제거하고 공통 ButtonStyle을 사용하도록 수정했습니다.

3. **LanguageType 열거형 위치**
   - LanguageType 열거형을 향후 확장 가능성을 고려하여 `GameCore/Models/Games/LanguageGame.swift`에 추가했습니다.
   - 게임 로직과 밀접한 관련이 있어 GameCore에 위치시켰습니다.
