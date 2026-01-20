//
//  ShopSystem.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

/// 상점 시스템 관리 클래스
final class ShopSystem {
    /// 사용자 정보
    private let user: User

    /// 상점 시스템 초기화
    init(user: User) {
        self.user = user
    }

    /// 상점에 표시될 아이템 목록 생성
    func itemList(itemTypes: [ItemType]) -> [DisplayItem] {
        return []
    }

    func buy(item: DisplayItem) throws {
    }
}

private extension ShopSystem {
}
