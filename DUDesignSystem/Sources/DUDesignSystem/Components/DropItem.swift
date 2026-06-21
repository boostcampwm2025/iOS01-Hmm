//
//  DropItem.swift
//  DUDesignSystem
//
//  Created by 김성훈 on 6/22/26.
//

import SwiftUI

// TODO: Example 앱 추가
public struct DropItem: View {

    public enum DropItemType: String {
        case smallGold = "dodge_drop_small_gold"
        case largeGold = "dodge_drop_large_gold"
        case bug       = "dodge_drop_bug"
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
