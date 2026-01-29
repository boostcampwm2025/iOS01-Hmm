//
//  HapticService.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import SwiftUI
import AVFoundation

private enum Constant {
    static let soundEnabledKey: String = "isSoundEnabled"
    static let bgmEnabledKey: String = "isBGMEnabled"
    static let bgmVolumeKey: String = "bgmVolume"
    static let sfxVolumeKey: String = "sfxVolume"
    static let volumeRange: ClosedRange<Int> = 0 ... 100
    static let defaultVolume: Int = 100
}

@Observable
final class SoundService {
    static let shared = SoundService()

    private var player: AVAudioPlayer?
    private let localStorage: KeyValueLocalStorage = UserDefaultsStorage()

    var isEnabled: Bool {
        didSet {
            localStorage.set(isEnabled, forKey: Constant.soundEnabledKey)
        }
    }

    var isBGMEnabled: Bool {
        didSet {
            localStorage.set(isBGMEnabled, forKey: Constant.bgmEnabledKey)
        }
    }

    var bgmVolume: Int {
        didSet {
            localStorage.set(bgmVolume, forKey: Constant.bgmVolumeKey)
        }
    }

    var sfxVolume: Int {
        didSet {
            localStorage.set(sfxVolume, forKey: Constant.sfxVolumeKey)
        }
    }

    private init() {
        localStorage.register(defaults: [
            Constant.soundEnabledKey: true,
            Constant.bgmEnabledKey: true,
            Constant.bgmVolumeKey: Constant.defaultVolume,
            Constant.sfxVolumeKey: Constant.defaultVolume
        ])

        self.isEnabled = localStorage.bool(key: Constant.soundEnabledKey)
        self.isBGMEnabled = localStorage.bool(key: Constant.bgmEnabledKey)
        let storedBgm = localStorage.integer(key: Constant.bgmVolumeKey)
        let storedSfx = localStorage.integer(key: Constant.sfxVolumeKey)
        self.bgmVolume = Constant.volumeRange.contains(storedBgm) ? storedBgm : Constant.defaultVolume
        self.sfxVolume = Constant.volumeRange.contains(storedSfx) ? storedSfx : Constant.defaultVolume

        try? AVAudioSession.sharedInstance().setCategory(
            .playback,    // 무음모드 무시
            options: [.mixWithOthers]
        )
    }

    func toggle() {
        isEnabled.toggle()
        // 활성화 되었음을 알리기 위해 햅틱 트리거
        if isEnabled {
            HapticType.medium.trigger()
        }
    }

    func trigger(_ sound: SoundType) {
        guard isEnabled else { return }
        guard let url = sound.url else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = Float(sfxVolume) / 100
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("소리를 재생할 수 없음", error)
        }
    }
}
