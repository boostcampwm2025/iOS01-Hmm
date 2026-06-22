//
//  EffectLabel.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/4/26.
//

import SwiftUI

public struct EffectLabel: View {
    public enum EffectLabelType {
        case plus
        case minus
    }
    
    public var type: EffectLabelType
    public var text: String
    public var onComplete: () -> Void
    
    @State private var opacity: Double = 1.0
    @State private var offsetY: CGFloat = 0
    @State private var shouldShow: Bool = true

    public init(type: EffectLabelType, text: String, onComplete: @escaping () -> Void = {}) {
        self.type = type
        self.text = text
        self.onComplete = onComplete
    }

    public var body: some View {
        if shouldShow {
            HStack(spacing: TokenSpacing.xs) {
                Text(type == .plus ? "+" : "-")
                    .duFont(.subheadline)
                    .foregroundStyle(type == .plus ? Color.lightGreen : Color.accentRed)
                DUIcon(.coinStack, size: .size20)
                Text(text)
                    .duFont(.subheadline)
                    .foregroundStyle(type == .plus ? Color.lightGreen : Color.accentRed)
            }
            .opacity(opacity)
            .offset(y: offsetY)
            .onAppear {
                runAnimation()
            }
        }
    }
}

private extension EffectLabel {
    func runAnimation() {
        Task {
            withAnimation(.easeOut(duration: 1.5)) {
                opacity = 0
                offsetY = -12
            }
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            shouldShow = false
            onComplete()
        }
    }
}
