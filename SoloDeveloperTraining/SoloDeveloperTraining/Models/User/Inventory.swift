//
//  Inventory.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

final class Inventory {
    
    // MARK: - 장비 아이템
    /// 키보드
    var keyboard: Equipment
    /// 마우스
    var mouse: Equipment
    /// 모니터
    var monitor: Equipment
    /// 의자
    var chair: Equipment
    
    // MARK: - 소비 아이템
    /// 커피 갯수
    var coffeeCount: Int
    /// 에너지 드링크
    var energyDrinkCount : Int

    // MARK: - 부동산 아이템
    /// 부동산
    var housing: Housing
    
    init(
        keyboard: Equipment = .init(tier: .broken),
        mouse: Equipment = .init(tier: .broken),
        monitor: Equipment = .init(tier: .broken),
        chair: Equipment = .init(tier: .broken),
        coffeeCount: Int = 0,
        energyDrinkCount: Int = 0,
        housing: Housing = .street
    ) {
        self.keyboard = keyboard
        self.mouse = mouse
        self.monitor = monitor
        self.chair = chair
        self.coffeeCount = coffeeCount
        self.energyDrinkCount = energyDrinkCount
        self.housing = housing
    }
    
    
    /// 커피 아이템을 사용합니다.
    /// - Returns: 사용 성공 여부
    func drinkCoffee() -> Bool {
        guard coffeeCount > 0 else { return false }
        coffeeCount -= 1
        return true
    }
    
    /// 에너지 드링크 아이템을 사용합니다.
    /// - Returns: 사용 성공 여부
    func drinkEnergyDrink() -> Bool {
        guard energyDrinkCount > 0 else { return false }
        energyDrinkCount -= 1
        return true
    }
}
