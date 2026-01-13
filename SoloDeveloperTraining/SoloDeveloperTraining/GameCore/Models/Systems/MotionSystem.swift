//
//  MotionSystem.swift
//  SoloDeveloperTraining
//
//  Created by Claude on 1/13/26.
//

import CoreMotion
import Observation

@Observable
final class MotionSystem {
    private let motionManager = CMMotionManager()

    // 설정값
    private let updateInterval = 1.0 / 120.0     // 주사율 120fps (8.33 ms)
    private let threshold: Double = 0.05         // 데드존 (무반응 구간)
    private let maxSpeed: CGFloat = 2000.0       // 최대 속도 (기울기 1.0일 때)
    private let minSpeed: CGFloat = 300.0        // 최소 속도 (기울기 threshold일 때)

    // View에서 사용할 데이터들
    var gravityX: Double = 0
    var gravityY: Double = 0
    var gravityZ: Double = 0
    var characterX: CGFloat = 0
    var calibratedGravityX: Double = 0

    init() {
        startMotionUpdates()
    }
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }

    func startMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = updateInterval

        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self = self, let motion = motion else { return }

            self.gravityX = motion.gravity.x
            self.gravityY = motion.gravity.y
            self.gravityZ = motion.gravity.z

            // 클램핑 (-1.0 ~ 1.0)
            let clampedInput = max(-1.0, min(1.0, motion.gravity.x))
            self.calibratedGravityX = clampedInput

            // 캐릭터 이동 (기울기에 따라 속도 변화)
            if abs(clampedInput) > self.threshold {
                // 기울기 강도에 따라 속도 계산 (비선형적으로 증가)
                let tiltStrength = abs(clampedInput)
                let speedMultiplier = self.minSpeed + (self.maxSpeed - self.minSpeed) * CGFloat(pow(tiltStrength, 1.5))
                let direction = clampedInput > 0 ? 1.0 : -1.0

                self.characterX += CGFloat(direction) * speedMultiplier * CGFloat(self.updateInterval)

                // 화면 밖 방지
                let screenLimit: CGFloat = 150
                self.characterX = max(-screenLimit, min(screenLimit, self.characterX))
            }
        }
    }
}
