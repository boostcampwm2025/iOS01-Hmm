//
//  CareerPopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 1/22/26.
//

import SwiftUI
import DUDesignSystem

private struct ScrollBottomKey: PreferenceKey {
    static let defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CareerPopupView: View {
    let careerSystem: CareerSystem
    let user: User
    let onClose: () -> Void
    let onRebirth: () -> Void

    @State private var isScrollable = false

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
        .analyticsScreen(.career)
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
        ZStack(alignment: .bottom) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: TokenSpacing.md) {
                        ForEach(Career.allCases, id: \.self) { career in
                            CareerRow(
                                imageName: rowImageName(for: career),
                                title: career.rawValue,
                                description: career.description,
                                state: rowState(for: career)
                            )
                            .id(career)
                        }
                        if canShowRebirthRow {
                            HStack(alignment: .center, spacing: TokenSpacing.sm) {
                                CareerRow(
                                    imageName: "profileNewUser",
                                    title: "환생",
                                    description: "다시 시작해볼까?",
                                    state: .current
                                )
                                TextButton(
                                    text: "환생하기",
                                    type: .priority,
                                    size: .small,
                                    action: {
                                    SoundService.shared.trigger(.click)
                                    onRebirth()
                                })
                            }
                        }
                    }
                    .overlay(alignment: .bottom) {
                        GeometryReader { geo in
                            Color.clear
                                .preference(
                                    key: ScrollBottomKey.self,
                                    value: geo.frame(in: .named("careerScroll")).maxY
                                )
                        }
                        .frame(height: 1)
                    }
                }
                .coordinateSpace(name: "careerScroll")
                .frame(height: 300)
                .scrollIndicators(.never)
                .onAppear {
                    withAnimation(TokenAnimation.moveSmooth.animation) {
                        proxy.scrollTo(currentCareer, anchor: .top)
                    }
                }
                .onPreferenceChange(ScrollBottomKey.self) { maxY in
                    isScrollable = maxY > 301
                }
            }

            if isScrollable {
                LinearGradient(
                    colors: [
                        Color.white300.opacity(0),
                        Color.white300
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 40)
                .allowsHitTesting(false)
            }
        }
        .scrollIndicators(.never)
        .frame(height: 300)
    }

    private func rowState(for career: Career) -> CareerRow.CareerRowState {
        let index = Career.allCases.firstIndex(of: career) ?? 0
        let current = Career.allCases.firstIndex(of: currentCareer) ?? 0
        if index < current { return .achieved }
        if index == current && !canShowRebirthRow { return .current }
        if index == current && canShowRebirthRow { return .achieved }
        return .upcoming
    }

    private var canShowRebirthRow: Bool {
        user.record.scenarioProgress.isComplete(.worldClassDeveloper)
    }

    private func rowImageName(for career: Career) -> String {
        let index = Career.allCases.firstIndex(of: career) ?? 0
        let current = Career.allCases.firstIndex(of: currentCareer) ?? 0
        return index > current ? "profileLocked" : career.imageName
    }
}
