//
//  ItemButtonExtensions.swift
//  SoloDeveloperTraining
//

import DUDesignSystem

extension ItemState {
    var itemButtonState: ItemButton.ItemButtonState {
        switch self {
        case .available:    return .default
        case .insufficient: return .disabled
        case .locked:       return .locked
        case .reachedMax:   return .locked
        }
    }
}

extension Cost {
    var itemButtonType: ItemButton.ItemButtonType {
        if gold > 0 && diamond > 0 {
            return .twoLine(firstText: gold.formatted, firstIcon: .coinBag, secondText: diamond.formatted, secondIcon: .diamond)
        } else if diamond > 0 {
            return .singleLine(text: diamond.formatted, icon: .diamond)
        } else {
            return .singleLine(text: gold.formatted, icon: .coinBag)
        }
    }
}
