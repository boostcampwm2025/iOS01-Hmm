//
//  DisplayStateExtensions.swift
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

    func housingCardState(isSelected: Bool) -> HousingCard.HousingCardState {
        switch self {
        case .available, .insufficient: return isSelected ? .selected : .default
        case .locked:                   return .locked
        case .reachedMax:               return .equipped
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
