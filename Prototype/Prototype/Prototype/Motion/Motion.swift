//
//  Motion.swift
//  Prototype
//
//  Created by 김성훈 on 12/17/25.
//

import SwiftUI

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
