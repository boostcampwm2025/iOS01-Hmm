//
//  User.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

actor User {
    /// 닉네임
    let nickname: String = "ProtoType"
    
    /// 재화 지갑
    private(set) var wallet: Wallet = .init(
        money: .init(amount: 0),
        diamond: .init(amount: 0)
    )
    
    /// 유저의 스킬 목록
    private(set) var skillSet: SkillSet = .init(currentSkillLevels: [:])
}
