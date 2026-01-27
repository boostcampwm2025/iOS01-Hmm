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
}

@Observable
final class SoundService {
    static let shared = SoundService()

    private var player: AVAudioPlayer?
    private let localStorage: KeyValueLocalStorage = UserDefaultStorage()

    var isEnabled: Bool {
        didSet {
            localStorage.set(key: isEnabled, value: Constant.soundEnabledKey)
        }
    }

    private init() {
        // 저장된 키가 없을 경우 기본값 등록
        localStorage.register(defaults: [Constant.soundEnabledKey: true])

        self.isEnabled = localStorage.bool(key: Constant.soundEnabledKey)

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
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("소리를 재생할 수 없음", error)
        }
    }
}
