//
//  VarifyTapEventCalculationView.swift
//  Prototype
//
//  Created by SeoJunYoung on 12/17/25.
//

import SwiftUI

fileprivate enum Constant {
    enum Text {
        static let description: String = """
        클릭커 게임이 동작할 수 있는 구조를 설계 및 확인 합니다.
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
        ScrollView {
            VStack(alignment: .leading, spacing: Constant.Spacing.section) {
                descriptionSection
                Divider()
                dashBoardSection
                Divider()
                feverSection
                Divider()
                buffSection
                Divider()
                skillSection
                Divider()
                tapButton
            }
            .navigationTitle(Constant.Text.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .task {
                await viewModel.loadInitialData()
            }
        }
    }
    
    @ViewBuilder
    var descriptionSection: some View {
        Text(Constant.Text.descriptionSectionHeader)
            .font(Constant.Fonts.body)
        Text(Constant.Text.description)
            .font(Constant.Fonts.body)
    }
    
    @ViewBuilder
    var feverSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("피버 시스템")
                .font(Constant.Fonts.subTitle)

            HStack {
                Text("현재 단계: \(viewModel.feverLevel)")
                    .font(Constant.Fonts.body)
                Spacer()
                Text("배율: x\(String(format: "%.1f", viewModel.feverMultiplier))")
                    .font(Constant.Fonts.body)
                    .foregroundStyle(Constant.Colors.primary)
            }

            HStack(spacing: 8) {
                Button("단계 올리기") {
                    viewModel.increaseFeverLevel()
                }
                .buttonStyle(.bordered)

                Button("단계 내리기") {
                    viewModel.decreaseFeverLevel()
                }
                .buttonStyle(.bordered)

                Button("초기화") {
                    viewModel.resetFever()
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    @ViewBuilder
    var buffSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("버프 시스템 (소비 아이템)")
                .font(Constant.Fonts.subTitle)

            HStack {
                Text("버프 배율: x\(String(format: "%.1f", viewModel.buffMultiplier))")
                    .font(Constant.Fonts.body)
                Spacer()
                if viewModel.buffRemainingTime > 0 {
                    Text("남은 시간: \(Int(viewModel.buffRemainingTime))초")
                        .font(Constant.Fonts.body)
                        .foregroundStyle(.orange)
                }
            }

            HStack {
                Text(viewModel.doubleRewardItem.name)
                    .font(Constant.Fonts.body)
                Spacer()
                Text("보유: \(viewModel.itemCounts[viewModel.doubleRewardItem.name] ?? 0)개")
                    .font(Constant.Fonts.body)
            }

            HStack(spacing: 8) {
                Button("아이템 추가") {
                    viewModel.addItem()
                }
                .buttonStyle(.bordered)

                Button("아이템 사용") {
                    viewModel.useItem()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.buffRemainingTime > 0)
            }
        }
    }
    
    @ViewBuilder
    var skillSection: some View {
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
        .frame(height: Constant.Size.tapButtonHeight)
    }
}

#Preview {
    NavigationStack {
        VarifyTapEventCalculationView()
    }
}
