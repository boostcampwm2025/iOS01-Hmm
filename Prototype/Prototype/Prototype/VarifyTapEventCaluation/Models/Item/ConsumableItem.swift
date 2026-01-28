//
//  ConsumableItem.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/18/25.
//

import Foundation

/// 소비 가능한 아이템
final class ConsumableItem {
    /// 아이템 이름
    let name: String

    /// 효과 지속 시간 (초)
    let duration: TimeInterval

    /// 보상 배율
    let multiplier: Double

    init(name: String, duration: TimeInterval, multiplier: Double) {
        self.name = name
        self.duration = duration
        self.multiplier = multiplier
    }
}
