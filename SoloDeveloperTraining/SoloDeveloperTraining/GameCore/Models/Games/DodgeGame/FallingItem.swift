//
//  FallingItem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/14/26.
//

import Foundation

struct FallingItem: Identifiable {
    /// 고유 식별자
    let id = UUID()
    /// 아이템 타입 (smallGold, largeGold, bug)
    let type: DropItem.DropItemType
    /// 화면 상의 위치 (중심점 기준)
    var position: CGPoint
    /// 아이템 크기
    let size: CGSize = CGSize(width: 24, height: 24)

    /// 아이템 위치를 업데이트
    /// - Parameter offset: Y축 이동 오프셋
    mutating func updatePosition(by offset: CGFloat) {
        position.y += offset
    }
}
