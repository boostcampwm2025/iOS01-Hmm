//
//  ProgressBar.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/7/26.
//

import SwiftUI

public struct ProgressBar: View {

    public var progress: Double

    public init(progress: Double) {
        self.progress = max(0, min(1, progress))
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .fill(Color.black300GrayBar)
                    .frame(height: 16)

                RoundedRectangle(cornerRadius: TokenRadius.ss)
                    .fill(Color.orange300)
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
