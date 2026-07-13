//
//  FallingItem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/14/26.
//

import Foundation

enum FallingItemType {
    case smallGold
    case largeGold
    case bug
}

struct FallingItem: Identifiable {
    let id = UUID()
    let type: FallingItemType
    var position: CGPoint
    let size: CGSize = CGSize(width: 24, height: 24)

    mutating func updatePosition(by offset: CGFloat) {
        position.y += offset
    }
}
