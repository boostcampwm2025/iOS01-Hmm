//
//  Housing.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

struct Housing: Item {
    // MARK: - Item
    var displayTitle: String {
        return tier.displayTitle
    }
    var description: String {
        return "초 당 획득 골드 +\(goldPerSecond)"
    }
    var cost: Cost {
        return tier.cost
    }
    var imageName: String {
        return tier.imageName
    }
    var category: ItemCategory = .housing

    // MARK: - Housing
    /// 초 당 획득 골드
    var goldPerSecond: Int {
        return tier.goldPerSecond
    }
    let tier: HousingTier
}

enum HousingTier: Int, CaseIterable {
    case street = 0
    case semiBasement = 1
    case rooftop = 2
    case villa = 3
    case apartment = 4
    case house = 5
    case pentHouse = 6

    var imageName: String {
        switch self {
        case .street: return "housing_street"
        case .semiBasement: return "housing_semiBasement"
        case .rooftop: return "housing_rooftop"
        case .villa: return "housing_villa"
        case .apartment: return "housing_apartment"
        case .house: return "housing_house"
        case .pentHouse: return "housing_pentHouse"
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
            return .init(gold: Policy.Housing.streetPurchaseCost)
        case .semiBasement:
            return .init(gold: Policy.Housing.semiBasementPurchaseCost)
        case .rooftop:
            return .init(gold: Policy.Housing.rooftopPurchaseCost)
        case .villa:
            return .init(gold: Policy.Housing.villaPurchaseCost)
        case .apartment:
            return .init(gold: Policy.Housing.apartmentPurchaseCost)
        case .house:
            return .init(gold: Policy.Housing.housePurchaseCost)
        case .pentHouse:
            return .init(gold: Policy.Housing.pentHousePurchaseCost)
        }
    }

    /// 초 당 획득 골드
    var goldPerSecond: Int {
        switch self {
        case .street:
            return Policy.Housing.streetGoldPerSecond
        case .semiBasement:
            return Policy.Housing.semiBasementGoldPerSecond
        case .rooftop:
            return Policy.Housing.rooftopGoldPerSecond
        case .villa:
            return Policy.Housing.villaGoldPerSecond
        case .apartment:
            return Policy.Housing.apartmentGoldPerSecond
        case .house:
            return Policy.Housing.houseGoldPerSecond
        case .pentHouse:
            return Policy.Housing.pentHouseGoldPerSecond
        }
    }
}
