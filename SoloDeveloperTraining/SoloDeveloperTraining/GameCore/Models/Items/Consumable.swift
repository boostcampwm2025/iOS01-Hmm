//
//  Consumable.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/8/26.
//

import Foundation

/// 소비 아이템 클래스
@Observable
final class Consumable: Item {
    // MARK: - Item
    var displayTitle: String {
        return type.displayTitle + " (보유:\(count)개)"
    }
    var description: String {
        return "사용시 골드 획득량 \(type.buffMultiplier)배 증가"
    }
    var cost: Cost {
        return type.cost
    }
    var imageName: String {
        return type.imageName
    }
    var category: ItemCategory = .consumable

    // MARK: - Consumable
    /// 소비 아이템 타입
    let type: ConsumableType
    /// 보유 개수
    private(set) var count: Int

    /// 소비 아이템 초기화
    init(type: ConsumableType, count: Int) {
        self.type = type
        self.count = count
    }

    /// 아이템 갯수 1 증가
    func addItem() {
        count += 1
    }

    /// 아이템  갯수 1 감소
    func spendItem() {
        count -= 1
    }
}

/// 소비 아이템 종류
enum ConsumableType {
    /// 커피
    case coffee
    /// 에너지 드링크
    case energyDrink

    /// 화면에 표시될 제목
    var displayTitle: String {
        switch self {
        case .coffee:
            return "커피"
        case .energyDrink:
            return "박하스"
        }
    }

    /// 버프 가중치
    var buffMultiplier: Double {
        switch self {
        case .coffee:
            return 1.5
        case .energyDrink:
            return 2.0
        }
    }

    /// 지속시간
    var duration: Int {
        switch self {
        case .coffee:
            return 30
        case .energyDrink:
            return 15
        }
    }

    /// 비용
    var cost: Cost {
        switch self {
        case .coffee:
            return .init(diamond: 5)
        case .energyDrink:
            return .init(diamond: 10)
        }
    }

    var imageName: String {
        switch self {
        case .coffee:
            return "icon_coffee"
        case .energyDrink:
            return "icon_energy_drink"
        }
    }
}
