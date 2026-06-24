//
//  AppPreferences.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 6/24/26.
//

import Foundation

final class AppPreferences {

    static let shared = AppPreferences()

    private enum Key {
        /// 햅틱 활성 여부
        static let isHapticEnabled = "isHapticEnabled"

        /// 효과음 활성 여부
        static let isSfxEnabled = "isSFXEnabled"

        /// 배경음 활성 여부
        static let isBGMEnabled = "isBGMEnabled"

        /// 배경음 볼륨 크기
        static let bgmVolume = "bgmVolume"

        /// 효과음 볼륨 크기
        static let sfxVolume = "sfxVolume"

        /// 업무 모드 선택 상태
        static let lastSelectedWorkIndex = "lastSelectedWorkIndex"

        /// 장비 강화 광고 보상 타입
        static let equipmentAdBonus = "equipmentAdBonusTypes"
    }

    private let storage = UserDefaultsStorage()

    // 초기화시 fallback 로직 등록
    private init() {
        storage.register(defaults: [
            Key.isHapticEnabled: true,
            Key.isSfxEnabled: true,
            Key.isBGMEnabled: true,
            Key.bgmVolume: 100,
            Key.sfxVolume: 100,
            Key.lastSelectedWorkIndex: 0
        ])
    }
}

extension AppPreferences {

    var isHapticEnabled: Bool {
        get { storage.bool(key: Key.isHapticEnabled) }
        set { storage.set(newValue, forKey: Key.isHapticEnabled) }
    }

    var isSfxEnabled: Bool {
        get { storage.bool(key: Key.isSfxEnabled) }
        set { storage.set(newValue, forKey: Key.isSfxEnabled) }
    }

    var isBGMEnabled: Bool {
        get { storage.bool(key: Key.isBGMEnabled) }
        set { storage.set(newValue, forKey: Key.isBGMEnabled) }
    }

    var bgmVolume: Int {
        get { storage.integer(key: Key.bgmVolume) }
        set { storage.set(newValue, forKey: Key.bgmVolume) }
    }

    var sfxVolume: Int {
        get { storage.integer(key: Key.sfxVolume) }
        set { storage.set(newValue, forKey: Key.sfxVolume) }
    }

    var lastSelectedWorkIndex: Int {
        get { storage.integer(key: Key.lastSelectedWorkIndex) }
        set { storage.set(newValue, forKey: Key.lastSelectedWorkIndex) }
    }

}
