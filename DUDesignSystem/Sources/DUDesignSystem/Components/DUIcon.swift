//
//  DUIcon.swift
//  DUDesignSystem
//
//  Created by SeoJunYoung on 5/31/26.
//

import SwiftUI

public enum DUIconName: String, CaseIterable {
    case coinBag     = "iconCoinBag"
    case coinStack   = "iconCoinStack"
    case minus       = "iconMinus"
    case plus        = "iconPlus"
    case cancel      = "iconCancel"
    case close       = "iconClose"
    case coffee      = "iconCoffee"
    case diamond     = "iconDiamond"
    case diamondPlus = "iconDiamondPlus"
    case energyDrink = "iconEnergyDrink"
    case lock        = "iconLock"
    case play        = "iconPlay"
    case ad          = "iconAd"
    case new         = "iconNew"
    case image       = "iconImage"
    case share       = "iconShare"
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
