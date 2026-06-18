//
//  NewQuizGameView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 6/18/26.
//

import SwiftUI

import DUDesignSystem

struct NewQuizGameView: View {
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack(spacing: 0) {
                HStack(spacing: TokenSpacing.xs) {
                    DUIcon(.dogFace, size: .size28)
                    DUIcon(.dogFoot, size: .size28)
                    ItemLabel(text: "개발 퀴즈", font: .title1, color: .black300)
                }
                Spacer()
                DUIcon(.close, size: .size28)
            }
            .padding(.top, TokenGrid.paddingTop)
            .padding(.bottom, TokenGrid.paddingBottom)

            // 타이머
            VStack(spacing: TokenSpacing.xs) {
                HStack(spacing: 0) {
                    ItemLabel(text: "1/3", font: .label, color: .black300)
                    Spacer()
                    ItemLabel(text: "남은시간", font: .label, color: .black300)
                }
                ProgressBar(progress: 0.5)
            }
            .padding(.bottom, TokenSpacing.xl)

            // 문제, 보상
            VStack(spacing: TokenSpacing.xl) {
                HStack(spacing: 0) {
                    ItemLabel(text: "개발자가 커피를 못마시는 이유는?", font: .body, color: .black300)
                    Spacer()
                }
                HStack(spacing: 0) {
                    Spacer()
                    ItemLabel(text: "20", icon: .diamond, iconSize: .size20, font: .subheadline, color: .black300)
                }
            }
            .padding(.bottom, TokenSpacing.xl)

            // 해설
            HStack(spacing: 0) {
                ItemLabel(text: "정답/어쩌구저쩌구다", font: .label, color: .accentGreen)
                Spacer()
            }

            Spacer()

            // 선지 버튼
            VStack(spacing: TokenSpacing.md) {
                QuizButton(text: "1", state: .default) {}
                QuizButton(text: "1", state: .default) {}
                QuizButton(text: "1", state: .default) {}
                QuizButton(text: "1", state: .default) {}
            }
            .padding(.bottom, TokenSpacing.lg)

            // 제출 버튼
            TextButton(text: "제출하기", type: .primary) {

            }
            .padding(.bottom, TokenGrid.paddingBottom)
        }
        .padding(.horizontal, TokenGrid.paddingSide)
        .background(Color.beige50)
    }
}

#Preview {
    NewQuizGameView()
}
