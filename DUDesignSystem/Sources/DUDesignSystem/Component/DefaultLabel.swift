//
//  DefaultLabel.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 6/4/26.
//

import SwiftUI

public struct DefaultLabel: View {
    
    public enum LabelSize {
        case small
        case medium
        case large
    }
    
    public enum LabelColor {
        case white
        case black
    }
    
    public var text: String
    public var icon: DUIconName?
    public var size: LabelSize
    public var color: LabelColor
    
    public init(text: String, icon: DUIconName? = nil, size: LabelSize, color: LabelColor) {
        self.text = text
        self.icon = icon
        self.size = size
        self.color = color
    }
    
    public var body: some View {
        HStack(spacing: TokenSpacing.xs) {
            if let icon = icon {
                switch size {
                case .small:
                    DUIcon(icon, size: .size15)
                case .medium:
                    DUIcon(icon, size: .size18)
                case .large:
                    DUIcon(icon, size: .size24)
                }
            }
            Text(text)
                .duFont(size == .large ? .headline : size == .medium ? .subheadline : .caption)
                .foregroundStyle(color == .white ? Color.white300 : Color.black300)
        }
    }
}
