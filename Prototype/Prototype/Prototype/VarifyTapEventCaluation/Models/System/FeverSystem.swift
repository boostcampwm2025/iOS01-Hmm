//
//  FeverSystem.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

final class FeverSystem {
    /// 현재 피버 단계 (0~3)
    private(set) var currentLevel: Int = 0
    
    /// 최대 피버 단계
    let maxLevel: Int = 3
    
    /// 현재 피버 단계의 배율을 반환합니다.
    /// - Returns: 피버 배율
    func getCurrentMultiplier() -> Double {
        Policy.feverMultipliers[currentLevel] ?? 1.0
    }
    
    /// 피버 단계를 1 증가시킵니다.
    /// - Returns: 증가 성공 시 `true`, 최대 단계 도달 시 `false`
    @discardableResult
    func levelUp() -> Bool {
        guard currentLevel < maxLevel else {
            return false
        }
        currentLevel += 1
        return true
    }
    
    /// 피버 단계를 1 감소시킵니다.
    /// - Returns: 감소 성공 시 `true`, 이미 0단계인 경우 `false`
    @discardableResult
    func levelDown() -> Bool {
        guard currentLevel > 0 else {
            return false
        }
        currentLevel -= 1
        return true
    }
    
    /// 피버를 초기화합니다.
    func reset() {
        currentLevel = 0
    }
}
