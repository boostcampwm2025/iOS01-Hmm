//
//  DUIcon.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/31/26.
//

import SwiftUI

/// DUDesignSystem 아이콘 열거형입니다.
///
/// 각 케이스의 raw value는 `DUIcons.xcassets` 내 네임스페이스 경로이며,
/// `defaultSize`로 Figma에서 지정된 기본 크기를 제공합니다.
///
/// 새 아이콘 추가 시:
/// 1. `DUIcons.xcassets/<size>/` 폴더에 imageset 추가
/// 2. 해당 사이즈 섹션에 케이스 추가
/// 3. `defaultSize` switch에 케이스 추가
public enum DUIconName: String, CaseIterable {

    // MARK: - 15pt
    case coinBag            = "15/icon_coin_bag"

    // MARK: - 18pt
    case ad                 = "18/icon_ad"
    case coinStack          = "18/icon_coin_stack"
    case diamondGreen       = "18/icon_diamond_green"
    case minus              = "18/icon_minus"
    case plus               = "18/icon_plus"

    // MARK: - 24pt
    case cancel             = "24/icon_cancel"
    case close              = "24/icon_close"
    case coffee             = "24/icon_coffee"
    case diamond            = "24/icon_diamond"
    case diamondPlus        = "24/icon_diamond_plus"
    case dropBug            = "24/icon_drop_bug"
    case dropLargeGold      = "24/icon_drop_large_gold"
    case dropSmallGold      = "24/icon_drop_small_gold"
    case energyDrink        = "24/icon_energy_drink"
    case lock               = "24/icon_lock"
    case mission            = "24/icon_mission"
    case newBadge           = "24/icon_new_badge"
    case play               = "24/icon_play"
    case shop               = "24/icon_shop"
    case skill              = "24/icon_skill"
    case work               = "24/icon_work"
    case xlAd               = "24/icon_xlad"

    // MARK: - 38pt
    case profileLockedSmall = "38/icon_profile_locked"

    // MARK: - 44pt
    case languageDart       = "44/icon_language_dart"
    case languageKotlin     = "44/icon_language_kotlin"
    case languagePython     = "44/icon_language_python"
    case languageSwift      = "44/icon_language_swift"
    case setting            = "44/icon_setting"

    // MARK: - 49pt
    case profileComplete    = "49/icon_profile_complete"
    case profileCurrent     = "49/icon_profile_current"
    case profileLocked      = "49/icon_profile_locked"

    // MARK: - 51pt
    case quizDogFace        = "51/icon_quiz_dog_face"
    case quizDogFoot        = "51/icon_quiz_dog_foot"

    // MARK: - 64pt
    case dodgeCharacter1    = "64/icon_dodge_character1"
    case dodgeCharacter2    = "64/icon_dodge_character2"
    case dodgeCharacter3    = "64/icon_dodge_character3"
}

extension DUIconName {
    /// Figma에서 지정된 기본 크기입니다. `DUIcon` 초기화 시 size를 생략하면 이 값을 사용합니다.
    public var defaultSize: CGFloat {
        switch self {
        case .coinBag:
            return TokenIconSize.size15
        case .ad, .coinStack, .diamondGreen, .minus, .plus:
            return TokenIconSize.size18
        case .cancel, .close, .coffee, .diamond, .diamondPlus,
             .dropBug, .dropLargeGold, .dropSmallGold, .energyDrink,
             .lock, .mission, .newBadge, .play, .shop, .skill, .work, .xlAd:
            return TokenIconSize.size24
        case .profileLockedSmall:
            return TokenIconSize.size38
        case .languageDart, .languageKotlin, .languagePython, .languageSwift, .setting:
            return TokenIconSize.size44
        case .profileComplete, .profileCurrent, .profileLocked:
            return TokenIconSize.size49
        case .quizDogFace, .quizDogFoot:
            return TokenIconSize.size51
        case .dodgeCharacter1, .dodgeCharacter2, .dodgeCharacter3:
            return TokenIconSize.size64
        }
    }
}

/// 디자인 시스템 아이콘 컴포넌트입니다.
///
/// size를 생략하면 Figma에서 지정된 기본 크기를 사용합니다.
/// ```swift
/// DUIcon(.setting)                            // 기본 크기 (44pt)
/// DUIcon(.setting, size: TokenIconSize.size49) // 크기 오버라이드
/// ```
public struct DUIcon: View {
    private let name: DUIconName
    private let size: CGFloat

    public init(_ name: DUIconName, size: CGFloat? = nil) {
        self.name = name
        self.size = size ?? name.defaultSize
    }

    public var body: some View {
        Image(name.rawValue, bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}
