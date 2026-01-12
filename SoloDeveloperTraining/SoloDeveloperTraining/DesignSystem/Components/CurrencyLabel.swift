//
//  CurrencyLabel.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-12.
//

import SwiftUI

struct CurrencyLabel: View {
    let axis: Axis
    let icon: Icon
    let textStyle: TypographyStyle
    let value: Int

    var body: some View {
        switch axis {
        case .vertical:
            VStack {
                switch icon {
                case .diamond: Image(.iconDiamondGreen)
                case .gold: Image(.iconCoinBag)
                }

                Text(value.formatted)
                    .textStyle(textStyle)
            }

        case .horizontal:
            HStack {
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
