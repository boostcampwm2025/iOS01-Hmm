//
//  CareerPopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/22/26.
//

import SwiftUI

private enum Constant {
    static let contentHorizontalPadding: CGFloat = 16
    static let progressBarTopPadding: CGFloat = 18
    static let progressBarBottomPadding: CGFloat = 18
    static let careerRowSpacing: CGFloat = 10
    static let scrollViewBottomPadding: CGFloat = 45
}

struct CareerPopupView: View {
    let careerSystem: CareerSystem
    let user: User
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CareerProgressBar(
                career: careerSystem.currentCareer,
                totalEarnedMoney: user.record.totalEarnedMoney,
                progress: careerSystem.careerProgress
            )
            .padding(.bottom, Constant.progressBarBottomPadding)
            .padding(.top, Constant.progressBarTopPadding)

            ScrollView {
                VStack(spacing: Constant.careerRowSpacing) {
                    ForEach(Career.allCases, id: \.self) { career in
                        CareerRow(
                            career: career,
                            userCareer: careerSystem.currentCareer
                        )
                    }
                }
            }
            .scrollIndicators(.never)
            .padding(.bottom, Constant.scrollViewBottomPadding)

            MediumButton(title: "닫기", isFilled: true) {
                onClose()
            }
        }
        .padding(.horizontal, Constant.contentHorizontalPadding)
    }
}
