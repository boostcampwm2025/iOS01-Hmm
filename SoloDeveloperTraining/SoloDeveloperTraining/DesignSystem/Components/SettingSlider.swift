//
//  SettingSlider.swift
//  SoloDeveloperTraining
//

import SwiftUI

private enum Constant {
    static let thumbDiameter: CGFloat = 24
    static var trackHeight: CGFloat { thumbDiameter / 2 }
    static var trackCornerRadius: CGFloat { trackHeight / 2 }
}

struct SettingSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double> = 0 ... 100
    var step: Double = 1

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
                // 트랙 배경 (썸 세로의 절반)
                RoundedRectangle(cornerRadius: Constant.trackCornerRadius)
                    .fill(AppColors.beige300)
                    .frame(height: Constant.trackHeight)

                // 진행 채움 (썸 세로의 절반)
                RoundedRectangle(cornerRadius: Constant.trackCornerRadius)
                    .fill(AppColors.orange300)
                    .frame(width: max(0, thumbCenterX), height: Constant.trackHeight)

                // 썸
                Circle()
                    .fill(AppColors.orange500)
                    .frame(width: Constant.thumbDiameter, height: Constant.thumbDiameter)
                    .overlay {
                        Circle()
                            .stroke(Color.black.opacity(0.15), lineWidth: 1)
                    }
                    .offset(x: thumbCenterX - Constant.thumbDiameter / 2)
            }
            .frame(height: Constant.thumbDiameter)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        applyValue(from: gesture.location.x, trackWidth: width)
                    }
            )
            .onTapGesture { location in
                applyValue(from: location.x, trackWidth: width)
            }
        }
        .frame(height: Constant.thumbDiameter)
    }

    private func applyValue(from locationX: CGFloat, trackWidth: CGFloat) {
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
