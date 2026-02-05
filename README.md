# iOS01-Hmm (흠)
흠이 없어....그래서 흠이야

## 팀원 소개
| 이름 | Sophia 김선재 | Oliver 김성훈 | Raven 서준영 | Edward 최범수 |
|:----:|:------:|:------:|:------:|:------:|
| 캠퍼 ID | S004 | S005 | S016 | S037 |
| 사진 | <img width="300" alt="image" src="https://github.com/user-attachments/assets/9befc1cc-6709-4e4e-bcde-3039314d8058" /> |<img width="300" alt="image" src="https://github.com/user-attachments/assets/91e8a868-17d3-426d-8e19-278c7dcad420" />| <img width="300" alt="image" src="https://github.com/user-attachments/assets/f39478c8-cd05-45b1-bb3b-b4d9541008bb" /> | <img width="300" alt="image" src="https://github.com/user-attachments/assets/8aa2758d-291c-48dc-b9ed-c4e00e14854d" />|
| 역할 | 팀원 | 🤴🏻 팀장 | 팀원 | 팀원 |

# 🎮 개발자 키우기
<img width="2472" height="1078" alt="image" src="https://github.com/user-attachments/assets/2e432e68-49e6-41fd-96d8-ea18ad5b23dc" />

# 📝 개요

> `개발자 키우기`는 백수에서 시작해 월드클래스 iOS 개발자로 성장하는 시뮬레이션 게임입니다.
> 

본 프로젝트는 단순한 탭 반복 위주의 방치형 게임에서 벗어나,
iOS 기기 고유의 입력 방식과 물리 시스템을 적극 활용한 게임 경험을 목표로 기획되었습니다.
사용자는 화면 터치뿐만 아니라 기기의 기울기를 직접 조작하며 다양한 미니게임을 플레이하게 됩니다.

게임의 핵심 루프는 **`미니게임 → 재산 획득 → 스킬/아이템/부동산 강화 → 커리어 성장 및 미션 보상`** 으로 구성되어 있으며,
플레이가 누적될수록 더 효율적인 성장 전략을 설계할 수 있도록 설계되었습니다.
이를 통해 단순한 반복이 아닌, 선택과 전략이 개입되는 성장 구조를 제공합니다.

기술적으로는 `CoreMotion`을 활용한 기기 기울기 입력 처리와
`SpriteKit` 물리 엔진을 활용한 오브젝트 상호작용을 통해
iOS 기기 특유의 ‘손맛’과 직관적인 조작감을 구현했습니다.

또한 `SwiftUI` 기반 UI 구성과 `Actor`를 활용한 동시성 제어를 통해
게임 로직과 상태 관리를 명확히 분리하고, 안정적이고 부드러운 플레이 경험을 제공하는 것을 목표로 했습니다.

# 🔨 실행 방법 / 최소 지원 버전
```
타깃을 SoloDeveloperTraining으로 설정 후 빌드합니다.
```
```
Minimum Deployment Target: iOS 17.0
```

# ⚔️ 사용 기술 스택

| 구분 | 스택 |
|---|---|
| **Language** | Swift 6.0 |
| **UI** | SwiftUI, Observable |
| **Framework** | CoreMotion, SpriteKit |
| **Async** | Swift Concurrency |
| **Tools** | SwiftLint |
| **CI/CD** | Github Actions |

# 🦿 프로젝트 구조
```
SoloDeveloperTraining/
  ├── Prototype/                             # 프로토타입 프로젝트
  └── SoloDeveloperTraining/                 # 메인 프로젝트
      ├── SoloDeveloperTraining.xcodeproj
      └── SoloDeveloperTraining/
          │
          ├── App/                           # 앱 진입점 (AppDelegate, SceneDelegate 등)
          │
          ├── DesignSystem/                  # 디자인 시스템
          │
          ├── Extensions/                    # Swift 확장 기능
          │
          ├── GameCore/                      # 게임 핵심 로직
          │   └── Models/
          │       ├── Games/                 # 미니게임
          │       ├── Items/                 # 아이템 모델
          │       ├── Storages/              # 저장소 모델
          │       ├── Systems/               # 게임 시스템
          │       └── User/                  # 유저 관련
          │
          ├── Production/                    # 프로덕션 코드
          │   ├── Data/                      # 데이터 레이어
          │   ├── Error/                     # 에러 처리
          │   ├── FeedbackSystem/            # 피드백 시스템 (햅틱, 사운드 등)
          │   ├── Presentation/              # UI 레이어
          │   └── Utility/                   # 유틸리티 함수들
          │
          ├── Development/                    # 개발용 코드
          │   └── Presentation/              # 개발용 UI
          │
          └── Resources/                     # 리소스 파일
              ├── Assets.xcassets/           # 이미지, 컬러 에셋
              ├── Audio/                     # 오디오 파일
              └── Fonts/                     # 폰트 파일
```
# 🚀 주요 기능

