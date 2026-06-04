//
//  DUIcon.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/31/26.
//

import SwiftUI

public enum DUIconName: String, CaseIterable {
    case coinBag       = "icon_coin_bag"
    case coinStack     = "icon_coin_stack"
    case minus         = "icon_minus"
    case plus          = "icon_plus"
    case cancel        = "icon_cancel"
    case close         = "icon_close"
    case coffee        = "icon_coffee"
    case diamond       = "icon_diamond"
    case diamondPlus   = "icon_diamond_plus"
    case dropBug       = "icon_drop_bug"
    case dropLargeGold = "icon_drop_large_gold"
    case dropSmallGold = "icon_drop_small_gold"
    case energyDrink   = "icon_energy_drink"
    case lock          = "icon_lock"
    case mission       = "icon_mission"
    case newBadge      = "icon_new_badge"
    case play          = "icon_play"
    case shop          = "icon_shop"
    case skill         = "icon_skill"
    case work          = "icon_work"
    case ad            = "icon_ad"
}

public struct DUIcon: View {
    private let name: DUIconName
    private let size: TokenIconSize

    public init(_ name: DUIconName, size: TokenIconSize) {
        self.name = name
        self.size = size
    }

    public var body: some View {
        Image(name.rawValue, bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(width: size.rawValue, height: size.rawValue)
    }
}
