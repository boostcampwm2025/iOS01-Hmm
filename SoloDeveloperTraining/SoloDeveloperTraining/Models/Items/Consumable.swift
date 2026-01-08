//
//  Consumable.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/8/26.
//

import Foundation

/// 소비 아이템 클래스
final class Consumable {
    /// 소비 아이템 타입
    let type: ConsumableType
    /// 보유 개수
    private(set) var count: Int

    /// 소비 아이템 초기화
    init(type: ConsumableType, count: Int) {
        self.type = type
        self.count = count
    }

    /// 화면에 표시될 제목
    var displayTitle: String {
        return type.displayTitle + " (보유:\(count)개)"
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
}
