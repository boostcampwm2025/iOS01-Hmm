//
//  DropItem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/13/26.
//

import SwiftUI

private enum Constant {
    static let itemSize = CGSize(width: 24, height: 24)
}

struct DropItem: View {

    let type: DropItemType

    var body: some View {
        Image(type.imageResource)
            .resizable()
            .frame(width: Constant.itemSize.width, height: Constant.itemSize.height)
    }
}

extension DropItem {
    enum DropItemType {
        case smallGold
        case largeGold
        case bug

        var imageResource: ImageResource {
            switch self {
            case .smallGold:
                return .dodgeDropSmallGold
            case .largeGold:
                return .dodgeDropLargeGold
            case .bug:
                return .dodgeDropBug
            }
        }
    }
}

#Preview {
    HStack {
        DropItem(type: .smallGold)
        DropItem(type: .largeGold)
        DropItem(type: .bug)
    }
}
