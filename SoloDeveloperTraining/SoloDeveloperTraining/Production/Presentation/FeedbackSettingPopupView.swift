//
//  FeedbackSettingPopupView.swift
//  SoloDeveloperTraining
//

import SwiftUI

private enum Constant {
    static let title: String = "설정"
    static let rowSpacing: CGFloat = 16
    static let horizontalPadding: CGFloat = 20
    static let volumeRange: ClosedRange<Double> = 0 ... 100
    static let volumeStep: Double = 1
}

struct FeedbackSettingPopupView: View {
    var body: some View {
        Popup(title: Constant.title) {
            VStack(alignment: .leading, spacing: Constant.rowSpacing) {
                soundSettingSection(
                    title: "배경음",
                    isOn: SoundService.shared.isBGMEnabled,
                    setOn: { SoundService.shared.isBGMEnabled = $0 },
                    volume: bgmVolumeBinding
                )
                soundSettingSection(
                    title: "효과음",
                    isOn: SoundService.shared.isEnabled,
                    setOn: { SoundService.shared.isEnabled = $0 },
                    volume: sfxVolumeBinding
                )
                settingRow(
                    title: "햅틱",
                    isOn: HapticService.shared.isEnabled,
                    setOn: { HapticService.shared.isEnabled = $0 }
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Constant.horizontalPadding)
        }
    }

    private func soundSettingSection(
        title: String,
        isOn: Bool,
        setOn: @escaping (Bool) -> Void,
        volume: Binding<Double>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            settingRow(title: title, isOn: isOn, setOn: setOn)
            Slider(value: volume, in: Constant.volumeRange, step: Constant.volumeStep)
        }
    }

    private func settingRow(title: String, isOn: Bool, setOn: @escaping (Bool) -> Void) -> some View {
        HStack {
            Text(title)
                .textStyle(.body)
                .foregroundColor(.black)
            Spacer()
            MediumButton(title: isOn ? "ON" : "OFF", isFilled: isOn) {
                setOn(!isOn)
            }
        }
    }

    private var bgmVolumeBinding: Binding<Double> {
        Binding(
            get: { Double(SoundService.shared.bgmVolume) },
            set: {
                let value = Int($0.rounded())
                SoundService.shared.bgmVolume = min(max(value, 0), 100)
            }
        )
    }

    private var sfxVolumeBinding: Binding<Double> {
        Binding(
            get: { Double(SoundService.shared.sfxVolume) },
            set: {
                let value = Int($0.rounded())
                SoundService.shared.sfxVolume = min(max(value, 0), 100)
            }
        )
    }
}

#Preview {
    FeedbackSettingPopupView()
        .padding()
        .background(Color.gray.opacity(0.2))
}
