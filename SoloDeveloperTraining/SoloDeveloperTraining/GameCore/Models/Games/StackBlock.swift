//
//  StackBlock.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-14.
//

import Foundation

enum BlockType: CaseIterable {
    case blue
    case green
    case orange
    case purple
    case red
    case yellow
    case bomb
    case bomb2

    var size: CGSize {
        switch self {
        case .blue: return CGSize(width: 60, height: 20)
        case .green: return CGSize(width: 70, height: 22)
        case .orange: return CGSize(width: 50, height: 17)
        case .purple: return CGSize(width: 80, height: 25)
        case .red: return CGSize(width: 40, height: 19)
        case .yellow: return CGSize(width: 90, height: 21)
        case .bomb: return CGSize(width: 40, height: 18)
        case .bomb2: return CGSize(width: 30, height: 40)
        }
    }

    var imageName: String {
        switch self {
        case .blue: return "stack_block_blue"
        case .green: return "stack_block_green"
        case .orange: return "stack_block_orange"
        case .purple: return "stack_block_purple"
        case .red: return "stack_block_red"
        case .yellow: return "stack_block_yellow"
        case .bomb: return "stack_block_bomb"
        case .bomb2: return "stack_block_bomb2"
        }
    }

    /// 폭탄 블록인지 확인
    var isBomb: Bool {
        self == .bomb || self == .bomb2
    }
}

struct StackBlock {
    let type: BlockType
    var positionX: CGFloat
    var positionY: CGFloat

    var width: CGFloat {
        type.size.width
    }

    var height: CGFloat {
        type.size.height
    }
}
