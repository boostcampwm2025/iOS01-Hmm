//
//  MotionManager.swift
//  Prototype
//
//  Created by 최범수 on 2025-12-18.
//

import CoreMotion

@Observable
class MotionManager {
    private let motionManager = CMMotionManager()

    // 설정값
    private let updateInterval = 1.0 / 60.0      // 주사율 16.67 ms
    private let threshold: Double = 0.05         // 데드존 (무반응 구간)
    private let movementSpeed: CGFloat = 1000.0  // 곱할 속도 (민감도)
    private let calibrationLimit: Double = 0.7   // 보정 허용 범위
    private var baselineGravityX: Double = 0     // 사용자 기준점 (0점)

    // View에서 사용할 데이터들
    var gravityX: Double = 0
    var gravityY: Double = 0
    var gravityZ: Double = 0
    var roll: Double = 0
    var pitch: Double = 0
    var yaw: Double = 0
    var userAccelX: Double = 0
    var userAccelY: Double = 0
    var userAccelZ: Double = 0
    var rotationX: Double = 0
    var rotationY: Double = 0
    var rotationZ: Double = 0
    var characterX: CGFloat = 0
    var calibratedGravityX: Double = 0
    var isCalibratable: Bool = true

    init() { startMotionUpdates() }
    deinit { motionManager.stopDeviceMotionUpdates() }

    func startMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = updateInterval

        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self, let motion = motion else { return }

            self.gravityX = motion.gravity.x
            self.gravityY = motion.gravity.y
            self.gravityZ = motion.gravity.z

            // 라디안 -> 각도 변환
            self.roll = motion.attitude.roll * 180 / .pi
            self.pitch = motion.attitude.pitch * 180 / .pi
            self.yaw = motion.attitude.yaw * 180 / .pi

            self.userAccelX = motion.userAcceleration.x
            self.userAccelY = motion.userAcceleration.y
            self.userAccelZ = motion.userAcceleration.z

            self.rotationX = motion.rotationRate.x
            self.rotationY = motion.rotationRate.y
            self.rotationZ = motion.rotationRate.z

            self.isCalibratable = abs(motion.gravity.x) <= self.calibrationLimit

            // 보정 및 클램핑 (-1.0 ~ 1.0 으로 보정)
            let rawInput = motion.gravity.x - self.baselineGravityX
            let clampedInput = max(-1.0, min(1.0, rawInput))
            self.calibratedGravityX = clampedInput

            // 캐릭터 이동
            if abs(clampedInput) > self.threshold {
                self.characterX += CGFloat(clampedInput) * self.movementSpeed * CGFloat(self.updateInterval)

                // 화면 밖 방지
                let screenLimit: CGFloat = 150
                self.characterX = max(-screenLimit, min(screenLimit, self.characterX))
            }
        }
    }

    func recalibrate() {
        if abs(self.gravityX) <= self.calibrationLimit {
            self.baselineGravityX = self.gravityX
            self.characterX = 0
        }
    }
}
