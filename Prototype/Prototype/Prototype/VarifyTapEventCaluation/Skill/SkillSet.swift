//
//  SkillSet.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

/// 사용자가 보유한 스킬들을 관리하는 구조체
class SkillSet {
    /// 스킬 이름을 키로, 현재 레벨을 값으로 가지는 딕셔너리
    private(set) var currentSkillLevels: [String: Int] = [:]
    
    /// 특정 스킬의 레벨을 1 증가시킵니다.
    /// - Parameter skill: 업그레이드할 스킬
    /// - Returns: 업그레이드 성공 시 `true`, 최대 레벨 도달 시 `false`
    @discardableResult
    func upgrade(skill: Skill) -> Bool {
        let currentLevel = currentSkillLevels[skill.title] ?? 0
        
        guard currentLevel < skill.maxUpgradeLevel else {
            return false
        }
        
        currentSkillLevels[skill.title] = currentLevel + 1
        return true
    }
}

private extension SkillSet {
    /// 특정 스킬의 현재 레벨을 반환합니다.
    /// - Parameter skill: 레벨을 확인할 스킬
    /// - Returns: 현재 레벨 (보유하지 않은 스킬은 0)
    func level(of skill: Skill) -> Int {
        currentSkillLevels[skill.title] ?? 0
    }
    
    /// 특정 스킬을 보유하고 있는지 확인합니다.
    /// - Parameter skill: 확인할 스킬
    /// - Returns: 보유 여부
    func hasSkill(_ skill: Skill) -> Bool {
        currentSkillLevels[skill.title] != nil
    }
    
    /// 특정 스킬이 최대 레벨에 도달했는지 확인합니다.
    /// - Parameter skill: 확인할 스킬
    /// - Returns: 최대 레벨 도달 여부
    func isMaxLevel(skill: Skill) -> Bool {
        level(of: skill) >= skill.maxUpgradeLevel
    }
}
