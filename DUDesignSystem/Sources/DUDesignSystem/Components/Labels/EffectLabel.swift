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
    
    public init(type: EffectLabelType, text: String) {
        self.type = type
        self.text = text
    }
    
    public var body: some View {
        HStack(spacing: TokenSpacing.xs) {
            Text(type == .plus ? "+" : "-")
                .duFont(.subheadline)
                .foregroundStyle(type == .plus ? Color.lightGreen : Color.accentRed)
            DUIcon(.coinStack, size: .size18)
            Text(text)
                .duFont(.subheadline)
                .foregroundStyle(type == .plus ? Color.lightGreen : Color.accentRed)
        }
    }
}
