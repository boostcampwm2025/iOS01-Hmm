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
        static let currentMoney: String = "$100,000"
        static let currencyPerTapHeader: String = "탭 당 획득 재산"
        static let navigationTitle: String = "탭 이벤트 연산 확인"
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
}

struct VarifyTapEventCalculationView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constant.Spacing.section) {
            descriptionSection
            dashBoardSection
            Spacer()
        }
        .padding()
        .navigationTitle(Constant.Text.navigationTitle)
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
            
            Text(Constant.Text.currentMoney)
                .font(Constant.Fonts.large)
                .foregroundStyle(Constant.Colors.primary)
            
            Text(Constant.Text.currencyPerTapHeader)
                .font(Constant.Fonts.subTitle)
            
            Text(Constant.Text.currentMoney)
                .font(Constant.Fonts.large)
                .foregroundStyle(Constant.Colors.primary)
            Divider()
        }
    }
}

#Preview {
    VarifyTapEventCalculationView()
}
