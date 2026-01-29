//
//  SettingSlider.swift
//  SoloDeveloperTraining
//

import SwiftUI

private enum Constant {
    static let thumbDiameter: CGFloat = 24
    static let thumbRadius: CGFloat = thumbDiameter / 2
    static let trackHeight: CGFloat = 12
    static let cornerRadius: CGFloat = 4
    static let strokeLineWidth: CGFloat = 1
    static let strokeOpacityEnabled: Double = 0.15
    static let strokeOpacityDisabled: Double = 0.08
    static let dragMinimumDistance: CGFloat = 0
}

struct SettingSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double> = 0 ... 100
    var step: Double = 1
    var isEnabled: Bool = true

    private var progress: Double {
        let span = range.upperBound - range.lowerBound
        guard span > 0 else { return 0 }
        return max(0, min(1, (value - range.lowerBound) / span))
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let thumbCenterX = width * progress

            ZStack(alignment: .leading) {
                // 트랙 배경
                RoundedRectangle(cornerRadius: Constant.cornerRadius)
                    .fill(trackBackgroundColor)
                    .frame(height: Constant.trackHeight)

                // 진행
                RoundedRectangle(cornerRadius: Constant.cornerRadius)
                    .fill(fillColor)
                    .frame(width: max(0, thumbCenterX), height: Constant.trackHeight)

                // 썸
                RoundedRectangle(cornerRadius: Constant.cornerRadius)
                    .fill(thumbColor)
                    .frame(width: Constant.thumbDiameter, height: Constant.thumbDiameter)
                    .overlay {
                        RoundedRectangle(cornerRadius: Constant.cornerRadius)
                            .stroke(
                                Color.black.opacity(isEnabled ? Constant.strokeOpacityEnabled : Constant.strokeOpacityDisabled),
                                lineWidth: Constant.strokeLineWidth
                            )
                    }
                    .offset(x: thumbCenterX - Constant.thumbRadius)
            }
            .frame(height: Constant.thumbDiameter)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .allowsHitTesting(isEnabled)
            .gesture(
                DragGesture(minimumDistance: Constant.dragMinimumDistance)
                    .onChanged { gesture in
                        guard isEnabled else { return }
                        applyValue(from: gesture.location.x, trackWidth: width)
                    }
            )
            .onTapGesture { location in
                guard isEnabled else { return }
                applyValue(from: location.x, trackWidth: width)
            }
        }
        .frame(height: Constant.thumbDiameter)
    }
}

private extension SettingSlider {
    var trackBackgroundColor: Color {
        AppColors.beige300
    }

    var fillColor: Color {
        isEnabled ? AppColors.orange300 : AppColors.gray300
    }

    var thumbColor: Color {
        isEnabled ? AppColors.orange500 : AppColors.gray400
    }

    func applyValue(from locationX: CGFloat, trackWidth: CGFloat) {
        guard trackWidth > 0 else { return }
        let progressRatio = max(0, min(1, locationX / trackWidth))
        var rawValue = range.lowerBound + progressRatio * (range.upperBound - range.lowerBound)
        if step > 0 {
            rawValue = (rawValue / step).rounded() * step
        }
        rawValue = max(range.lowerBound, min(range.upperBound, rawValue))
        value = rawValue
    }
}

#Preview {
    struct PreviewHolder: View {
        @State private var volume: Double = 60
        var body: some View {
            VStack(spacing: 24) {
                SettingSlider(value: $volume, range: 0 ... 100, step: 1)
                    .padding(.horizontal)
                Text("\(Int(volume))")
                    .textStyle(.body)
            }
            .padding()
        }
    }
    return PreviewHolder()
}
