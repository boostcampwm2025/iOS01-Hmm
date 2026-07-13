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
        case .reachedMax:   return .disabled
        }
    }

    func housingCardState(isSelected: Bool) -> HousingCard.HousingCardState {
        switch self {
        case .available:    return isSelected ? .selected : .default
        case .insufficient: return .disabled
        case .locked:       return .locked
        case .reachedMax:   return .equipped
        }
    }
}

extension MissionLevel {
    var trophyType: MissionCard.MissionTrophyType {
        switch self {
        case .gold:    return .gold
        case .silver:  return .silver
        case .bronze:  return .bronze
        case .special: return .special
        }
    }
}

extension MissionCardState {
    var missionCardState: MissionCard.MissionCardState {
        switch self {
        case .claimed:                              return .claimed
        case .claimable:                            return .claimable
        case .inProgress(let current, let total):   return .inProgress(current: current, total: total)
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
