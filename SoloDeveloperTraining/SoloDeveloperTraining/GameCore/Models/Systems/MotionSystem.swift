//
//  MotionSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/13/26.
//

import CoreMotion
import Observation

@Observable
final class MotionSystem {
    // MARK: - Properties
    /// CoreMotion 매니저
    private let motionManager = CMMotionManager()

    // MARK: - 설정값
    /// 모션 업데이트 주사율 (120fps)
    private let updateInterval = 1.0 / 120.0
    /// 데드존 임계값 (이 값 이하의 기울기는 무시)
    private let threshold: Double = 0.05
    /// 최대 이동 속도 (기울기 1.0일 때)
    private let maxSpeed: CGFloat = 2000.0
    /// 최소 이동 속도 (기울기 threshold일 때)
    private let minSpeed: CGFloat = 300.0

    // MARK: - Public Properties
    /// X축 중력 값 (-1.0 ~ 1.0)
    var gravityX: Double = 0
    /// Y축 중력 값 (-1.0 ~ 1.0)
    var gravityY: Double = 0
    /// Z축 중력 값 (-1.0 ~ 1.0)
    var gravityZ: Double = 0
    /// 캐릭터의 X 위치 (-150 ~ 150)
    var characterX: CGFloat = 0
    /// 보정된 X축 기울기 값 (-1.0 ~ 1.0)
    var calibratedGravityX: Double = 0

    init() {
        startMotionUpdates()
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }

    /// 모션 업데이트를 시작하고 기기 기울기에 따라 캐릭터 위치를 업데이트
    ///
    /// - 기울기 강도에 따라 이동 속도가 비선형적으로 증가
    /// - 화면 밖으로 나가지 않도록 제한
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
