//
//  HousingPolicyDTO.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 4/25/26.
//

struct HousingPolicyDTO: Codable {
    let streetPurchaseCost: Int
    let semiBasementPurchaseCost: Int
    let rooftopPurchaseCost: Int
    let villaPurchaseCost: Int
    let apartmentPurchaseCost: Int
    let housePurchaseCost: Int
    let pentHousePurchaseCost: Int

    let streetGoldPerSecond: Int
    let semiBasementGoldPerSecond: Int
    let rooftopGoldPerSecond: Int
    let villaGoldPerSecond: Int
    let apartmentGoldPerSecond: Int
    let houseGoldPerSecond: Int
    let pentHouseGoldPerSecond: Int
}
