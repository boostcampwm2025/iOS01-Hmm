//
//  User.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

actor User {
    /// 닉네임
    let nickname: String
    
    /// 재화 지갑
    private(set) var wallet: Wallet
    
    /// 유저의 스킬 목록
    private(set) var skillSet: SkillSet
    
    init(nickname: String, wallet: Wallet, skillSet: SkillSet) {
        self.nickname = nickname
        self.wallet = wallet
        self.skillSet = skillSet
    }
}
