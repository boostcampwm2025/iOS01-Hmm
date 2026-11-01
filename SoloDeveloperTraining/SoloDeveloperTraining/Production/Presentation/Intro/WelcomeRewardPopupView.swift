//
//  WelcomeRewardPopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/29/26.
//

import SwiftUI

import DUDesignSystem

struct WelcomeRewardPopupView: View {
    let onClaim: () -> Void

    var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            ItemLabel(text: "웰컴 보상", font: .title2, color: .black300)
            ItemLabel(
                text: "초대 코드가 확인됐어요.\n친구 덕분에 다이아를 받아요.",
                font: .body,
                color: .gray400
            )

            rewardBox

            TextButton(text: "보상 받기", type: .primary, size: .large) {
                SoundService.shared.trigger(.click)
                onClaim()
            }
        }
        .padding(TokenSpacing.lg)
        .background(Color.white300)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.lg).stroke(Color.gray700, lineWidth: 2))
        .padding(.horizontal, TokenGrid.marginPopUp)
    }
}

private extension WelcomeRewardPopupView {
    var rewardBox: some View {
        ItemLabel(
            text: "\(InviteConstants.welcomeRewardDiamond)",
            icon: .diamond,
            iconSize: .size38,
            font: .title1,
            color: .black300
        )
        .frame(maxWidth: .infinity)
        .padding(.vertical, TokenSpacing.md)
        .background(Color.beige100)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.md))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.md).stroke(Color.beige300, lineWidth: 2))
    }
}

#Preview {
    ZStack {
        Color.black300.ignoresSafeArea()
        WelcomeRewardPopupView(onClaim: {})
    }
}
