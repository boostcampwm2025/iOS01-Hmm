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
    @State var temp: Int = 0
    var body: some View {
        VStack(alignment: .leading, spacing: Constant.Spacing.section) {
            descriptionSection
            dashBoardSection
            Stepper("Fever", value: $temp)
            Stepper("웹 개발 초급", value: $temp)
            Stepper("웹 개발 중급", value: $temp)
            Stepper("웹 개발 고급", value: $temp)
            Stepper("마우스", value: $temp)
            Stepper("키보드", value: $temp)
            Stepper("의자", value: $temp)
            Text("소비 아이템")
            Spacer()

            tapButton
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
        }

        VStack(alignment: .leading, spacing: 0) {
            Text(Constant.Text.currencyPerTapHeader)
                .font(Constant.Fonts.subTitle)
            
            Text(Constant.Text.currentMoney)
                .font(Constant.Fonts.large)
                .foregroundStyle(Constant.Colors.primary)
        }
        Divider()
    }
    
    @ViewBuilder
    var tapButton: some View {
        Button {
            print("Tapped")
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
    VarifyTapEventCalculationView()
}
