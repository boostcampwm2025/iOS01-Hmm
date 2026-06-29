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
        case .blue: return CGSize(width: 81, height: 30)
        case .green: return CGSize(width: 81, height: 47)
        case .orange: return CGSize(width: 120, height: 31)
        case .purple: return CGSize(width: 81, height: 29)
        case .red: return CGSize(width: 81, height: 30)
        case .yellow: return CGSize(width: 81, height: 29)
        case .bomb: return CGSize(width: 80, height: 52)
        case .bomb2: return CGSize(width: 64, height: 64)
        }
    }

    var imageName: String {
        switch self {
        case .blue: return "stackBlockBlue"
        case .green: return "stackBlockGreen"
        case .orange: return "stackBlockOrange"
        case .purple: return "stackBlockPurple"
        case .red: return "stackBlockRed"
        case .yellow: return "stackBlockYellow"
        case .bomb: return "stackBlockBomb"
        case .bomb2: return "stackBlockBomb2"
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
