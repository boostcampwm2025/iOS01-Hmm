//
//  FeedbackSettingView.swift
//  SoloDeveloperTraining
//

import SwiftUI

private enum Constant {
    static let title: String = "설정"
    static let rowSpacing: CGFloat = 30
    static let horizontalPadding: CGFloat = 20
    static let volumeRange: ClosedRange<Double> = 0 ... 100
    static let volumeStep: Double = 1
}

struct FeedbackSettingView: View {
    let onClose: (() -> Void)?

    var body: some View {
        Popup(title: "") {
            Text("설정")
                .textStyle(.largeTitle)
            VStack(alignment: .leading, spacing: Constant.rowSpacing) {
                soundSettingSection(
                    title: "배경음",
                    isOn: SoundService.shared.isBGMEnabled,
                    setOn: { SoundService.shared.isBGMEnabled = $0 },
                    volume: bgmVolumeBinding
                )
                soundSettingSection(
                    title: "효과음",
                    isOn: SoundService.shared.isSFXEnabled,
                    setOn: { SoundService.shared.isSFXEnabled = $0 },
                    volume: sfxVolumeBinding
                )
                settingRow(
                    title: "햅틱",
                    isOn: HapticService.shared.isEnabled,
                    setOn: { HapticService.shared.isEnabled = $0 }
                )
                closeButton
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Constant.horizontalPadding)
        }
    }
}

private extension FeedbackSettingView {
    var bgmVolumeBinding: Binding<Double> {
        Binding(
            get: { Double(SoundService.shared.bgmVolume) },
            set: { SoundService.shared.bgmVolume = min(max(Int($0), 0), 100) }
        )
    }

    var sfxVolumeBinding: Binding<Double> {
        Binding(
            get: { Double(SoundService.shared.sfxVolume) },
            set: { SoundService.shared.sfxVolume = min(max(Int($0), 0), 100) }
        )
    }

    var closeButton: some View {
        HStack {
            Spacer()
            MediumButton(title: "닫기", isFilled: true) {
                onClose?()
            }
            Spacer()
        }
    }

    func soundSettingSection(
        title: String,
        isOn: Bool,
        setOn: @escaping (Bool) -> Void,
        volume: Binding<Double>
    ) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            settingRow(title: title, isOn: isOn, setOn: setOn)
            SettingSlider(value: volume, range: Constant.volumeRange, step: Constant.volumeStep, isEnabled: isOn)
        }
    }

    func settingRow(title: String, isOn: Bool, setOn: @escaping (Bool) -> Void) -> some View {
        HStack {
            Text(title)
                .textStyle(.title2)
            Spacer()
            MediumButton(title: isOn ? "ON" : "OFF", isFilled: isOn) {
                var transaction = Transaction()
                transaction.animation = nil
                withTransaction(transaction) {
                    setOn(!isOn)
                }
            }
            .transaction { $0.animation = nil }
        }
    }
}

#Preview {
    FeedbackSettingView {

    }
        .padding(25)
}
