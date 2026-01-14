//
//  CurrencyLabel.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-12.
//

import SwiftUI

private enum Constants {
    static let iconTextSpacing: CGFloat = 3
}

struct CurrencyLabel: View {
    private let axis: Axis
    private let icon: Icon
    private let textStyle: TypographyStyle
    private let value: Int

    init(axis: Axis, icon: Icon, textStyle: TypographyStyle = .caption, value: Int) {
        self.axis = axis
        self.icon = icon
        self.textStyle = textStyle
        self.value = value
    }

    var body: some View {
        switch axis {
        case .vertical:
            VStack(spacing: Constants.iconTextSpacing) {
                switch icon {
                case .diamond: Image(.iconDiamondGreen)
                case .gold: Image(.iconCoinBag)
                }

                Text(value.formatted)
                    .textStyle(textStyle)
            }

        case .horizontal:
            HStack(spacing: Constants.iconTextSpacing) {
                switch icon {
                case .diamond: Image(.iconDiamondGreen)
                case .gold: Image(.iconCoinBag)
                }

                Text(value.formatted)
                    .textStyle(textStyle)
            }
        }
    }
}

extension CurrencyLabel {
    enum Axis {
        case vertical
        case horizontal
    }

    enum Icon {
        case diamond
        case gold
    }
}

#Preview {
    CurrencyLabel(axis: .vertical, icon: .diamond, textStyle: .body, value: 30540)
    CurrencyLabel(axis: .vertical, icon: .gold, textStyle: .callout, value: 30540)
    CurrencyLabel(axis: .horizontal, icon: .diamond, textStyle: .caption, value: 30540)
    CurrencyLabel(axis: .horizontal, icon: .gold, textStyle: .headline, value: 30540)
}