## 1. 커리어 성장 시스템
- **9단계 커리어 등급**
    - **`백수 → 노트북 보유자 → 개발자 지망생 → ... → 월드클래스 개발자`**
- **누적 재산 기반 자동 승급**: 플레이하며 자연스럽게 성장하는 시스템입니다.
- **등급별 콘텐츠 해금**: 새로운 미니게임 모드와 강화 콘텐츠를 해금할 수 있습니다.

## 2. 4가지 미니게임
| 코드짜기 | 언어 맞추기 | 버그 피하기 | 데이터 쌓기 |
| --- | --- | --- | --- |
|<img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/c602a5b0-56e0-44f9-8b7b-214323ff9999" />|<img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/2f14181c-9752-4163-aee9-7ece3db4252d" />|<img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/32034b4e-cee4-4355-a852-a2b8955adb59" />|<img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/93f37522-6755-4a7e-8ebf-f5dfb522ff13" />|
| 반복적인 화면 터치(탭)를 통해 재산을 획득할 수 있습니다. | 올바른 언어 아이콘을 매칭 터치하여 재산을 획득할 수 있습니다. | CoreMotion 자이로 센서를 활용하여 기기 기울여 재산을 획득할 수 있습니다. | SpriteKit 물리 엔진을 기반으로 타이밍에 맞춰 터치하여 재산을 획득할 수 있습니다. |

## 3. 피버 시스템
- **3단계 피버 게이지**: 0~300%까지 노란색 → 주황색 → 빨간색으로 시각화 했습니다.
- **단계별 배율**: 100% 도달 시 x배, 200% 도달 시 y배, 300% 도달 시 z배 획득 할 수 있습니다.
- **게이지 변화**: 액션 성공 시 증가하고, n초마다 자동 감소합니다.

| 0단계 | 1단계 | 2단계 | 3단계 |
| --- | --- | --- | --- |
|<img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/b009508b-03c1-4913-bb44-6a55fbb557a9" />|<img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/e685c6d1-de79-432b-9120-1e9f91562baa" />|<img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/ff7b6e20-7016-4862-852c-07b858f9adfc" />|<img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/c502143d-bfb3-47eb-8b87-a30b74746812" />|


## 4. 경제 시스템

| 스킬| 아이템 | 부동산 |
| --- | --- | --- |
|<img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/7c51045e-794a-40fa-a638-d20d79ca5e74" />|<img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/f1e3c5fa-ed64-4219-b7ad-562a2d037d24" />|<img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/27f2da30-19a9-4fef-8fa7-227c80cfa612" />|
| - 업무 4개 모드마다 초급/중급/고급의 스킬이 존재합니다. <br>  - 레벨이 올라갈수록 각 업무의 액션 재산이 증가합니다. | - 커피, 박하스로 일시적 버프 효과를 획득합니다.<br> - 키보드, 마우스, 모니터, 의자 각각의 8등급의 강화 시스템이 존재합니다.<br> - 등급이 높아질수록 강화 성공 확률이 감소합니다. | - 길바닥 → 반지하 → … → 펜트하우스의 등급이 존재합니다.<br> - 배경을 변경할 수 있고, 부동산은 하나만 소유 가능합니다.|


## 5. 부가 콘텐츠
| 퀴즈 | 미션 | 튜토리얼 | 설정 |
| --- | --- | --- | --- |
| <img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/edef116e-db41-480c-8fa5-f72c67152ef9" />| <img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/b19e79dc-f7a0-4657-8061-294418b4fccb" />| <img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/e11d25d6-92cd-49ca-a175-e099d72e9da5" />| <img width="990" height="1876" alt="image" src="https://github.com/user-attachments/assets/7c640b1c-95ad-4d69-8b81-19e81bda87b5" />|
| 개발 밈과 관련된 퀴즈로 다이아 보상을 획득할 수 있습니다. | 다양한 목표 달성으로 지속적인 플레이를 보장하며 보상을 획득할 수 있습니다. | 게임 시스템의 기본적인 학습을 할 수 있습니다. | 사운드, 효과음, 햅틱에 대한 설정을 조절할 수 있습니다. |
