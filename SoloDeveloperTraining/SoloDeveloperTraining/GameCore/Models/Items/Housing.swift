//
//  Housing.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

enum Housing: CaseIterable {
    case street
    case semiBasement
    case rooftop
    case villa
    case apartment
    case house
    case pentHouse

    var imageName: String {
        switch self {
        case .street: return "background_street"
        case .semiBasement: return "background_semiBasement"
        case .rooftop: return "background_rooftop"
        case .villa: return "background_villa"
        case .apartment: return "background_apartment"
        case .house: return "background_house"
        case .pentHouse: return "background_pentHouse"
        }
    }

    var displayTitle: String {
        switch self {
        case .street:
            return "길바닥"
        case .semiBasement:
            return "반지하"
        case .rooftop:
            return "옥탑방"
        case .villa:
            return "빌라"
        case .apartment:
            return "아파트"
        case .house:
            return "단독주택"
        case .pentHouse:
            return "펜트 하우스"
        }
    }

    /// 구입 비용
    var cost: Cost {
        switch self {
        case .street:
            return .init(gold: 0)
        case .semiBasement:
            return .init(gold: 500_000)
        case .rooftop:
            return .init(gold: 1_000_000)
        case .villa:
            return .init(gold: 2_500_000)
        case .apartment:
            return .init(gold: 5_000_000)
        case .house:
            return .init(gold: 10_000_000)
        case .pentHouse:
            return .init(gold: 50_000_000)
        }
    }

    /// 초 당 획득 골드
    var goldPerSecond: Int {
        switch self {
        case .street:
            return 0
        case .semiBasement:
            return 20
        case .rooftop:
            return 50
        case .villa:
            return 100
        case .apartment:
            return 250
        case .house:
            return 500
        case .pentHouse:
            return 1000
        }
    }
}
