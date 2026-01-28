//
//  Cost.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/7/26.
//

import Foundation

/// 아이템 비용 모델
struct Cost: Equatable {
    /// 골드 비용
    let gold: Int
    /// 다이아몬드 비용
    let diamond: Int

    /// 비용 초기화
    init(gold: Int = 0, diamond: Int = 0) {
        self.gold = gold
        self.diamond = diamond
    }
}
