//
//  InviteRewardPopupView.swift
//  SoloDeveloperTraining
//
//  Created by 김성훈 on 10/29/26.
//

import SwiftUI

import DUDesignSystem

struct InviteRewardPopupView: View {
    let friendNickname: String
    let rewardDiamond: Int
    let onLater: () -> Void
    let onClaim: () -> Void

    var body: some View {
        VStack(spacing: TokenSpacing.lg) {
            ItemLabel(text: "초대 보상 도착", font: .title2, color: .black300)
            ItemLabel(
                text: "\(friendNickname)님이 내 초대 코드를 입력했어요.\n초대 보상을 받을까요?",
                font: .body,
                color: .gray400
            )

            rewardBox

            HStack(spacing: TokenSpacing.sm) {
                TextButton(text: "나중에", type: .secondary, size: .large) {
                    SoundService.shared.trigger(.click)
                    onLater()
                }
                TextButton(text: "수령", type: .primary, size: .large) {
                    SoundService.shared.trigger(.click)
                    onClaim()
                }
            }
        }
        .padding(TokenSpacing.lg)
        .background(Color.white300)
        .clipShape(RoundedRectangle(cornerRadius: TokenRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: TokenRadius.lg).stroke(Color.gray700, lineWidth: 2))
        .padding(.horizontal, TokenGrid.marginPopUp)
    }
}

private extension InviteRewardPopupView {
    var rewardBox: some View {
        ItemLabel(
            text: "\(rewardDiamond)",
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
        InviteRewardPopupView(
            friendNickname: "신입이에요",
            rewardDiamond: InviteConstants.inviterRewardDiamond,
            onLater: {},
            onClaim: {}
        )
    }
}
