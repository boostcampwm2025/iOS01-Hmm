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

    /// 아이템 인벤토리
    private(set) var inventory: Inventory

    init(nickname: String, wallet: Wallet, skillSet: SkillSet, inventory: Inventory) {
        self.nickname = nickname
        self.wallet = wallet
        self.skillSet = skillSet
        self.inventory = inventory
    }
}
