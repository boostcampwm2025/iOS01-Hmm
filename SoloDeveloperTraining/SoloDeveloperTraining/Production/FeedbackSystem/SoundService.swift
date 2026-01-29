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
    /// 효과음 동시 재생 상한 (중첩 허용)
    static let maxConcurrentSFX: Int = 10
}

@Observable
final class SoundService {
    static let shared = SoundService()

    private var sfxPlayers: [AVAudioPlayer] = []
    private var bgmPlayer: AVAudioPlayer?
    private let sfxDelegate = SoundPlayerDelegate()
    private let localStorage: KeyValueLocalStorage = UserDefaultsStorage()

    var isEnabled: Bool {
        didSet {
            localStorage.set(isEnabled, forKey: Constant.soundEnabledKey)
        }
    }

    var isBGMEnabled: Bool {
        didSet {
            localStorage.set(isBGMEnabled, forKey: Constant.bgmEnabledKey)
            if isBGMEnabled {
                playBGM()
            } else {
                stopBGM()
            }
        }
    }

    var bgmVolume: Int {
        didSet {
            localStorage.set(bgmVolume, forKey: Constant.bgmVolumeKey)
            bgmPlayer?.volume = Float(bgmVolume) / 100
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
        sfxDelegate.onFinish = { [weak self] player in
            self?.removeFinishedSFXPlayer(player)
        }
    }

    func removeFinishedSFXPlayer(_ player: AVAudioPlayer) {
        sfxPlayers.removeAll { $0 === player }
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
        if sfxPlayers.count >= Constant.maxConcurrentSFX { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = Float(sfxVolume) / 100
            player.delegate = sfxDelegate
            player.prepareToPlay()
            player.play()
            sfxPlayers.append(player)
        } catch {
            print("소리를 재생할 수 없음", error)
        }
    }

    /// 재생 중인 효과음 전부 정지 (게임 일시정지·뷰 이탈 시 등)
    func stopAllSFX() {
        sfxPlayers.forEach { $0.stop() }
        sfxPlayers.removeAll()
    }

    // MARK: - BGM

    func playBGM() {
        guard isBGMEnabled else { return }
        guard let url = SoundType.bgm.url else { return }
        stopBGM()
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.volume = Float(bgmVolume) / 100
            player.prepareToPlay()
            player.play()
            bgmPlayer = player
        } catch {
            print("BGM 재생 실패", error)
        }
    }

    func stopBGM() {
        bgmPlayer?.stop()
        bgmPlayer = nil
    }
}

// MARK: - SFX 재생 완료 처리 (중첩 재생용)
private final class SoundPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    var onFinish: ((AVAudioPlayer) -> Void)?

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.onFinish?(player)
        }
    }
}
