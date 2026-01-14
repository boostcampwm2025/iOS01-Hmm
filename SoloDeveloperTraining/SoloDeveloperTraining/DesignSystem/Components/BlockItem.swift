//
//  BlockItem.swift
//  SoloDeveloperTraining
//
//  Created by 최범수 on 2026-01-13.
//

import SpriteKit
import SwiftUI

final class BlockItem: SKSpriteNode {
    let blockType: BlockType

    init(type: BlockType = .blue) {
        self.blockType = type
        let texture = SKTexture(imageNamed: type.imageName)
        super.init(texture: texture, color: .clear, size: type.size)
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("BlockItem Preview")
            .font(.headline)

        ForEach(BlockType.allCases, id: \.self) { type in
            VStack(spacing: 8) {
                Text(String(describing: type))
                    .font(.caption)
                    .foregroundColor(.secondary)

                SpriteView(
                    scene: {
                        let scene = SKScene(size: type.size)
                        scene.backgroundColor = .clear
                        scene.scaleMode = .aspectFit

                        let block = BlockItem(type: type)
                        block.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
                        scene.addChild(block)

                        return scene
                    }(),
                    options: [.allowsTransparency]
                )
                .frame(width: type.size.width, height: type.size.height)
            }
        }
    }
    .padding()
}
