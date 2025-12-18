//
//  Motion.swift
//  Prototype
//
//  Created by 김성훈 on 12/17/25.
//

import CoreMotion
import SwiftUI

// MARK: - MotionManager
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

// MARK: - View
struct MotionView: View {
    private enum Texts {
        static let descriptionTitle = "Description"
        static let descriptionContent = "기기를 기울여 Core Motion 변화를 확인합니다. 실기기에서만 테스트할 수 있습니다."

        static let selectedSensorTitle = "사용할 센서 값"
        static let calibratedGravityX = "보정된 gravityX 입력값"
        static let unselectedSensorTitle = "측정 센서 값들"

        static let gravityX = "gravityX"
        static let gravityY = "gravityY"
        static let gravityZ = "gravityZ"

        static let roll = "좌우 기울기(Roll)"
        static let pitch = "앞뒤 기울기(Pitch)"
        static let yaw = "수평 회전(Yaw)"

        static let rotationRateRoll = "Roll 속도"
        static let rotationRatePitch = "Pitch 속도"
        static let rotationRateYaw = "Yaw 속도"

        static let accelerationX = "가속도(x)"
        static let accelerationY = "가속도(y)"
        static let accelerationZ = "가속도(z)"

        static let recalibrateButton = "센서 초기값 다시 설정하기"
        static let character = "캐릭터"
    }

    @State private var motionManager = MotionManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // 1. Description
            VStack(alignment: .leading, spacing: 20) {
                Text(Texts.descriptionTitle)
                    .font(.title2)
                Text(Texts.descriptionContent)
            }

            Divider()

            // 2. 선택에 적합한 센서 값
            VStack(alignment: .leading, spacing: 5) {
                Text(Texts.selectedSensorTitle)
                    .font(.title2)
                    .bold()

                HStack {
                    Text(Texts.calibratedGravityX)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.calibratedGravityX))
                        .foregroundStyle(.blue)
                        .bold()
                }
            }

            Divider()

            // 3. 측정한 센서 값
            VStack(alignment: .leading, spacing: 5) {
                Text(Texts.unselectedSensorTitle)
                    .font(.title2)
                    .bold()

                // Gravity
                HStack {
                    Text(Texts.gravityX)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.gravityX))
                        .foregroundStyle(abs(motionManager.gravityX) > 0.7 ? .red : .primary)
                }
                HStack {
                    Text(Texts.gravityY)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.gravityY))
                }
                HStack {
                    Text(Texts.gravityZ)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.gravityZ))
                }

                // 기울기
                HStack {
                    Text(Texts.roll)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.roll))
                }
                HStack {
                    Text(Texts.pitch)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.pitch))
                }
                HStack {
                    Text(Texts.yaw)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.yaw))
                }

                // 회전 속도
                HStack {
                    Text(Texts.rotationRateRoll)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.rotationY))
                }
                HStack {
                    Text(Texts.rotationRatePitch)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.rotationX))
                }
                HStack {
                    Text(Texts.rotationRateYaw)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.rotationZ))
                }

                // 가속도
                HStack {
                    Text(Texts.accelerationX)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.userAccelX))
                }
                HStack {
                    Text(Texts.accelerationY)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.userAccelY))
                }
                HStack {
                    Text(Texts.accelerationZ)
                    Spacer()
                    Text(String(format: "%.3f", motionManager.userAccelZ))
                }
            }

            Divider()

            // 4. 초기화 버튼
            Button(Texts.recalibrateButton) {
                motionManager.recalibrate()
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
            .disabled(!motionManager.isCalibratable)

            if !motionManager.isCalibratable {
                Text("기기가 너무 기울어져서 재설정할 수 없습니다.")
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            Spacer()

            // 5. 캐릭터
            VStack {
                Rectangle()
                    .fill(.gray)
                    .frame(width: 40, height: 40)
                Text(Texts.character)
                    .font(.caption)
            }
            .offset(x: motionManager.characterX, y: 0)
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

#Preview {
    MotionView()
}
