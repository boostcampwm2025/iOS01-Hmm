//
//  VarifyTapEventCalculationViewModel.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/18/25.
//

import Observation
import Foundation

@Observable
final class VarifyTapEventCalculationViewModel {
    private let user: User
    private let tapSystem: TapGameSystem
    private let feverSystem: FeverSystem
    private let buffSystem: BuffSystem

    // UI 상태
    var currentMoney: Double = 0
    var moneyPerTap: Double = 0
    var skillLevels: [String: Int] = [:]
    var feverLevel: Int = 0
    var feverMultiplier: Double = 1.0
    var buffMultiplier: Double = 1.0
    var buffRemainingTime: TimeInterval = 0
    var itemCounts: [String: Int] = [:]

    // 사용 가능한 스킬 목록
    let availableSkills: [Skill] = [
        Skill(title: "웹 개발 초급", maxUpgradeLevel: 10),
        Skill(title: "웹 개발 중급", maxUpgradeLevel: 10),
        Skill(title: "웹 개발 고급", maxUpgradeLevel: 10)
    ]

    // 사용 가능한 아이템
    let doubleRewardItem = ConsumableItem(name: "2배 보상 물약", duration: 30, multiplier: 2.0)

    init() {
        let user = User(
            nickname: "ProtoType",
            wallet: .init(money: .init(amount: 0), diamond: .init(amount: 0)),
            skillSet: .init(),
            inventory: .init()
        )
        let feverSystem = FeverSystem()
        let buffSystem = BuffSystem()

        self.user = user
        self.feverSystem = feverSystem
        self.buffSystem = buffSystem
        self.tapSystem = TapGameSystem(
            user: user,
            rewardCalculator: .init(user: user, feverSystem: feverSystem, buffSystem: buffSystem),
            feverSystem: feverSystem
        )
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

    /// 아이템 추가 (검증용)
    func addItem() {
        Task {
            await user.inventory.add(item: doubleRewardItem, count: 1)
            await updateUIState()
        }
    }

    /// 아이템 사용
    func useItem() {
        Task {
            // 이미 버프가 활성화되어 있으면 사용 불가
            guard !buffSystem.isActive else {
                print("이미 버프가 활성화되어 있습니다.")
                return
            }

            // 인벤토리에서 아이템 사용
            let hasItem = await user.inventory.use(item: doubleRewardItem)
            guard hasItem else {
                print("아이템이 부족합니다.")
                return
            }

            // 버프 활성화
            buffSystem.activate(item: doubleRewardItem)
            await updateUIState()

            // 1초마다 UI 업데이트 (남은 시간 표시)
            startBuffTimer()
        }
    }

    /// 버프 타이머 시작
    private func startBuffTimer() {
        Task {
            while buffSystem.isActive {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1초
                await updateUIState()
            }
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
        buffMultiplier = buffSystem.currentMultiplier
        buffRemainingTime = buffSystem.remainingTime
        itemCounts[doubleRewardItem.name] = await user.inventory.count(of: doubleRewardItem)
    }
}
