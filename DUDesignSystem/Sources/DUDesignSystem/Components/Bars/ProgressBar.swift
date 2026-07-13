//
//  ProgressBar.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI

public struct ProgressBar: View {

    public var progress: Double
    public var fillColor: Color
    public var trackColor: Color

    public init(progress: Double, fillColor: Color = .orange300, trackColor: Color = .black300GrayBar) {
        self.progress = max(0, min(1, progress))
        self.fillColor = fillColor
        self.trackColor = trackColor
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .fill(trackColor)
                    .frame(height: 16)

                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .fill(fillColor)
                    .frame(width: geo.size.width * progress, height: 16)
            }
        }
        .frame(height: 16)
    }
}

#Preview {
    VStack(spacing: TokenSpacing.lg) {
        ProgressBar(progress: 0.6)
        ProgressBar(progress: 0.4)
        ProgressBar(progress: 0.9)
    }
    .padding(TokenSpacing.lg)
    .background(Color.beige200)
}
