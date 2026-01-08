//
//  User.swift
//  SoloDeveloperTraining
//
//  Created by SeoJunYoung on 1/6/26.
//

import Foundation

actor User {
    /// 유저 식별용 ID
    let id: UUID
    /// 유저 닉네임
    let nickname: String
    /// 커리어
    let career: Career
    /// 지갑 [재산, 다이아]
    let wallet: Wallet
    /// 인벤토리 [장비, 소비, 부동산] 아이템
    let inventory: Inventory
    /// 게임 기록
    let record: Record
    /// 보유 업적
    let achievements: [Achievement]
    /// 보유 스킬
    let skills: [Skill]

    init(
        id: UUID = UUID(),
        nickname: String,
        career: Career = .unemployed,
        wallet: Wallet,
        inventory: Inventory,
        record: Record,
        achievements: [Achievement] = [],
        skills: [Skill] = []
    ) {
        self.id = id
        self.nickname = nickname
        self.career = career
        self.wallet = wallet
        self.inventory = inventory
        self.record = record
        self.achievements = achievements
        self.skills = skills
    }
}
