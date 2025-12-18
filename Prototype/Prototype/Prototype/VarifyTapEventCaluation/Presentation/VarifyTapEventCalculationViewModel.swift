//
//  VarifyTapEventCalculationViewModel.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/18/25.
//

import Observation

@Observable
final class VarifyTapEventCalculationViewModel {
    private let user: User
    private let tapSystem: TapGameSystem
    private let feverSystem: FeverSystem
    
    // UI 상태
    var currentMoney: Double = 0
    var moneyPerTap: Double = 0
    var skillLevels: [String: Int] = [:]
    var feverLevel: Int = 0
    var feverMultiplier: Double = 1.0
    
    // 사용 가능한 스킬 목록
    let availableSkills: [Skill] = [
        Skill(title: "웹 개발 초급", maxUpgradeLevel: 10),
        Skill(title: "웹 개발 중급", maxUpgradeLevel: 10),
        Skill(title: "웹 개발 고급", maxUpgradeLevel: 10)
    ]
    
    init() {
        let user = User(
            nickname: "ProtoType",
            wallet: .init(money: .init(amount: 0), diamond: .init(amount: 0)),
            skillSet: .init()
        )
        let feverSystem = FeverSystem()
        
        self.user = user
        self.feverSystem = feverSystem
        self.tapSystem = TapGameSystem(user: user, rewardCalculator: .init(user: user, feverSystem: feverSystem), feverSystem: feverSystem)
    }
    
    /// 초기 데이터 로드
    func loadInitialData() async {
        await updateUIState()
    }
    
    /// 탭 이벤트
    func tap() {
        Task {
            let earned = await tapSystem.tap()
            await updateUIState()
            print("획득한 재산: \(earned)")
        }
    }
    
    /// 스킬 업그레이드
    func upgradeSkill(_ skill: Skill) {
        Task {
            let success = await user.skillSet.upgrade(skill: skill)
            if success {
                await updateUIState()
            }
        }
    }
    
    /// 스킬 다운그레이드
    func downgradeSkill(_ skill: Skill) {
        Task {
            let success = await user.skillSet.downgrade(skill: skill)
            if success {
                await updateUIState()
            }
        }
    }
    
    /// 피버 레벨 증가
    func increaseFeverLevel() {
        feverSystem.levelUp()
        Task {
            await updateUIState()
        }
    }
    
    /// 피버 레벨 감소
    func decreaseFeverLevel() {
        feverSystem.levelDown()
        Task {
            await updateUIState()
        }
    }
    
    /// 피버 초기화
    func resetFever() {
        feverSystem.reset()
        Task {
            await updateUIState()
        }
    }
    
    /// UI 상태 업데이트
    @MainActor
    private func updateUIState() async {
        currentMoney = await user.wallet.money.amount
        moneyPerTap = await tapSystem.rewardCalculator.calculateMoneyPerTap()
        skillLevels = await user.skillSet.currentSkillLevels
        feverLevel = feverSystem.currentLevel
        feverMultiplier = feverSystem.getCurrentMultiplier()
    }
}
