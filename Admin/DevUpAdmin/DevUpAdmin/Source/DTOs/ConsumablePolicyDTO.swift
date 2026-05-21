//
//  ConsumablePolicyDTO.swift
//  SoloDeveloperTraining
//
//  Created by sunjae on 4/25/26.
//

struct ConsumablePolicyDTO: Codable {
    let coffee: CoffeeDTO
    let energyDrink: EnergyDrinkDTO
}

struct CoffeeDTO: Codable {
    let duration: Int
    let buffMultiplier: Double
    let priceDiamond: Int
}

struct EnergyDrinkDTO: Codable {
    let duration: Int
    let buffMultiplier: Double
    let priceDiamond: Int
}
