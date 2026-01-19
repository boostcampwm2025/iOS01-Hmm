//
//  Item.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/19/26.
//

import Foundation

/// 상점 아이템 모델
struct Item: Identifiable {
    /// 아이템 고유 ID
    var id: UUID = .init()
    /// 아이템 제목
    let title: String
    /// 아이템 설명
    let description: String
    /// 아이템 가격
    let cost: Cost
    /// 아이템 타입
    let type: ItemType
}

/// 아이템 타입 구분
enum ItemType {
    /// 장비 아이템
    case equipment(Equipment)
    /// 소비 아이템
    case consumable(Consumable)
    /// 부동산 아이템
    case housing(Housing)
}
