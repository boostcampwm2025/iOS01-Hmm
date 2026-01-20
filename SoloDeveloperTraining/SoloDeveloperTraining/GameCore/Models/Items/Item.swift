//
//  Item.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/20/26.
//

import Foundation

protocol Item {
    /// 화면에 표시될 제목
    var displayTitle: String { get }
    /// 아이템 설명
    var description: String { get }
    /// 아이템 구입 비용
    var cost: Cost { get }
    /// 아이템 이미지 이름
    var imageName: String { get }
    /// 아이템 카테고리 (소비/장비/부동산)
    var category: ItemCategory { get }
}

/// 아이템 카테고리
enum ItemCategory {
    /// 소비 아이템 (커피, 에너지 드링크 등)
    case consumable
    /// 장비 아이템 (노트북, 모니터 등)
    case equipment
    /// 부동산 (집, 사무실 등)
    case housing
}
