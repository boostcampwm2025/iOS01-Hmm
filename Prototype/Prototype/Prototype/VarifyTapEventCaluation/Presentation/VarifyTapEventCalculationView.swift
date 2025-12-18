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
            // 피버 시스템 섹션
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

#Preview {
    NavigationStack {
        VarifyTapEventCalculationView()
    }
}
