//
//  HapticService.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 1/22/26.
//

import SwiftUI
import AVFoundation

private enum Constant {
    static let volumeRange: ClosedRange<Int> = 0 ... 100
    static let defaultVolume: Int = 100
    /// 효과음 동시 재생 상한 (중첩 허용)
    static let maxConcurrentSFX: Int = 10
}

@Observable
final class SoundService {
    static let shared = SoundService()

    private let sfxDelegate = SoundPlayerDelegate()

    private var sfxPlayers: [AVAudioPlayer] = []
    private var bgmPlayer: AVAudioPlayer?

    var isSFXEnabled: Bool {
        didSet {
            AppPreferences.shared.isSfxEnabled = isSFXEnabled
        }
    }

    var isBGMEnabled: Bool {
        didSet {
            AppPreferences.shared.isBGMEnabled = isBGMEnabled
            if isBGMEnabled {
                playBGM()
            } else {
                stopBGM()
            }
        }
    }

    var bgmVolume: Int {
        didSet {
            AppPreferences.shared.bgmVolume = bgmVolume
            bgmPlayer?.volume = Float(bgmVolume) / 100
        }
    }

    var sfxVolume: Int {
        didSet {
            AppPreferences.shared.sfxVolume = sfxVolume
        }
    }

    private init() {
        self.isSFXEnabled = AppPreferences.shared.isSfxEnabled
        self.isBGMEnabled = AppPreferences.shared.isBGMEnabled

        let storedBgm = AppPreferences.shared.bgmVolume
        let storedSfx = AppPreferences.shared.sfxVolume
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

    func trigger(_ sound: SoundType) {
        guard isSFXEnabled else { return }
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
