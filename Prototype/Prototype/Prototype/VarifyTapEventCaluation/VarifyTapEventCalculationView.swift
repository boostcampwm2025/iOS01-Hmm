//
//  VarifyTapEventCalculationView.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

import SwiftUI
import Observation

fileprivate enum Constant {
    enum Text {
        static let description: String = """
        탭 이벤트로 재화를 획득하는 기능을 확인하며 해당 기능이 동작할 수 있는 구조를 설계합니다.
        """
        static let descriptionSectionHeader: String = "Description"
        static let currentMoneyHeader: String = "현재 재산"
        static let currencyPerTapHeader: String = "탭 당 획득 재산"
        static let navigationTitle: String = "탭 이벤트 연산 확인"
        static let tapArea: String = "Tap Button"
    }
    
    enum Fonts {
        static let large: Font = .system(size: 30, weight: .bold)
        static let title: Font = .system(size: 25, weight: .bold)
        static let subTitle: Font = .system(size: 20, weight: .semibold)
        static let body: Font = .system(size: 18, weight: .regular)
    }
    
    enum Spacing {
        static let section: CGFloat = 16
    }
    
    enum Colors {
        static let primary: Color = .blue
    }
    
    enum Size {
        static let tapButtonHeight: CGFloat = 50
    }
}

struct VarifyTapEventCalculationView: View {
    @State var viewModel = VarifyTapEventCalculationViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: Constant.Spacing.section) {
            descriptionSection
            dashBoardSection
            
            // 스킬 업그레이드 섹션
            VStack(alignment: .leading, spacing: 8) {
                Text("스킬 업그레이드")
                    .font(Constant.Fonts.subTitle)
                
                ForEach(viewModel.availableSkills, id: \.title) { skill in
                    HStack {
                        Text(skill.title)
                        Spacer()
                        Text("Lv. \(viewModel.skillLevels[skill.title] ?? 0)")
                        Button("+") {
                            viewModel.upgradeSkill(skill)
                        }
                        .buttonStyle(.bordered)
                        Button("-") {
                            viewModel.downgradeSkill(skill)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            
            Divider()
            
            Spacer()

            tapButton
        }
        .padding()
        .navigationTitle(Constant.Text.navigationTitle)
        .task {
            await viewModel.loadInitialData()
        }
    }
    
    @ViewBuilder
    var descriptionSection: some View {
        Text(Constant.Text.descriptionSectionHeader)
            .font(Constant.Fonts.body)
        Text(Constant.Text.description)
            .font(Constant.Fonts.body)
        Divider()
    }
    
    @ViewBuilder
    var dashBoardSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Constant.Text.currentMoneyHeader)
                .font(Constant.Fonts.subTitle)
            
            Text(String(format: "%.0f", viewModel.currentMoney))
                .font(Constant.Fonts.large)
                .foregroundStyle(Constant.Colors.primary)
        }

        VStack(alignment: .leading, spacing: 0) {
            Text(Constant.Text.currencyPerTapHeader)
                .font(Constant.Fonts.subTitle)
            
            Text(String(format: "%.0f", viewModel.moneyPerTap))
                .font(Constant.Fonts.large)
                .foregroundStyle(Constant.Colors.primary)
        }
        Divider()
    }
    
    @ViewBuilder
    var tapButton: some View {
        Button {
            viewModel.tap()
        } label: {
            Text(Constant.Text.tapArea)
                .font(Constant.Fonts.subTitle)
                .foregroundStyle(Color.white)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: Constant.Size.tapButtonHeight,
                    alignment: .center
                )
                .background(Constant.Colors.primary)
                .cornerRadius(10)
        }
    }
}

@Observable
final class VarifyTapEventCalculationViewModel {
    private let user: User
    private let tapSystem: TapGameSystem
    
    // UI 상태
    var currentMoney: Double = 0
    var moneyPerTap: Double = 0
    var skillLevels: [String: Int] = [:]
    
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
        self.user = user
        self.tapSystem = .init(
            user: user,
            rewardCalculator: .init(user: user),
            feverSystem: .init()
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
    
    /// UI 상태 업데이트
    @MainActor
    private func updateUIState() async {
        currentMoney = await user.wallet.money.amount
        moneyPerTap = await tapSystem.rewardCalculator.calculateMoneyPerTap()
        skillLevels = await user.skillSet.currentSkillLevels
    }
}

#Preview {
    NavigationStack {
        VarifyTapEventCalculationView()
    }
}
