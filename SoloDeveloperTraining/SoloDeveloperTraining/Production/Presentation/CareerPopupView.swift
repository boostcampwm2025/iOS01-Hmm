//
//  CareerPopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/22/26.
//

import SwiftUI

import DUDesignSystem

struct CareerPopupView: View {
    let careerSystem: CareerSystem
    let user: User
    let onClose: () -> Void

    private var currentCareer: Career { careerSystem.currentCareer }
    private var nextCareer: Career? { currentCareer.nextCareer }

    var body: some View {
        VStack(spacing: TokenSpacing.xxl) {
            VStack(spacing: TokenSpacing.lg) {
                ItemLabel(text: "커리어", font: .title2, color: .black300)
                progressSection
                careerList
            }
            TextButton(text: "닫기", type: .primary, size: .medium, action: {
                SoundService.shared.trigger(.click)
                onClose()
            })
        }
        .padding(TokenSpacing.lg)
        .background(Color.white300)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.lg).stroke(Color.gray700, lineWidth: 2))
        .padding(.horizontal, TokenGrid.marginPopUp)
    }

    private var progressSection: some View {
        VStack(spacing: TokenSpacing.xs) {
            DUDesignSystem.ProgressBar(progress: careerSystem.careerProgress)
            HStack {
                ItemLabel(text: user.record.totalEarnedMoney.formatted, icon: .coinBag, iconSize: .size16, font: .caption, color: .black300)
                Spacer()
                ItemLabel(text: (nextCareer?.requiredWealth ?? 0).formatted, icon: .coinBag, iconSize: .size16, font: .caption, color: .black300)
            }
            HStack {
                ItemLabel(text: "누적", font: .caption, color: .black300)
                Spacer()
                ItemLabel(text: nextCareer?.rawValue ?? "", font: .caption, color: .black300)
            }
        }
    }

    private var careerList: some View {
        ScrollView {
            VStack(spacing: TokenSpacing.md) {
                ForEach(Career.allCases, id: \.self) { career in
                    CareerRow(
                        imageName: rowImageName(for: career),
                        title: career.rawValue,
                        description: career.description,
                        state: rowState(for: career)
                    )
                }
            }
        }
        .scrollIndicators(.never)
        .frame(height: 300)
    }

    private func rowState(for career: Career) -> CareerRow.CareerRowState {
        let index = Career.allCases.firstIndex(of: career) ?? 0
        let current = Career.allCases.firstIndex(of: currentCareer) ?? 0
        if index < current { return .achieved }
        if index == current { return .current }
        return .upcoming
    }

    private func rowImageName(for career: Career) -> String {
        let index = Career.allCases.firstIndex(of: career) ?? 0
        let current = Career.allCases.firstIndex(of: currentCareer) ?? 0
        return index > current ? "profileLocked" : career.imageName
    }
}
