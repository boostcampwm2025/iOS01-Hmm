//
//  FeedbackSettingView.swift
//  SoloDeveloperTraining
//

import SwiftUI

private enum Constant {
    static let title: String = "설정"
    static let rowSpacing: CGFloat = 25
    static let horizontalPadding: CGFloat = 20
    static let volumeRange: ClosedRange<Double> = 0 ... 100
    static let volumeStep: Double = 1
}

struct FeedbackSettingView: View {
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

    func soundSettingSection(
        title: String,
        isOn: Bool,
        setOn: @escaping (Bool) -> Void,
        volume: Binding<Double>
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            settingRow(title: title, isOn: isOn, setOn: setOn)
            SettingSlider(value: volume, range: Constant.volumeRange, step: Constant.volumeStep)
        }
    }

    func settingRow(title: String, isOn: Bool, setOn: @escaping (Bool) -> Void) -> some View {
        HStack {
            Text(title)
                .textStyle(.body)
            Spacer()
            MediumButton(title: isOn ? "ON" : "OFF", isFilled: isOn) {
                setOn(!isOn)
            }
        }
    }
}

#Preview {
    FeedbackSettingView()
        .padding(25)
}
