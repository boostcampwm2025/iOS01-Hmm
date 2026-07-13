//
//  DropItem.swift
//  DUDesignSystem
//
//  Created by 김성훈 on 6/22/26.
//

import SwiftUI

public struct DropItem: View {

    public enum DropItemType: String {
        case smallGold = "dodgeDropSmallGold"
        case largeGold = "dodgeDropLargeGold"
        case bug       = "dodgeDropBug"
    }

    public var type: DropItemType

    public init(type: DropItemType) {
        self.type = type
    }

    public var body: some View {
        Image(type.rawValue, bundle: .module)
            .resizable()
            .frame(width: 24, height: 24)
    }
}

#Preview {
    HStack(spacing: TokenSpacing.md) {
        DropItem(type: .smallGold)
        DropItem(type: .largeGold)
        DropItem(type: .bug)
    }
    .padding(TokenSpacing.md)
    .background(Color.beige200)
}
