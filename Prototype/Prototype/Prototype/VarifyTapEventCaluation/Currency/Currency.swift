//
//  Currency.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

/// 게임 내 화폐 시스템을 위한 공통 프로토콜
protocol Currency: AnyObject {
    /// 화폐 수량의 타입
    associatedtype Value: SignedNumeric & Comparable
    
    /// 현재 보유 중인 화폐 수량
    var amount: Value { get set }
    
    /// 지정된 수량만큼 화폐를 획득합니다.
    /// - Parameter value: 획득할 화폐 수량
    func earn(_ value: Value)
    
    /// 지정된 수량만큼 화폐를 소비합니다.
    /// - Parameter value: 소비할 화폐 수량
    /// - Returns: 소비 성공 시 `true`, 잔액 부족 시 `false`
    @discardableResult
    func spend(_ value: Value) -> Bool
}

extension Currency {
    func earn(_ value: Value) {
        amount += value
    }
    
    func spend(_ value: Value) -> Bool {
        guard amount >= value else { return false }
        amount -= value
        return true
    }
}
