//
//  FeedbackSettingView.swift
//  SoloDeveloperTraining
//

import SwiftUI
import DUDesignSystem

struct FeedbackSettingView: View {
    let onClose: (() -> Void)?

    @Bindable private var sound = SoundService.shared
    @Bindable private var haptic = HapticService.shared

    var body: some View {
        VStack(spacing: TokenSpacing.xxl) {
            VStack(spacing: TokenSpacing.xl) {
                ItemLabel(text: "설정", font: .title2, color: .black300)
                    .frame(maxWidth: .infinity, alignment: .center)

                VStack(spacing: TokenSpacing.xl) {
                    soundSettingRow(
                        title: "배경음",
                        isOn: sound.isBGMEnabled,
                        setOn: { sound.isBGMEnabled = $0 },
                        volume: bgmVolumeBinding
                    )
                    soundSettingRow(
                        title: "효과음",
                        isOn: sound.isSFXEnabled,
                        setOn: { sound.isSFXEnabled = $0 },
                        volume: sfxVolumeBinding
                    )
                    settingRow(
                        title: "햅틱",
                        isOn: haptic.isEnabled,
                        setOn: { haptic.isEnabled = $0 }
                    )
                }

                Divider()
                    .frame(height: 1)
                    .background(Color.black300GrayBar)

                appInfoSection
            }

            TextButton(text: "닫기", type: .primary, size: .medium) {
                sound.trigger(.click)
                onClose?()
            }
        }
        .analyticsScreen(.settings)
        .padding(TokenSpacing.lg)
        .background(Color.white300)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.lg).stroke(Color.gray700, lineWidth: 2))
        .padding(.horizontal, TokenGrid.marginPopUp)
    }
}

private extension FeedbackSettingView {
    var bgmVolumeBinding: Binding<Double> {
        Binding(
            get: { Double(sound.bgmVolume) },
            set: { sound.bgmVolume = min(max(Int($0), 0), 100) }
        )
    }

    var sfxVolumeBinding: Binding<Double> {
        Binding(
            get: { Double(sound.sfxVolume) },
            set: { sound.sfxVolume = min(max(Int($0), 0), 100) }
        )
    }

    func settingRow(title: String, isOn: Bool, setOn: @escaping (Bool) -> Void) -> some View {
        HStack {
            ItemLabel(text: title, font: .subheadline, color: .black300)
            Spacer()
            Image.duImage(isOn ? "settingOn" : "settingOff")
                .resizable()
                .frame(width: 28, height: 28)
                .onTapGesture {
                    var transaction = Transaction()
                    transaction.animation = nil
                    withTransaction(transaction) { setOn(!isOn) }
                }
        }
    }

    func soundSettingRow(
        title: String,
        isOn: Bool,
        setOn: @escaping (Bool) -> Void,
        volume: Binding<Double>
    ) -> some View {
        VStack(spacing: TokenSpacing.sm) {
            settingRow(title: title, isOn: isOn, setOn: setOn)
            SettingSliderView(value: volume, isEnabled: isOn)
        }
    }

    var appInfoSection: some View {
        VStack(alignment: .leading, spacing: TokenSpacing.md) {
            ItemLabel(text: "앱 정보", font: .caption, color: .black300)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: TokenSpacing.sm) {
                ItemLabel(text: "버전", font: .caption, color: .black300)
                ItemLabel(
                    text: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-",
                    font: .caption,
                    color: .black300
                )
            }

            HStack(alignment: .top, spacing: TokenSpacing.sm) {
                ItemLabel(text: "라이선스", font: .caption, color: .black300)
                VStack(alignment: .leading, spacing: TokenSpacing.none) {
                    ItemLabel(
                        text: "개발자 키우기 앱에는 오픈소스가 사용되었습니다.",
                        font: .label,
                        color: .black300,
                        textAlignment: .leading
                    )
                    .opacity(TokenOpacity.opacity60)
                }
            }
        }
    }
}

private struct SettingSliderView: View {
    @Binding var value: Double
    var isEnabled: Bool

    private var progress: Double {
        max(0, min(1, value / 100))
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let thumbX = width * progress

            ZStack(alignment: .leading) {
                DUDesignSystem.ProgressBar(
                    progress: progress,
                    fillColor: isEnabled ? Color.orange300 : Color.gray200
                )

                Rectangle()
                    .fill(isEnabled ? Color.orange500 : Color.gray400)
                    .frame(width: 20, height: 20)
                    .clipShape(RoundedRectangle(cornerRadius: TokenRadius.ss))
                    .offset(x: max(0, min(thumbX - 8, width - 16)))
            }
            .frame(height: 16)
            .contentShape(Rectangle())
            .allowsHitTesting(isEnabled)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        guard isEnabled else { return }
                        let ratio = max(0, min(1, gesture.location.x / width))
                        value = (ratio * 100 / 1).rounded() * 1
                    }
            )
            .onTapGesture { location in
                guard isEnabled else { return }
                let ratio = max(0, min(1, location.x / width))
                value = (ratio * 100 / 1).rounded() * 1
            }
        }
        .frame(height: 16)
    }
}

#Preview {
    ZStack {
        Color.beige200.ignoresSafeArea()
        FeedbackSettingView(onClose: {})
    }
}
